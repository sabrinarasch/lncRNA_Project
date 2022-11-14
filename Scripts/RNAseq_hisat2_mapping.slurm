#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH --job-name=QC
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_read_count_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_read_count_%j.e

#Add the modules
module add UHTS/Aligner/hisat/2.2.1

#Make directories and variables
cell_line=$1
course_directory=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

raw_data_direcotry=$course_directory/RawData
sample_fwd=$fastq_dir/${cell_line}*R1*.fastq.gz
sample_rev=$fastq_dir/${cell_line}*R2*.fastq.gz

ref_dir=/data/courses/rnaseq_course/lncRNAs/Project1/references
ref_genome=$ref_dir/*.fa

out_dir=$parent_dir/2_Mapping_Results/hisat2_out
out_file=$out_dir/${cell_line}_hisat2.sam

# build reference hisat2 index (after once doing this it can be commented)
# hisat2-build -p 16 $ref_genome GRCh38_genome
ref_hisat2=$ref_dir/GRCh38_genome


hisat2 -p 8 --dta -x $ref_hisat2 -1 $sample_fwd -2 $sample_rev -S $out_file
# Options entered here are:
# ‘-p 8’ denoting the use of 8 threads
# ‘–dta’ is used to generate output SAM files that can be directly read into StringTie
# ‘-x’ is used to denote the indexed reference genome
# ‘-1’ and ‘-2’ are used to denote our fwd and rev samples in a paired-end alignment
# ‘-S’ is used to denote that we would like our output in SAM format --> can add -S $out_file
# -u/--upto <int> align the first <int> reads or read pairs from the input (after the -s/--skip reads or pairs have been skipped), then stop. Default: no limit.