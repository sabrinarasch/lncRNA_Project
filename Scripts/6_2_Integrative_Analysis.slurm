#!/bin/bash

#SBATCH --cpus-per-task=2
#SBATCH --time=05:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --job-name=Integrative_Analysis
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_Integrative_Analysis_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_Integrative_Analysis_%j.e

#Add the modules
    module add UHTS/Analysis/BEDTools/2.29.2
    module load SequenceAnalysis/GenePrediction/cpat/1.2.4

#Make directories and variables
    course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch
    raw_data_dir=${course_dir}/RawData
        ref_TSS_bed=${raw_data_dir}/hg38_liftover+new_CAGE_peaks_phase1and2.bed.gz
        ref_polyA_bed=${raw_data_dir}/polyA_atlas_cluster_GRCh38_96.bed
        ref_gtf_bed=${raw_data_dir}/reference_gtf.bed
        ref_fasta=${raw_data_dir}/transcriptome.fasta

    bedtools_dir=${course_dir}/6_Integrative_Analysis
        cpat_out=${bedtools_dir}/cpat_output
        mkdir ${bedtools_dir}

#Look for the intersect of the TSS
# bedtools intersect -a ${bedtools_dir}/stringtie_merged_TSS.bed -b ${ref_TSS_bed} -u -s > ${bedtools_dir}/TSS_intersect.tsv
    #Options entered here are:
        #"-a": BAM/BED/GFF/VCF file "A". Each feature in A is compared to B in search of overlaps.
        #"-b": One or more BAM/BED/GFF/VCF file(s) "B".
        #"-u": Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B.
        #"-s": Force “strandedness”. That is, only report hits in B that overlap A on the same strand. By default, overlaps are reported without respect to strand.

#Look for the intersect of the polyA
# bedtools intersect -a ${bedtools_dir}/stringtie_merged_polyA.bed -b ${ref_polyA_bed} -u -s > ${bedtools_dir}/polyA_intersect.tsv
    #Options entered here are:
        #"-a": BAM/BED/GFF/VCF file "A". Each feature in A is compared to B in search of overlaps.
        #"-b": One or more BAM/BED/GFF/VCF file(s) "B".
        #"-u": Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B.
        #"-s": Force “strandedness”. That is, only report hits in B that overlap A on the same strand. By default, overlaps are reported without respect to strand.

#Look for the intersect of the reference gtf
# bedtools intersect -a ${bedtools_dir}/stringtie_merged.bed -b ${ref_gtf_bed} -v -s > ${bedtools_dir}/intergenic_intersect.tsv
    #Options entered here are:
        #"-a": BAM/BED/GFF/VCF file "A". Each feature in A is compared to B in search of overlaps.
        #"-b": One or more BAM/BED/GFF/VCF file(s) "B".
        #"-v": Only report those entries in A that have no overlap in B.
        #"-s": Force “strandedness”. That is, only report hits in B that overlap A on the same strand. By default, overlaps are reported without respect to strand.

cpat.py -g ${ref_fasta} -o ${cpat_out} -x ${bedtools_dir}/Human_Hexamer.tsv -d ${bedtools_dir}/Human_logitModel.RData
    #Options entered here are:
        # "-g ${ref_fasta}": Transcripts either in BED format or mRNA sequences in FASTA format: If this is mRNA sequence file in FASTA format, ignore the ‘-r’ option. The input BED or FASTA file could be regular text file or compressed file (*.gz, *.bz2) or accessible url.
        # "-o {bedtools_dir}": output file. Tab separated text file: geneID <tab> mRNA size <tab> ORF size <tab> Fickett Score <tab> Hexamer Score <tab> Coding Probability.
        # "-x ${bedtools_dir}/Human_Hexamer.tsv": Prebuilt hexamer frequency table (Human, Mouse, Fly, Zebrafish).
        # "-d ${bedtools_dir}/Human_logitModel.RData": Prebuilt training model (Human, Mouse, Fly, Zebrafish). Run ‘make_logitModel.py’ to build logit model out of your own training datset