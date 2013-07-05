#!/bin/bash 

corpus=$1
order=$2
lm_file=$3

# read system configuration 
JOB_SCRIPTS_DIR=`dirname $0`
. "$JOB_SCRIPTS_DIR/moses_env.conf"

$SRILM_CMD  -order $order \
            -interpolate \
            -kndiscount \
            -text $corpus \
            -lm $lm_file
