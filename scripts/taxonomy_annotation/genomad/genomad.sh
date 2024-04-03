#!/bin/sh
# The aim of this script is to extract viral taxonomy and proteins from the final metatranscriptome assembly.

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh


# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
TRANSCRIPTOME="$WORK_DIR/working/assembly/cross_assembly/final_transcriptome.fasta"

# Making output directories for fastqc and multiqc
OUTPUT_DIR="$WORK_DIR/working/taxonomy_annotation/genomad"
mkdir -p $OUTPUT_DIR
GENOMAD_DB="/data/gent/vo/001/gvo00125/vsc44392/viral_tools/genomad/genomad_db"

# Activating conda
. ~/.bashrc

conda activate genomad

genomad end-to-end --splits 40 --cleanup $TRANSCRIPTOME $OUTPUT_DIR $GENOMAD_DB

conda deactivate