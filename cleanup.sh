#!/bin/bash 

# cleans up the workspace directory, removing unwanted files. Retains only the files required for the final model

rm -rf  $1/moses_data/{corpus,giza.*}/ $1/moses_data/model/{aligned.grow-diag-final-and,extract.sorted.gz,extract.inv.sorted.gz,extract.o.sorted.gz,lex.e2f,lex.f2e}  $1/cleaned $1/log 

ls $1/tuning | grep -v  '^moses.ini$' | parallel --gnu rm -rf $1/tuning/{}
