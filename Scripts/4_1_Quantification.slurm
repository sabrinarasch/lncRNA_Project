#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=Kallisto
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_Kallisto_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_Kallisto_%j.e

#Add the modules
    module add UHTS/Analysis/kallisto/0.46.0
    module add UHTS/Assembler/cufflinks/2.2.1

#Make directories and variables
    course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch
    cell_line=$1

    raw_data_dir=${course_dir}/RawData
    reads_dir=${raw_data_dir}/Reads
        sample_fwd=${reads_dir}/${cell_line}*R1*.fastq.gz
        sample_bwd=${reads_dir}/${cell_line}*R2*.fastq.gz
    stringtie_gtf=${course_dir}/3_Assembly/stringtie_merged.gtf
    ref_fasta=${raw_data_dir}/hisat2_index/GRCh38.genome.fa

    Kallisto_dir=${course_dir}/4_Quantification
        mkdir ${Kallisto_dir}
    cell_line_dir=${Kallisto_dir}/${cell_line}
        mkdir ${cell_line_dir}

#Make the transcriptome fasta with gffread for the kallisto index (after once doing this it can be commented)
    # gffread ${stringtie_gtf} -g ${ref_fasta} -w transcriptome.fasta #Move transcriptome.fasta into RawData
    #Options entered here are:
        #"${stringtie_gtf}": Input GTF file.
        #"-g ${ref_fasta}": full path to a multi-fasta file with the genomic sequences for all input mappings
        #"-w transcriptome.fasta": write a fasta file with spliced exons for each GFF transcript
    ref_transcriptome=${raw_data_dir}/transcriptome.fasta

#Make a kallisto index (after once doing this it can be commented)
    # kallisto index -i ${raw_data_dir}/kallisto_index.idx ${ref_transcriptome}
    #Options entered here are:
        #"index": Makes an index for Kallisto analysis
        #"-i ${raw_data_dir}/kallisto_index.idx": Filename for the kallisto index to be constructed
        #"${ref_transcriptome}": fasta file to be indexed
    kallisto_index=${raw_data_dir}/kallisto_index.idx

#Make the kallisto quantification
    kallisto quant -i ${kallisto_index} -o ${cell_line_dir} --rf-stranded -b 30 -g ${course_dir}/3_Assembly/stringtie_merged.gtf ${sample_fwd} ${sample_bwd}
    # Options entered here are:
        #"quant": runs the quantification algorithm.
        #"–i ${raw_data_dir}/kallisto_index.idx": Filename for the kallisto index to be used for quantification
        #"–o ${cell_line_dir}": Directory to write output to.
        #"--rf-stranded": Strand specific reads, first read reverse.
        #"-b 30": Number of bootstrap samples
        #"–g ${course_dir}/3_Assembly/stringtie_merged.gtf": GTF file for transcriptome information
        #"${sample_fwd}/${sample_bwd}": file of forward and backward reads.

#When finised copy the text from the error file and the run_info.json into a text file.