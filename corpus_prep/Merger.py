#Merger

import os,sys,codecs

def merge_files(f1,f2):
    with codecs.open(f1,"a","utf-8") as file1:
        with codecs.open(f2,"r","utf-8") as tempfile:
            while True:
                data = tempfile.read(65536)
                if data:
                    file1.write(data)
                else:
                    break
           
path = sys.argv[1]
out = sys.argv[2]

files = os.listdir(path)
files.sort()
open (out,"w")

for f in files:
	path_j = path+"/"+f
	print f
	merge_files(out,path_j)
	#os.remove(path_j)

