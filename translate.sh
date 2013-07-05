#/bin/bash 

INPUT_FILE="$1"
OUTPUT_FILE="$2"
MODEL_DIR="$3"
MOSES_DECODER_OPTS="$4"

JOB_SCRIPTS_DIR=`dirname $0`
. "$JOB_SCRIPTS_DIR/moses_env.conf"

$MOSES_CMD -config "$MODEL_DIR/moses.ini" \
           -input-file "$INPUT_FILE" \
           $MOSES_DECODER_OPTS > \
           "$OUTPUT_FILE"
           
