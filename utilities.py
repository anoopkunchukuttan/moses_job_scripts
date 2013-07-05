import re, os, string, itertools, random,sys,codecs

def select_random(input_instances,no_instances):
    """
     select number of random items from an iterable and return selected list  
    """
    results = []

    # sample from positive instances 
    samplesize=no_instances
    for i, v in enumerate(input_instances):
        r = random.randint(0, i)
        if r < samplesize:
            if i < samplesize:
                results.insert(r, v) # add first samplesize items in random order
            else:
                results[r] = v # at a decreasing rate, replace random items

    #if len(results) < samplesize:
    #    raise ValueError("Sample larger than population.")

    return results 

def select_random_parallel_corpus(fname1,fname2,ofname1,ofname2,no_of_instances):
    with codecs.open(fname1,'r','utf-8') as file1 :
        with codecs.open(fname2,'r','utf-8') as file2 :
           selected_sentences=select_random(itertools.izip(iter(file1),iter(file2)),no_of_instances)
           with codecs.open(ofname1,'w','utf-8') as ofile1 :
               with codecs.open(ofname2,'w','utf-8') as ofile2 :
                   for s1,s2 in selected_sentences:
                       ofile1.write(s1)
                       ofile2.write(s2)


if __name__=='__main__':
    select_random_parallel_corpus(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],int(sys.argv[5]))
