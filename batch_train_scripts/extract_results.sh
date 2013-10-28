#!/bin/bash 

#
# Script to extract results from multiple output workspace in a single directory 
# $1: workspace_dir: base directory of all workspace directory
# $2: consolidated_results_file: file which consolidates results from all output results
#

workspace_dir=$1
consolidated_results_file=$2

rm $consolidated_results_file

for lang_pair in `ls $workspace_dir`
do
    lang1=`echo $lang_pair|cut -f 1 -d '-'`
    lang2=`echo $lang_pair|cut -f 2 -d '-'`

    tun_results=`cat $workspace_dir/$lang_pair/evaluation/results_with_tuning/summary_results.txt | \
        tail -1 `
    wo_tun_results=`cat $workspace_dir/$lang_pair/evaluation/results_wo_tuning/summary_results.txt | \
        tail -1 `

    echo $lang1'|'$lang2'|'$wo_tun_results'|'$tun_results >> $consolidated_results_file
done


