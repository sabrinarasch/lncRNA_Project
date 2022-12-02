Sabrina Rasch (sabrina.rasch@student.unibe.ch)

# RNA-sequencing Project: Long noncoding RNAs

This is a project of the course *RNA sequnecing* (467713) of the University of Bern. It takes place in the Fall Semester 2022.

There are two groups of the project and this analysis belongs to group 1. Group 1 analyses the holoclonal and parental replicates.

Path to my project folder: **/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch**

## Files

* Holoclonal
    * Path: **/data/courses/rnaseq_course/lncRNAs/fastq/1\***
    * Replicates: 1.1, 1.2, 1.5
    * 1_1_L3_R1_001_ij43KLkHk1vK.fastq.gz
    * 1_1_L3_R2_001_qyjToP2TB6N7.fastq.gz
    * 1_2_L3_R1_001_DnNWKUYhfc9S.fastq.gz
    * 1_2_L3_R2_001_SNLaVsTQ6pwl.fastq.gz
    * 1_5_L3_R1_001_iXvvRzwmFxF3.fastq.gz
    * 1_5_L3_R2_001_iXCMrktKyEh0.fastq.gz
* Parental
    * Path: **/data/courses/rnaseq_course/lncRNAs/fastq/P\***
    * Replicates: P1, P2, P3
    * P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz
    * P1_L3_R2_001_yd9NfV9WdvvL.fastq.gz
    * P2_L3_R2_001_06FRMIIGwpH6.fastq.gz
    * P2_L3_R2_001_06FRMIIGwpH6.fastq.gz
    * P3_L3_R1_001_fjv6hlbFgCST.fastq.gz
    * P3_L3_R2_001_xo7RBLLYYqeu.fastq.gz
* Reference
    * Fetched from https://www.gencodegenes.org/human/release_21.html on 14.11.2022.

## Steps

1. Read quality and statistics:
    * How many reads do you have for each replicate? How is the quality of these reads?
    * Software: FASTQC
    * Script: *1_QC.slurm*
    * Input: \*.fastq.gz files of reads (**RawData**)
    * Outputs: \*_fastqc.html/\*_fastqc.zip, text file with number reads (**1_QC_Results**)
2. Read mapping
    * What are the alignment rates for your samples? Human genome version hg38/GRCh38
    * Software: HISAT2 or STAR (I used HISAT2)
    * Script: *2_Hisat2_mapping.slurm*
    * Input: Hisat index files (**/data/courses/rnaseq_course/lncRNAs/Project1/references/\*.[0-9].ht2**)
    * Output: SAM file, text files (changed error files from Hisat2_mapping.slurm script), BAM file (**2_Mapping_Results/*cell_line***)
3. Transcriptome assembly
    1. What is the direction of the reads? Important for StringTie parameters.
        * Software: RSeQC
        * Script: *3_1_Strand_Direction.slurm*
        * Input: Reference in bed format (**RawData/hg38_GENCODE.v38.bed**) and BAM file (**2_Mapping_Results/*cell_line*/*cell_line*_sorted.bam**)
        * Output: Text files (**3_1_Strand_Direction**)
    2. How many exons, transcripts and genes are in your meta-assembly? How many of these are novel, i.e. do not have an associated GENCODE identifier? How many transcripts and genes are composed of just a single exon?
        * Software: StringTie or Scallop (I used StringTie)
        * Script: *3_2_StringTie_assembly.slurm*
        * Input: GTF of reference (**/data/courses/rnaseq_course/lncRNAs/Project1/references/gencode.v21.chr_patch_hapl_scaff.annotation.gtf**) and BAM file (**2_Mapping_Results/*cell_line*/*cell_line*_sorted.bam**)
        * Output: GTF files for each cell line, one meta-assembly GTF format file, gene abundance tables for each cell line, text file with the counts for the questions above (**3_2_StringTie_Results**)
4. Quantification
    * What units of expression are you using? Does the entire expression level across all genes add up to the expected amount? How many transcripts and genes did you detect? How many novel transcripts and genes did you detect?
    * Software: htseq-count or Kallisto
    * Script: *4_Kallisto.slurm*
    * Input: GTF (**3_2_StringTie_Results/stringtie_merged.gtf**) and fasta (**/data/courses/rnaseq_course/lncRNAs/Project1/references/GRCH38.genome.fa**) file from the genome for making the transcriptome (**RawData/transcriptome.fasta**) , GTF (**3_2_StringTie_Results/stringtie_merged.gtf**) and fasta (**RawData/*cell_line***) files from the samples for the kallisto
    * Output: Transcript and gene level expression tables (**4_Kallisto_Results/*cell_line***)
5. Differential expression
    * Do known/expected genes change as expected?
    * Software: DESeq2 or Sleuth
    * Script:
    * Input: 
    * Output: Transcript- and gene-level differential expression tables
6. Integrative analysis
    * How good are the 5’ and 3’ annotations of your transcripts? What percent of your novel transcripts are protein coding? How many novel “intergenic” genes have you identified?
    * Software: CPAT or CPC
    * Script:
    * Input: 
    * Output: Statistics and plots addressing key questions
7. ***Optional*** Prioritization
    * How would you prioritize your data to provide her with a ranked list of candidates?
    * Software:
    * Script:
    * Input: 
    * Output: Ranked list of gene candidates

