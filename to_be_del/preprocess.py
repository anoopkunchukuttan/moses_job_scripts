import codecs, re, string, os, sys

class SmtPreprocessPipeline:

    
    __init__(pipeline_elements,language): 
        pass 
   
    def execute(input_string): 
        

    def tokenize():
        pass

    def lowercase(): 
        pass 

    def normalize_indic():
        pass 

def preprocess_file(input_fname,output_fname,pipeline_elements,language):
    pipeline=SmtPreprocessPipeline(pipeline_elements,language)
    with codecs.open(input_fname,'r','utf-8') as input_file: 
        with codecs.open(output_fname,'w','utf-8') as outputput_file: 
            for line in input_file: 
                processed_line=pipeline.execute(line.strip())
                output_file.write(processed_line + '\n' )

if __name__ == '__main__': 
    input_fname=sys.argv[1]
    output_fname=sys.argv[2]
    pipeline_elements=sys.argv[3].split('|')
    language=sys.argv[4]

    preprocess_file(input_fname,output_fname,pipeline_elements,language)

