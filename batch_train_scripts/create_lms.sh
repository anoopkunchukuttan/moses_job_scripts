#!/bin/bash

# read system configuration 
JOB_SCRIPTS_DIR=`dirname \`dirname $0\``
. "$JOB_SCRIPTS_DIR/moses_env.conf"

# create language models for all the monolingual corpora in a input directory
# params:
# input_dir: dir containing corpora files, one for each language. Files should be
#           named as <lang_code>.<ext> 
#           lang code is 2 letter ISO codes (with extensions)
# lm_dir: output dir contain language models named as <language_code>.lm

input_dir=$1
lm_dir=$2

for l in `ls $input_dir`
do
    lang=`echo $l|cut -f 1 -d '.'`
    $JOB_SCRIPTS_DIR/train_srilm.sh $input_dir/$l 5 $lm_dir/$lang.lm
done
