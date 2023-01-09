#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=hisat2
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_hisat2_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_hisat2_%j.e

#Add the modules
    module add UHTS/Aligner/hisat/2.2.1
    module add UHTS/Analysis/samtools/1.10

#Make directories and variables
    course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch
    cell_line=$1

    raw_data_dir=${course_dir}/RawData
    reads_dir=${raw_data_dir}/Reads
        sample_fwd=${reads_dir}/${cell_line}*R1*.fastq.gz
        sample_bwd=${reads_dir}/${cell_line}*R2*.fastq.gz
    
    hisat2_index_dir=${raw_data_dir}/hisat2_index
        mkdir ${hisat2_index_dir}
    
    genome_name=GRCh38.genome
    ln -s /data/courses/rnaseq_course/lncRNAs/Project1/references/${genome_name}.fa ${hisat2_index_dir}
        ref_fasta=${hisat2_index_dir}/${genome_name}.fa

    hisat2_dir=${course_dir}/2_Mapping
        mkdir ${hisat2_dir}
    cell_line_dir=${hisat2_dir}/${cell_line}
        mkdir ${cell_line_dir}

    hisat2_out_file=${cell_line_dir}/${cell_line}_hisat2.sam
    bam_unsorted=${cell_line_dir}/${cell_line}_unsorted.bam
    bam_sorted=${cell_line_dir}/${cell_line}_sorted.bam

    samindex=${raw_data_dir}/${genome_name}.fa.fai

#Build reference hisat2 index (after once doing this it can be commented)
    # hisat2-build -p 16 ${ref_fasta} ${genome_name}
    #Options entered here are:
        #"-p 16": Launch 16 parallel build threads.
        #"${ref_fasta}": A comma-separated list of FASTA files containing the reference sequences to be aligned to.
        #"${genome_name}": The basename of the index files to write.

ref_hisat2=${hisat2_index_dir}/${genome_name}

#Do the mapping
    hisat2 -p 8 --dta --rna-strandness RF -x ${ref_hisat2} -1 ${sample_fwd} -2 ${sample_bwd} -S ${hisat2_out_file}
    #Options entered here are:
        #"-p 8": Launch 8 parallel build threads.
        #"-–dta": Report alignments tailored for transcript assemblers including StringTie.
        #"--rna-strandness RF": Specify strand-specific information.
        #"-x ${ref_hisat2}": The basename of the index for the reference genome. 
        #"-1 ${sample_fwd}/-2 ${sample_bwd}": Comma-separated list of files containing reads
        #"-S ${hisat2_out_file}": File to write SAM alignments to.

#Output is a SAM file but we want a BAM file, we have to convert them. 
#Index reference for samtools (after once doing this it can be commented)
    # samtools faidx ${ref_fasta} -o ${samindex}
    #Options entered here are:
        #"faidx": Index reference sequence in the FASTA format.
        #"-o": Write FASTA to file rather than to stdout.

#Convert SAM to BAM
    samtools view -b -t ${samindex} ${hisat2_out_file} > ${bam_unsorted}
    #Options entered here are:
        #"view": Views and converts SAM/BAM/CRAM files.
        #"-b": Output in the BAM format.
        #"-t ${samindex}": A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference.
        #"${hisat2_out_file}": Input file.
        #"${bam_unsorted}": Output file.

#Sort BAM
    samtools sort -o ${bam_sorted} ${bam_unsorted}
    #Options entered here are:
        #"sort": Sort alignments by leftmost coordinates, or by read name when -n is used. 
        #"-o ${bam_sorted}": Write the final sorted output to file, rather than to standard output.
        #"${bam_unsorted}": Input file

#Index BAM
    samtools index ${bam_sorted}
    #Options entered here are:
        #"index ${bam_sorted}": Index coordinate-sorted BGZIP-compressed SAM, BAM or CRAM files for fast random access.