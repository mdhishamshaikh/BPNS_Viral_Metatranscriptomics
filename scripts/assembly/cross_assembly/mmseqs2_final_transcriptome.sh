#!/bin/sh
# The aim of this script is to concatenate individual metatranscritpome assemblies and cluster them using mmseqs2

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh


# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
DATA_BASE_DIR="$WORK_DIR/working/assembly/individual_assembly"

# Making output directories for fastqc and multiqc
OUTPUT_DIR="$WORK_DIR/working/assembly/cross_assembly"
mkdir -p $OUTPUT_DIR

cd $DATA_BASE_DIR
# `sample_list.csv` contains a list of samples

# 1.0 Concatenate individual transcriptome assemblies

ls $DATA_BASE_DIR/*/*_transcripts.fasta | grep -v "filter" | xargs cat > $OUTPUT_DIR/combined_assembly.fasta
echo "finished concatenating assemblies"

# Activate conda
. ~/.bashrc

# 2.0 Running MMseqs2

# Activate conda environment
conda activate mmseqs2 #contains mmseqs

cd $OUTPUT_DIR

echo "Started MMseqs2 clustering"
# clustering
mmseqs easy-linclust combined_assembly.fasta cluster_results mmseqs2_tmp --min-seq-id 0.95 -c 0.95 --cov-mode 1 --threads 40

echo "Finished MMseqs2 clustering"

conda deactivate

conda activate anvio

# 3.0 tandardize contig names using Anvi'o
anvi-script-reformat-fasta cluster_results_rep_seq.fasta -o standardized_contigs_assembly.fasta --simplify-names

conda deactivate


# Cleanup temporary directory
rm -r mmseqs2_tmp

# 4.0 ERCC92 spike sequence removal 

cd $OUTPUT_DIR

conda activate mmseqs2

mmseqs easy-search ERCC92_spike/ERCC92.fa standardized_contigs_assembly.fasta  ERCC92_spike/ercc92_alignment.m8 mmseqs2_tmp --search-type 3 --threads 40


cd ERCC92_spike

# Printing the IDs that matched
awk '{print $2}' ercc92_alignment.m8 > matched_ids.txt

# Printing all the IDs from transcriptome fasta
grep "^>" $OUTPUT_DIR/standardized_contigs_assembly.fasta| sed 's/>//' > ERCC92_spike/all_ids.txt

# Inverting the matches
grep -v -f matched_ids.txt all_ids.txt > ids_to_keep.txt

conda deactivate



cd $OUTPUT_DIR

conda activate seqtk
# Removing ERCC92 sequences
seqtk subseq standardized_contigs_assembly.fasta ERCC92_spike/ids_to_keep.txt > final_transcriptome.fasta

#This is the final transcriptome

conda deactivate seqtk