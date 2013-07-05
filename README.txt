README
======
'moses_job_scripts' is a toolkit to help in basic tasks for training and developing SMT systems. It contains:
- Testbench to automate Moses-based SMT system training and evaluation (phrase based and factored)
- Scripts for normalizing and tokenizing text in Indic scripts 
- An adaptation of the METEOR tool for Indian languages 
   Status of support for various languages: 

   Language     Synonym     Stemmer 
   --------------------------------
   Hindi            Y 


Preparing your SMT environment
==============================
- The first task is to install the following software: 
    - Moses 0.91+ 
    - Giza++ 
    - SRILM
    - IRSTLM [optional]
    - METOER
    - TER
- 'moses_job_scripts' requires the Moses and related softwares to be installed as per the directory layout mentioned in section 'Directory layout for SMT software installation'. 
- Each of these have their prerequisites. Please check the README for each of these tools. You can use the following as a guide for installing all these softwares: 
    http://organize-information.blogspot.in/2012/01/yet-another-moses-installation-guide.html
    NOTE: As you can see, installation of these is pretty complicated and a script to automate the installation of the entire system would be desirable. 
    If you end up writing one, sharing that would be appreciated. Please mail me at anoopk@cse.iitb.ac.in. 
- Edit the file and set the variables
   SMT_SYSTEM_DIR: The path to the 'smt' directory 
   SMT_METRICS_DIR: The path to the 'smt_eval_metrics' directory 

Directory layout for SMT software installation
-----------------------------------------------

smt
 |---   giza-pp             (compiled giza++ source code)
 |---   bin                 (contains giza++ binaries - giza-pp/mkcls-v2/mkcls giza-pp/GIZA++-v2/GIZA++ giza-pp/GIZA++-v2/snt2cooc.out )
 |---   moses_job_scripts         (contains scripts to run the entire SMT workflow. It is the directory containing this README )
 |---   mosesdecoder        (moses decoder)
 |---   srilm               (srilm)
 |---   irstlm              (irstlm) [optional]

smt_eval_metrics
 |---  meteor               (Meteor)
 |---  ter                  (TER)


Using the testbench to train and evaluate a translation system
==============================================================
Once the SMT environment is ready, it is pretty easy to use the workbench for running an experiment to train and evaluate a translation system.

1. Create the parallel corpus files to be used for the experiment. The files must be in a single directory and must be named as follows: 
   train.<src_lang>  e.g. train.en
   train.<tgt_lang>
   test.<src_lang>
   test.<tgt_lang>
   tun.<src_lang>
   tun.<tgt_lang>
   
2. Create a configuration file which mentions the experimental settings. A sample configuration file can be found here: sample_data/sample_moses_params.conf 

3. Run the following command: 
           moses_run <config_file>

   The intermediate and final output are generated in the $WORKSPACE directory. 

   The workspace will contain the following directories: 
        log: contains various log files 
        cleaned: cleaned up corpus 
        lm: The target side language model 
        moses_data: The intermediate files and model output after training 
        tuning: The intermediate files and output generated after tuning 
        evaluation: evaluation results 
        run_params.conf: A copy of the config file for the experiment 

   The important files for observing the output are: 
        evaluation/test_no_tun.<tgt_lang> : output from untuned model 
        evaluation/test.<tgt_lang> : output from tuned model
        evaluation/results_wo_tuning/summary.txt : evaluation results without tuning 
        evaluation/results_with_tuning/summary.txt: evaluation results with tuned model 
        moses_data/model/moses.ini : untuned model file
        tuning/moses.ini : tuned model file

Preparing the corpus for training 
=================================
<TBD by Ritesh> 

