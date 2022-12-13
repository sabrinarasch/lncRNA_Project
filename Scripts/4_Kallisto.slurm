#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH --time=05:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --job-name=Kallisto
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_Kallisto_quantification_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_Kallisto_quantification_%j.e

#Add the modules
module add UHTS/Analysis/kallisto/0.46.0
module add UHTS/Assembler/cufflinks/2.2.1

#Make directories and variables
cell_line=$1
course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

raw_data_dir=${course_dir}/RawData
sample_fwd=${raw_data_dir}/${cell_line}*R1*.fastq.gz
sample_bwd=${raw_data_dir}/${cell_line}*R2*.fastq.gz
# reference_gtf=${course_dir}/3_StringTie_Results/stringtie_merged.gtf
# genomic_fasta=/data/courses/rnaseq_course/lncRNAs/Project1/references/GRCh38.genome.fa

Kallisto_out_dir=${course_dir}/4_Kallisto_Results
mkdir ${Kallisto_out_dir}
cell_line_dir=${Kallisto_out_dir}/${cell_line}
mkdir ${cell_line_dir}

#Make the transcriptome fasta with gffread for the kallisto index (after once doing this it can be commented)
# gffread ${reference_gtf} -g ${genomic_fasta} -w transcriptome.fasta #Move transcriptome.fasta into RawData
#Options entered here are:
    #"-g": full path to a multi-fasta file with the genomic sequences for all input mappings
    #"-w": write a fasta file with spliced exons for each GFF transcript
# reference=${raw_data_dir}/transcriptome.fasta

#Make a kallisto index (after once doing this it can be commented)
# kallisto index -i ${Kallisto_out_dir}/kallisto_index.idx ${reference}
#Options entered here are:
    #"-i": Filename for the kallisto index to be constructed

#Make the kallisto quantification
kallisto quant -i ${Kallisto_out_dir}/kallisto_index.idx -o ${cell_line_dir} --rf-stranded -b 30 -g ${course_dir}/3_StringTie_Results/stringtie_merged.gtf ${sample_fwd} ${sample_bwd}
#Options entered here are:
    #"–i": Filename for the kallisto index to be used for quantification
    #"–o": Directory to write output to
    #"–g": GTF file for transcriptome information

#When finised copy the text from the error file and the run_info.json into a text file.