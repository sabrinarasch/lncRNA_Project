Sabrina Rasch (sabrina.rasch@student.unibe.ch)

# RNA-sequencing Project: Long noncoding RNAs

This is a project of the course *RNA sequnecing* (467713) of the University of Bern. It takes place in the Fall Semester 2022.

There are two groups of the project and this analysis belongs to group 1. Group 1 analyses the holoclonal and parental replicates.

Path to my project folder: **/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch**

## Files

* Holoclonal
    * Path: /data/courses/rnaseq_course/lncRNAs/fastq/1\*
    * Replicates: 1.1, 1.2, 1.5
    * 1_1_L3_R1_001_ij43KLkHk1vK.fastq.gz
    * 1_1_L3_R2_001_qyjToP2TB6N7.fastq.gz
    * 1_2_L3_R1_001_DnNWKUYhfc9S.fastq.gz
    * 1_2_L3_R2_001_SNLaVsTQ6pwl.fastq.gz
    * 1_5_L3_R1_001_iXvvRzwmFxF3.fastq.gz
    * 1_5_L3_R2_001_iXCMrktKyEh0.fastq.gz
* Parental
    * Path: /data/courses/rnaseq_course/lncRNAs/fastq/P\*
    * Replicates: P1, P2, P3
    * P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz
    * P1_L3_R2_001_yd9NfV9WdvvL.fastq.gz
    * P2_L3_R2_001_06FRMIIGwpH6.fastq.gz
    * P2_L3_R2_001_06FRMIIGwpH6.fastq.gz
    * P3_L3_R1_001_fjv6hlbFgCST.fastq.gz
    * P3_L3_R2_001_xo7RBLLYYqeu.fastq.gz
* References: Human genome version hg38/GRCh38
    * [Reference genome fasta file](https://www.gencodegenes.org/human/release_21.html); Fetched on the 13.11.2022 by Roman Schwob
    * [Reference genome gtf file](https://www.gencodegenes.org/human/release_21.html); Fetched on the 13.11.2022 by Roman Schwob
    * [Reference genome bed file](https.//sourceforge.net/projects/rseqc/files/BED/Human_Homo_sapiens/); Fetched on the 24.11.2022 by Sabrina Rasch
    
## Steps

1. Read quality and statistics:
    * Questions
        * How many reads do you have for each replicate?
        * How is the quality of these reads?
    * Software
        * FASTQC 0.11.0
    * Script
        * 1_QC.slurm
    * Input
        * RawData/1\*fastq.gz
        * RawData/P\*fastq.gz
    * Output in 1_QC
        * *\*sample\**.zip
        * *\*sample\**.html
        * NR_reads.txt
2. Read mapping
    * Questions
        * What are the alignment rates for your samples?
    * Software
        * HISAT2 2.2.1
        * samtools 1.10
    * Script
        * 2_Mapping.slurm
    * Input
        * RawData/1\*fastq.gz
        * RawData/P\*fastq.gz
        * RaWData/hisat2_index/GRCh38.genome.fa
        * RawData/hisat2_index/\*.[0-9].ht2
        * 2_Mapping/GRCh38_genome.fai
    * Output in 2_Mapping/*\*cell_line\**
        * *\*cell_line\**_error_hisat2.txt
        * *\*cell_line\**_hisat2.sam
        * *\*cell_line\**_sorted.bam
        * *\*cell_line\**_sorted.bam.bai
        * *\*cell_line\**_unsorted.bam
3. Transcriptome assembly
    * Questions
        * How many exons, transcripts and genes are in your meta-assembly?
        * How many of these are novel, i.e. do not have an associated GENCODE identifier?
        * How many transcripts and genes are composed of just a single exon?
    * Software
        * StringTie 1.3.3b
        * R 4.2.2
            * tidyverse 1.3.2
            * rtracklayer1.58.0
    * Script
        * 3_1_Assembly.slurm
        * 3_2_Counting.Rmd
    * Input
        * 3_1
            * RawData/gencode\-.v21\-.chr\-_patch\-_hapl\-_scaff.annotation.gtf
            * 2_Mapping/*\*cell_line\**/*\*cell_line\**_sorted.bam
        * 3_2
            * 3_Assembly/stringtie_merged.gtf
    * Output 3_Assembly
        * *\*cell_line\**_gene_abund.tab
        * *\*cell_line\**.gtf
        * assembly_GTF_list.txt
        * stringtie_merged.gtf
4. Quantification
    * Questions
        * What units of expression are you using?
        * Does the entire expression level across all genes add up to the expected amount?
        * How many transcripts and genes did you detect? How many novel transcripts and genes did you detect?
    * Software
        * Kallisto 0.46.0
        * cufflinks 2.2.1
    * Script
        * 4_1_Quantification.slurm
        * 4_2_Validation.Rmd
    * Input
        * 4_1
            * 3_Assembly/stringtie_merged.gtf
            * RawData/hisat2_index/GRCh38.genome.fa
            * RawData/1\*fastq.gz
            * RawData/P\*fastq.gz
        * 4_2
            * 4_Quantification/*\*cell_line\**/abunance.tsv
    * Output in 4_Quantification/*\*cell_line\** 
        * *\*cell_line\**_error_Kallisto.txt
        * abundance.h5
        * abundance.tsv
        * run_info.json
5. Differential expression
    * Questions
        * Do known/expected genes change as expected?
    * Software
        * R 4.2.2
            * sleuth 0.30.1
            * tidyverse 1.3.2
            * rtracklayer1.58.0
    * Script
        * 5_Sleuth.Rmd
    * Input
        * 5_Differential_Expression/experiment_table.csv
        * 3_Assembly/stringtie_merged.gtf
        * 4_Quantification/*\*cell_line\**/abundance.h5
    * Output in 5_Differential_Expression
        * gene_transcript_map.csv
        * sleuth_lrt_[gene/transcript].csv
        * sleuth_lrt_[gene/transcript]_significant.csv
        * sleuth_wt_[gene/transcript].csv
        * sleuth_wt_[gene/transcript]_significant.csv
        * sleuth object (so_[gene/transcript])
6. Integrative analysis
    * Questions
        * How good are the 5’ and 3’ annotations of your transcripts? What percent of your novel transcripts are protein coding?
        * How many novel “intergenic” genes have you identified?
    * Software
    * Script
    * Input
    * Output
        * Statistics and plots addressing key questions
7. ***Optional*** Prioritization
    * How would you prioritize your data to provide her with a ranked list of candidates?
    * Software:
    * Script:
    * Input: 
    * Output: Ranked list of gene candidates

