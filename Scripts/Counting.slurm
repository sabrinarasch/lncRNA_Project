#!/usr/bin/env bash

#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=25G
#SBATCH --time=02:00:00
#SBATCH --job-name=Counting
#SBATCH --mail-user=sabrina.rasch@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Output/output_counting_%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/Error/error_counting_%j.e

course_dir=/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch
StringTie_dir=${course_dir}/3_StringTie_Results
gtf_file=${StringTie_dir}/stringtie_merged.gtf
count_txt=${StringTie_dir}/counting.txt

touch ${count_txt}

echo "How many exons are in the meta-assembly?" >> ${count_txt}
tail -n +2 ${gtf_file} | cut -f3 | grep -c "exon" >> ${count_txt}

echo "How many transcripts are in the meta-assembly?" >> ${count_txt}
tail -n +2 ${gtf_file} | cut -f3 | grep -c "transcript" >> ${count_txt}

echo "How many genes with annotation are in the meta-assembly?" >> ${count_txt}
tail -n +2 ${gtf_file} | cut -f9 | cut -f3 -d ";" | grep "gene_name" | uniq | wc -l >> ${count_txt}

echo "How many novel genes are in the meta-assembly?" >> ${count_txt}
tail -n +2 ${gtf_file} | cut -f9 | cut -f3 -d ";" | grep -v "gene_name" | grep -v "exon_number" | wc -l >> ${count_txt}

echo "How many transcripts are composed of just a single exon?" >> ${count_txt}
tail -n +2 ${gtf_file} | cut -f9 | cut -f2-3 -d ";" | grep "exon" | cut -f1 -d ";" | sort | uniq -u | wc -l >> ${count_txt}
