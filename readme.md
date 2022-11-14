Sabrina Rasch (sabrina.rasch@student.unibe.ch)

# RNA-sequencing Project: Long noncoding RNAs

This is a project of the course *RNA sequnecing* (467713) of the University of Bern. It takes place in the Fall Semester 2022.

There are two groups of the project and this analysis belongs to group 1. The files that are analysed are:

## Files

* Holoclonal = 1.1, 1.2, 1.5
    * 1_1_L3_R1_001_ij43KLkHk1vK.fastq.gz
    * 1_1_L3_R2_001_qyjToP2TB6N7.fastq.gz
    * 1_2_L3_R1_001_DnNWKUYhfc9S.fastq.gz
    * 1_2_L3_R2_001_SNLaVsTQ6pwl.fastq.gz
    * 1_5_L3_R1_001_iXvvRzwmFxF3.fastq.gz
    * 1_5_L3_R2_001_iXCMrktKyEh0.fastq.gz
* Parental = P1, P2, P3
    * P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz
    * P1_L3_R2_001_yd9NfV9WdvvL.fastq.gz
    * P2_L3_R2_001_06FRMIIGwpH6.fastq.gz
    * P2_L3_R2_001_06FRMIIGwpH6.fastq.gz
    * P3_L3_R1_001_fjv6hlbFgCST.fastq.gz
    * P3_L3_R2_001_xo7RBLLYYqeu.fastq.gz 

## Steps

1. Read quality and statistics:
    * How many reads do you have for each replicate? How is the quality of these reads?
    * Software: FASTQC
    * Script: QC.slurm
    * Input: fastq (zip) files of reads (RawData)
    * Outputs: results of fastQC, text file with number reads for confirmation (1_QC_Results)
2. Read mapping
    * What are the alignment rates for your samples?
    * Human genome version hg38/GRCh38
    * Software: HISAT2 or STAR
    * Script: RNAseq_hisat2_mapping.slurm
    * Input: 
    * Output: BAM file for every replicate
3. Transcriptome assembly
    * How many exons, transcripts and genes are in your meta-assembly? How many of these are novel, i.e. do not have an associated GENCODE identifier? How many transcripts and genes are composed of just a single exon?
    * Software: StringTie or Scallop
    * Script:
    * Input: 
    * Output: One meta-assembly GTF format file
4. Quantification
    * What units of expression are you using? Does the entire expression level across all genes add up to the expected amount? How many transcripts and genes did you detect? How many novel transcripts and genes did you detect?
    * Software: htseq-count or Kallisto
    * Script:
    * Input: GTF/GFF formate annotation file
    * Output: Transcript and gene level expression tables
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
7. *Optional* Prioritization
    * How would you prioritize your data to provide her with a ranked list of candidates?
    * Software:
    * Script:
    * Input: 
    * Output: Ranked list of gene candidates