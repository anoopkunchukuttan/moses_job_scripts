Installing the system
---------------------

- Use the directory layout mentioned in the section 'Directory layout for SMT software installation' 
- The following software needs to be installed: 
    - Moses 0.91+ 
    - Giza++ 
    - SRILM
    - IRSTLM (optional)
    - METOER
    - TER

- Each of these have their prerequisites. Please check the README. You can use the following as a guide for installing all these softwares: 
    http://organize-information.blogspot.in/2012/01/yet-another-moses-installation-guide.html

- Run the script complete_install.sh from 'smt' directory. This is for copying giza++ directories to bin directory

NOTE: As you can see, installation of these is pretty complicated and a script to automate the installation of the entire system would be desirable. 
If you end up writing one, sharing that would be appreciated. Please mail me at anoopk@cse.iitb.ac.in. 


Directory layout for SMT software installation
-----------------------------------------------

smt
 |---   bin                 (contains giza++ binaries. Run complete_install.sh after GIZA++ is installed to create this directory)
 |---   giza-pp             (giza++ source code)
 |---   moses_job_scripts         (contains scripts to run the entire SMT workflow. It is the directory containing this README )
 |---   mosesdecoder        (moses decoder)
 |---   srilm               (srilm)
 |---   irstlm              (irstlm)

smt_eval_metrics
 |---  meteor               (Meteor)
 |---  ter                  (TER)

