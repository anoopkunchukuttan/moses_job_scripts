#!/bin/bash 

# read system configuration 
JOB_SCRIPTS_DIR=`dirname \`dirname $0\``
. "$JOB_SCRIPTS_DIR/moses_env.conf"

# params 
# lang_pair_file: file listing translation pairs, one per line. format: <src_lang_code>-<tgt_lang_code>
#       The corpus will located from a directory containing all the language pairs. This directory is mentioned in 
#       run_for_lang_pairs_template.conf
# out_dir: output directory, within which a directory is created for a workspace corresponding to each language pair
#           being trained
# 
# required: run_for_lang_pairs_template.conf


lang_pair_file=$1
out_dir=$2
config_template=$3

while read lang_pair
do


lang1=`echo $lang_pair|cut -f 1 -d '-'`
lang2=`echo $lang_pair|cut -f 2 -d '-'`
workspace_dir=$out_dir/$lang1-$lang2

mkdir $workspace_dir

# set parameters
cat $config_template | \
sed "s,SRC_LANG_VAR,$lang1,g" | \
sed "s,TGT_LANG_VAR,$lang2,g" \
> $out_dir/run_for_lang_pairs_final.conf

echo "Processing for language pair" $lang1 "-" $lang2 "started at " `date`
nohup $JOB_SCRIPTS_DIR/moses_run.sh  $outdir/run_for_lang_pairs_final.conf > $workspace_dir/run.log 2>&1  
echo "Processing for language pair" $lang1 "-" $lang2 "finished at " `date`

done < $lang_pair_file
