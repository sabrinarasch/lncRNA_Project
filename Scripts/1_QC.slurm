#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=QC
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_QC_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_QC_%j.e

#Add the modules
    module add UHTS/Quality_control/fastqc/0.11.9

#Make directories and variables
    course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

    raw_data_dir=${course_dir}/RawData
        mkdir ${raw_data_dir}
    reads_dir=${raw_data_dir}/Reads
        mkdir ${reads_dir}

    QC_dir=${course_dir}/1_QC
        mkdir ${QC_dir}

#Make a symbolic link to the raw data into the just created dir
    ln -s /data/courses/rnaseq_course/lncRNAs/fastq/1* ${reads_dir}
    ln -s /data/courses/rnaseq_course/lncRNAs/fastq/P* ${reads_dir}

#Make the quality analysis
    fastqc -t 2 -o ${QC_dir} ${reads_dir}/*.fastq.gz
    #Options entered here are:
        #"-t 2": Specifies  the  number of files which can be processed simultaneously.
        #"-o ${QC_dir}": Create all output files in the specified output directory.
        #"${reads_dir}/*.fastq.gz": Input fastq files.

#Get the number of reads for the different files
    for file in $(ls -1 /data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/RawData/Reads/*.fastq.gz)
        do
            nr_reads=$(zcat ${file} | grep -E '^@' | wc -l)
            echo "$(basename ${file}) has ${nr_reads} reads." >> ${QC_dir}/NR_reads.txt
        done