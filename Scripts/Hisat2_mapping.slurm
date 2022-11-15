#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH --time=05:00:00
#SBATCH --mem=40G
#SBATCH --job-name=Hisat2_mapping
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_hisat2_mapping_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_hisat2_mapping_%j.e

#Add the modules
module add UHTS/Aligner/hisat/2.2.1

#Make directories and variables
cell_line=$1
course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

raw_data_dir=${course_dir}/RawData
sample_fwd=${raw_data_dir}/${cell_line}*R1*.fastq.gz
sample_bwd=${raw_data_dir}/${cell_line}*R2*.fastq.gz

ref_dir=/data/courses/rnaseq_course/lncRNAs/Project1/references
ref_genome=${ref_dir}/*.fa
genome_name=GRCh38_genome

out_dir=${course_dir}/2_Mapping_Results
mkdir ${out_dir}
out_file=${out_dir}/${cell_line}_hisat2.sam

#Build reference hisat2 index (after once doing this it can be commented)
# hisat2-build -p 16 ${ref_genome} ${genome_name}
#Options entered here are:
    #"-p 16": use of 16 threads
    #"${ref_genome}": file of the reference genome to be indexed
    #"${genome_name}": name we give the genome

ref_hisat2=${ref_dir}/${genome_name}

#Do the mapping
hisat2 -p 8 --dta -x ${ref_hisat2} -1 ${sample_fwd} -2 ${sample_bwd} -S ${out_file}
#Options entered here are:
    #"-p 8": use of 8 threads
    #"–dta": generate output SAM files that can be directly read into StringTie
    #"-x": used to denote the indexed reference genome
        #"${ref_hisat2}": file of indexed reference genome but without the endings of the files (*.X.ht2)
    #"-1/-2": are used to denote our forward and backward samples in a paired-end alignment
        #"${sample_fwd}/${sample_bwd}": file of forward and backward sample
    #"-S": output in SAM format
        #"${out_file}": file where the SAM output should go