#!/bin/bash 

# parameters 
ref_doc="$1"
test_doc="$2"
output_dir="$3"
language="$4"

# read system configuration 
JOB_SCRIPTS_DIR=`dirname $0`
. "$JOB_SCRIPTS_DIR/moses_env.conf"

##### compute BLEU 
$SCRIPTS_ROOTDIR/generic/multi-bleu.perl "$ref_doc" < "$test_doc" > $output_dir/bleu.txt 
bleu_score=`cut -f 1 -d ',' $output_dir/bleu.txt | cut -f 2 -d '=' | tr -d [:space:]`

##### compute METEOR
cd $METEOR_HOME
java -Xmx512m -jar meteor-*.jar "$test_doc" $ref_doc -norm -l $language > $output_dir/meteor.txt
meteor_score=`tail -1 $output_dir/meteor.txt | cut -f 2 -d ':' | tr -d  [:space:]`

###### compute TER

# files have to created in format required by TER
awk '{print $0 " (" NR  ")" }' $ref_doc  >  $output_dir/ref_doc.ter
awk '{print $0 " (" NR  ")" }' $test_doc  >  $output_dir/test_doc.ter

cd $TER_HOME
java -jar tercom.*.jar -r $output_dir/ref_doc.ter -h $output_dir/test_doc.ter -n $output_dir/ter -o sum
rm $output_dir/ref_doc.ter $output_dir/test_doc.ter
ter_score=`tail -1 $output_dir/ter.sum | cut -f 9 -d '|' | tr -d '[:space:]'`

#### generate summary results 
echo "BLEU|METEOR|TER" >>  $output_dir/summary_results.txt
echo "$bleu_score|$meteor_score|$ter_score" >> $output_dir/summary_results.txt

