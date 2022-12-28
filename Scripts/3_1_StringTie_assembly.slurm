#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH --time=05:00:00
#SBATCH --mem=40G
#SBATCH --job-name=StringTie_assembly
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_StringTie_assembly_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_StringTie_assembly_%j.e

#Add the modules
module add UHTS/Aligner/stringtie/1.3.3b

#Make directories and variables
cell_line=$1
course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch

raw_data_dir=${course_dir}/RawData

StringTie_out_dir=${course_dir}/3_StringTie_Results
mkdir ${StringTie_out_dir}

hisat2_dir=${course_dir}/2_Mapping_Results
cell_line_dir=${hisat2_dir}/${cell_line}
read_alignments=${cell_line_dir}/${cell_line}_sorted.bam

reference=/data/courses/rnaseq_course/lncRNAs/Project1/references/gencode.v21.chr_patch_hapl_scaff.annotation.gtf

#Do the assembly (after doing this for all cell lines do the meta-assembly)
# stringtie --rf -G ${reference} -o ${StringTie_out_dir}/${cell_line}.gtf ${read_alignments} -A ${StringTie_out_dir}/${cell_line}_gene_abund.tab
#Options entered here are:
    #"--rf": Assumes a stranded library fr-firststrand.
    #"-G": Use a reference annotation file (in GTF or GFF3 format) to guide the assembly process. The output will include expressed reference transcripts as well as any novel transcripts that are assembled.
    #"-o": Sets the name of the output GTF file where StringTie will write the assembled transcripts. This can be specified as a full path, in which case directories will be created as needed. By default StringTie writes the GTF at standard output.
    #"-A": Gene abundances will be reported (tab delimited format) in the output file with the given name.

#Make the meta-assembly GTF
ls -1 ${StringTie_out_dir}/*.gtf > ${StringTie_out_dir}/assembly_GTF_list.txt
stringtie --rf --merge -o ${StringTie_out_dir}/stringtie_merged.gtf -G ${reference} ${StringTie_out_dir}/assembly_GTF_list.txt
#Options entered here are:
    #"–-rf": tells StringTie that our data is stranded and to use the correct strand specific mode (i.e. assume a stranded library fr-firststrand).
    #"--merge": Transcript merge mode. This is a special usage mode of StringTie, distinct from the assembly usage mode described above. In the merge mode, StringTie takes as input a list of GTF/GFF files and merges/assembles these transcripts into a non-redundant set of transcripts. This mode is used in the new differential analysis pipeline to generate a global, unified set of transcripts (isoforms) across multiple RNA-Seq samples.
    #"-o": Sets the name of the output GTF file. This can be specified as a full path, in which case directories will be created as needed. By default StringTie writes the GTF at standard output.
    #"-G": Use a reference annotation file (in GTF or GFF3 format) to guide the assembly process. The output will include expressed reference transcripts as well as any novel transcripts that are assembled.
    #"assembly_GTF_list.txt": is a text file with a list (one per line) of GTF files that you would like to merge together into a single GTF file.
