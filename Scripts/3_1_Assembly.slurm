#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=StringTie
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_StringTie_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_StringTie_%j.e

#Add the modules
    module add UHTS/Aligner/stringtie/1.3.3b

#Make directories and variables
    course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch
    cell_line=$1

    raw_data_dir=${course_dir}/RawData

    stringtie_dir=${course_dir}/3_Assembly
        mkdir ${stringtie_dir}

    hisat2_dir=${course_dir}/2_Mapping
        cell_line_dir=${hisat2_dir}/${cell_line}
        cell_line_bam=${cell_line_dir}/${cell_line}_sorted.bam

    ln -s /data/courses/rnaseq_course/lncRNAs/Project1/references/gencode.v21.chr_patch_hapl_scaff.annotation.gtf ${raw_data_dir}

    ref_gtf=${raw_data_dir}/gencode.v21.chr_patch_hapl_scaff.annotation.gtf

#Do the assembly (after doing this for all cell lines do the meta-assembly)
    # stringtie --rf -G ${ref_gtf} -o ${stringtie_dir}/${cell_line}.gtf ${cell_line_bam} -A ${stringtie_dir}/${cell_line}_gene_abund.tab
    #Options entered here are:
        #"--rf": Assumes a stranded library fr-firststrand.
        #"-G ${ref_gtf}": Use a reference annotation file (in GTF or GFF3 format) to guide the assembly process. The output will include expressed reference transcripts as well as any novel transcripts that are assembled.
        #"-o ${stringtie_dir}/${cell_line}.gtf": Sets the name of the output GTF file where StringTie will write the assembled transcripts.
        #${cell_line_bam}: Input BAM file.
        #"-A ${stringtie_dir}/${cell_line}_gene_abund.tab": Gene abundances will be reported (tab delimited format) in the output file with the given name.

#Make the meta-assembly GTF
    ls -1 ${stringtie_dir}/*.gtf > ${stringtie_dir}/assembly_GTF_list.txt
    stringtie --merge --rf -o ${stringtie_dir}/stringtie_merged.gtf -G ${ref_gtf} ${stringtie_dir}/assembly_GTF_list.txt
    #Options entered here are:
        #"--merge": Transcript merge mode. This is a special usage mode of StringTie, distinct from the assembly usage mode described above. In the merge mode, StringTie takes as input a list of GTF/GFF files and merges/assembles these transcripts into a non-redundant set of transcripts. This mode is used in the new differential analysis pipeline to generate a global, unified set of transcripts (isoforms) across multiple RNA-Seq samples.
        #"–-rf": Assumes a stranded library fr-firststrand.
        #"-o ${stringtie_dir}/stringtie_merged.gtf": output file name for the merged transcripts GTF 
        #"-G ${ref_gtf}": reference annotation to include in the merging.
        #"assembly_GTF_list.txt": is a text file with a list (one per line) of GTF files that you would like to merge together into a single GTF file.
