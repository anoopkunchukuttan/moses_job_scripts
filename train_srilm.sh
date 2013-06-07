#!/bin/bash 

corpus=$1
order=$2
lm_file=$3

$SRILM_CMD  -order $order \
            -interpolate \
            -kndiscount \
            -text $corpus \
            -lm $lm_file
