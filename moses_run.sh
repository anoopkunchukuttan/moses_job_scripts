#!/bin/bash 

####
# Script to train, decode, test and evaluate phrase based SMT systems using Moses
# 
# Usage: moses_run.sh <config_file>
#
# The config file. A sample can be found in sample_data/sample_moses_params.conf
#  
#####

# read system configuration 
JOB_SCRIPTS_DIR=`dirname $0`
. "$JOB_SCRIPTS_DIR/moses_env.conf"

# commandline parameters 
moses_run_params_file="$1"
. "$moses_run_params_file"

# prepare workspace 
if [ -d $WORKSPACE_DIR ]
then 
    rm -rf $WORKSPACE_DIR
fi 

mkdir "$WORKSPACE_DIR"           > /dev/null 2>&1    
mkdir "$WORKSPACE_DIR/log" > /dev/null 2>&1    
mkdir "$WORKSPACE_DIR/cleaned" > /dev/null 2>&1    
mkdir "$WORKSPACE_DIR/lm" > /dev/null 2>&1    
mkdir "$WORKSPACE_DIR/moses_data" > /dev/null 2>&1 
mkdir "$WORKSPACE_DIR/tuning" > /dev/null 2>&1    
mkdir "$WORKSPACE_DIR/evaluation" > /dev/null 2>&1 

# copy parameters 
cp $moses_run_params_file "$WORKSPACE_DIR/run_params.conf" 
echo "Copied parameter file to \$WORKSPACE_DIR/run_params.conf"

echo "Cleaning (and lowercase the english only)"

$SCRIPTS_ROOTDIR/training/clean-corpus-n.perl "$parallel_corpus/train" "$SRC_LANG" "$TGT_LANG" "$WORKSPACE_DIR/cleaned/train.clean" 1 50

echo "Number of sentences in parallel corpus after cleaning" 
wc -l "$WORKSPACE_DIR/cleaned/train.clean.$SRC_LANG"

# train language model 
if [ ! -e "$target_lm" ]
then 
    echo "Training language model"
    $SRILM_CMD  $SRILM_OPTS
else 
    echo "Language model already exists ; skipping training language model" 
fi    

echo "Training model"
$SCRIPTS_ROOTDIR/training/train-model.perl -external-bin-dir $SMT_SYSTEM_DIR/bin \
        -root-dir "$WORKSPACE_DIR/moses_data" \
        -corpus "$WORKSPACE_DIR/cleaned/train.clean" \
        -e "$TGT_LANG" \
        -f "$SRC_LANG" \
        $TRAIN_MODEL_OPTS \
        > $WORKSPACE_DIR/log/training.out 2>$WORKSPACE_DIR/log/training.err

echo "Running decoder on test set using untuned model"

$MOSES_CMD -config "$WORKSPACE_DIR/moses_data/model/moses.ini"  \
           -input-file "$parallel_corpus/test.$SRC_LANG" \
           $MOSES_DECODER_OPTS \
           > "$WORKSPACE_DIR/evaluation/test_no_tun.$TGT_LANG" 2> $WORKSPACE_DIR/log/test_no_tun.err

echo "Evaluation without tuning" 
mkdir -p "$WORKSPACE_DIR/evaluation/results_wo_tuning"
$JOB_SCRIPTS_DIR/evaluate_metrics.sh "$parallel_corpus/test.$TGT_LANG"  "$WORKSPACE_DIR/evaluation/test_no_tun.$TGT_LANG"  "$WORKSPACE_DIR/evaluation/results_wo_tuning"  "$TGT_LANG"

echo "Tuning using MERT"

nice $SCRIPTS_ROOTDIR/training/mert-moses.pl \
        "$parallel_corpus/tun.$SRC_LANG" \
        "$parallel_corpus/tun.$TGT_LANG" \
        "$MOSES_CMD"  \
        "$WORKSPACE_DIR/moses_data/model/moses.ini" \
         --working-dir "$WORKSPACE_DIR/tuning" \
         --rootdir "$SCRIPTS_ROOTDIR"
         $MERT_OPTS > \
         "$WORKSPACE_DIR/log/tuning.out" 2> "$WORKSPACE_DIR/log/tuning.err" 

echo "Running decoder on test set using tuned model"
$MOSES_CMD -config "$WORKSPACE_DIR/tuning/moses.ini" \
           -input-file "$parallel_corpus/test.$SRC_LANG" \
           $MOSES_DECODER_OPTS > \
           "$WORKSPACE_DIR/evaluation/test.$TGT_LANG" 2> $WORKSPACE_DIR/log/test.err

echo "Evaluation after tuning" 
mkdir -p "$WORKSPACE_DIR/evaluation/results_with_tuning"
$JOB_SCRIPTS_DIR/evaluate_metrics.sh "$parallel_corpus/test.$TGT_LANG" "$WORKSPACE_DIR/evaluation/test.$TGT_LANG" "$WORKSPACE_DIR/evaluation/results_with_tuning" "$TGT_LANG"

echo "Run completed"

