#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH --time=05:00:00
#SBATCH --mem=40G
#SBATCH --job-name=Strand_Direction
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_Strand_Direction_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_Strand_Direction_%j.e

#Add the modules
module add UHTS/Quality_control/RSeQC/4.0.0
#Make directories and variables
cell_line=$1
course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

raw_data_dir=${course_dir}/RawData

hisat2_dir=${course_dir}/2_Mapping_Results
cell_line_dir=${hisat2_dir}/${cell_line}
read_alignments=${cell_line_dir}/${cell_line}_sorted.bam

direction_dir=${course_dir}/3_1_Strand_Direction
mkdir ${direction_dir}

#Find the directional stranded
infer_experiment.py -r ${raw_data_dir}/hg38_GENCODE.v38.bed -i ${read_alignments} >> ${direction_dir}/${cell_line}_direction.txt
#Options entered here are:
    #"-r": Reference gene model in bed format
    #"-i": Input alignment file in BAM format

#Summarizing mapping statistics of BAM file.
bam_stat.py -i ${read_alignments} >> ${direction_dir}/${cell_line}_direction.txt
#Options entered here are:
    #"-i": Alignment file in BAM format.
