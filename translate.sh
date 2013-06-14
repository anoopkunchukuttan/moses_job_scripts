#/bin/bash 

INPUT_FILE="$1"
OUTPUT_FILE="$2"
MODEL_DIR="$3"

#MOSES_DECODER_OPTS="-alignment-output-file align_file.txt"
MOSES_DECODER_OPTS=""

JOB_SCRIPTS_DIR=`dirname $0`
. "$JOB_SCRIPTS_DIR/moses_env.conf"

$MOSES_CMD -config "$MODEL_FILE" \
           -input-file "$INPUT_FILE" \
           $MOSES_DECODER_OPTS > \
           "$OUTPUT_FILE"
           
