#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=25G
#SBATCH --time=02:00:00
#SBATCH --job-name=QC
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_read_count_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_read_count_%j.e

#Add the modules
module add UHTS/Quality_control/fastqc/0.11.9

#Make directories and variables
course_directory=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

mkdir $course_directory/RawData
raw_data_direcotry=$course_directory/RawData

mkdir $course_directory/1_QC_Results
QC_directory=$course_directory/1_QC_Results

#Make a symbolic link to the raw data into the just created directory
ln -s /data/courses/rnaseq_course/lncRNAs/fastq/1* $raw_data_direcotry
ln -s /data/courses/rnaseq_course/lncRNAs/fastq/P* $raw_data_direcotry

#Make the quality analysis
fastqc -t 2 -o $QC_directory $raw_data_direcotry/*.fastq.gz

#Get the number of reads for the different files
for file in $(ls -1 /data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/RawData/*.fastq.gz)
do
    nr_reads=$(zcat $file | grep -E '^@' | wc -l)
    echo "$(basename $file) has $nr_reads reads." >> $QC_directory/NR_reads.txt
done