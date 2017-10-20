"""
Author: V. Rawat
Affiliation: UZH
Aim: A simple Snakemake workflow to convert coverage2cytosine output to Methylkit Input
Date: 
Run: snakemake   -s <Snakefile>   
Version 0.0.2
Latest modification: 15.10.2017 

"""


def message(msg):
    print (msg)

################################################################################

#localrules:trimming,final

##--------------------------------------------------------------------------------------##
## The list of samples to be processed
##--------------------------------------------------------------------------------------##

SAMPLES, = glob_wildcards("/home/ubuntu/data/5TB/Aphid/20170221.{smp}_R1_val_1.fq.gz_bismark_bt2_pe.deduplicated.bismark.cov")
NB_SAMPLES = len(SAMPLES)
for smp in SAMPLES:
  message("Sample " + smp + " will be processed")


### Rule 0
rule final: 
  input: expand("/home/ubuntu/data/5TB/Aphid/{smp}.MethylKit", smp=SAMPLES)
#   input: expand("", smp=SAMPLES)
#Mapping_imputed/BAM/{smp}/20170221.{smp}_R1_val_1.fq.gz_bismark_bt2_pe.bam



### Rule1
rule trimming:
  input:  "/home/ubuntu/data/5TB/Aphid/20170221.{smp}_R1_val_1.fq.gz_bismark_bt2_pe.deduplicated.bismark.cov"
  output: "/home/ubuntu/data/5TB/Aphid/{smp}.MethylKit" 
           
  message: """--- Converting....."""
  shell: """
      awk  -F "\\t" '{{coverage = $4+$5;if($3=="+"){{ $3 = "F"}}; if($3=="-"){{ $3 = "R"  }} if(coverage > 5) {{ meth= ($4*100)/coverage; unmeth =($5*100)/coverage;   print $1 "." $2 "\t" $1 "\t" $2 "\t" $3 "\t" coverage "\t"  meth  "\t" unmeth }}}}' {input} >{output}
            
  """
