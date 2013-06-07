'''
Created on 26-Dec-2012

This program creates mixed and domain specific corpora for SMT 

@author: abhijit
'''
import getopt, sys, os, re, codecs

out_path = "."
in_path = ""
test_percentage = 0.2
tune_percentage = 0.05
create = "all"
verbose = False
src_ext = ".en"
tgt_ext = ".hi"

def write_to_file(path,li):
    to_write = "".join(li)
    with codecs.open(path,"w","utf-8" )as newFile:
        newFile.write(to_write)
    
def split_files(src,tgt,test_percentage,tune_percentage,out):
    with codecs.open(src, "r", "UTF-8") as f1:
        data_src = f1.readlines()
    with codecs.open(tgt, "r", "UTF-8") as f2:
        data_tgt = f2.readlines()
    if len(data_src)==len(data_tgt):
        
        test_split_src = data_src[:int(test_percentage*len(data_src))]
        train_split_src = data_src[int(test_percentage*len(data_src)):]
        tune_split_src = data_src[:int(tune_percentage*len(train_split_src))]
        train_split_src = data_src[int(test_percentage*len(train_split_src)):]
        test_split_tgt = data_tgt[:int(test_percentage*len(data_tgt))]
        train_split_tgt = data_tgt[int(test_percentage*len(data_tgt)):]
        tune_split_tgt= data_tgt[:int(tune_percentage*len(train_split_tgt))]
        train_split_tgt = data_tgt[int(test_percentage*len(train_split_tgt)):]
        write_to_file(out+"/train.en",train_split_src)
        write_to_file(out+"/test.en",test_split_src)
        write_to_file(out+"/tune.en",tune_split_src)
        write_to_file(out+"/train.hi",train_split_tgt)
        write_to_file(out+"/test.hi",test_split_tgt)
        write_to_file(out+"/tune.hi",tune_split_tgt)
    else:
        print len(data_src)
        print len(data_tgt)
        print "data error" +src+"  "+tgt
def print_usage():
    usage = (
             "Standardization of corpus for MT training \n"+
             "-T <parameter> : Testing Parameter (0-1) default 0.2 \n"+
             "-U <parameter> : Tuning Parameter (0-1) default 0.05 \n"+
             "-F <in>: Folder Path \n"+
             "Options: \n"+
             "-D <out> : Output path where the folder would be created \n"+
             "-v : Verbose mode \n"
             "--help : This help \n"
            )
    sys.stderr.write (usage)
    exit(1)

def validate_input(test_percentage,tune_percentage,in_path):
    if (test_percentage < 0.01 or test_percentage >=1):
        sys.stderr.write("Invalid Input -T \n")
        print_usage()
    elif (tune_percentage < 0.01 or tune_percentage >=0.6):
        sys.stderr.write("Invalid Input -F \n")
        print_usage()
    elif (in_path == ""):
        sys.stderr.write("Please specify input path \n")
        print_usage()

def create_dir(dir_path):
    if not os.path.isdir(dir_path):
        os.mkdir(dir_path)
    if (verbose == True):
        print "Created directory: " + dir_path +"\n"

def merge_files(f1,f2):
    with codecs.open(f1,"a","utf-8") as file1:
        with codecs.open(f2,"r","utf-8") as tempfile:
            while True:
                data = tempfile.read(65536)
                if data:
                    file1.write(data)
                else:
                    break
           
        
options, remainder = getopt.getopt(sys.argv[1:], 'T:U:F:D:v', ['test=',
                                                                 'tune=',
                                                                 'input='
                                                                 'output=' 
                                                         'verbose',
                                                         'help',
                                                     ])


for opt, arg in options:
    if opt in ('-T', '--test'):
        test_percentage = float(arg)
    elif opt in ('-U', '--tune'):
        tune_percentage = float(arg)
    elif opt in ('-v', '--verbose'):
        verbose = True
    elif opt in ('-F','--input'):
        in_path = arg
    elif opt in ('-D','--output'):
        out_path = arg
    elif opt == '--help':
        print_usage()

validate_input(test_percentage,tune_percentage,in_path)



out_root = out_path+"/parallel_corpus"
create_dir(out_root)
create_dir(out_root+"/Mixed")
open(out_root+"/Mixed/en","w")
open(out_root+"/Mixed/hi","w")
for root, subFolders, files in os.walk(in_path):
    src = ""
    tgt = ""
    for folder in subFolders:
        folder_path = root+"/"+folder
        for f in os.listdir(folder_path):
            if re.search('\.hi', f):
                tgt = root+"/"+folder+"/"+f
                merge_files(out_root+"/Mixed/hi", tgt)
            elif re.search('\.en', f):
                src = root+"/"+folder+"/"+f
                merge_files(out_root+"/Mixed/en", src)
        create_dir(out_root+"/"+folder)
        split_files(src,tgt,test_percentage,tune_percentage,out_root+"/"+folder)
        
#Bad Bad Bad coding....
split_files(out_root+"/Mixed/en",out_root+"/Mixed/hi",test_percentage,tune_percentage,out_root+"/Mixed")
os.remove(out_root+"/Mixed/hi")
os.remove(out_root+"/Mixed/en")





