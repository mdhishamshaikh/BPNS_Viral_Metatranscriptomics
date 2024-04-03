#!/bin/sh
# The aim of this script is to extract identify open reading frames usng transdecoder from the final metatranscriptome assembly.

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh


# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
TRANSCRIPTOME="$WORK_DIR/working/assembly/cross_assembly/final_transcriptome.fasta"

# Making output directories for fastqc and multiqc
OUTPUT_DIR="$WORK_DIR/working/taxonomy_annotation/transdecoder"
mkdir -p $OUTPUT_DIR

# Activating conda
. ~/.bashrc

conda activate transdecoder

cd $OUTPUT_DIR

TransDecoder.LongOrfs -t $TRANSCRIPTOME -O $OUTPUT_DIR
TransDecoder.Predict -t $TRANSCRIPTOME -O $OUTPUT_DIR


conda deactivate