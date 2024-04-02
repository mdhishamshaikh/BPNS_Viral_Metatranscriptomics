#!/bin/sh
#The aim of this script is assess the quality of raw reads using FastQC and MultiQC

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh

# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
DATA_DIR="$WORK_DIR/data"

# Making output directories for fastqc and multiqc
mkdir -p $WORK_DIR/working/qc/fastqc
mkdir -p $WORK_DIR/working/qc/multiqc
OUTPUT_DIR="$WORK_DIR/working/qc/"
cd $DATA_DIR
# `sample_list.csv` contains a list of samples

#Activate conda
. ~/.bashrc

#Activate conda environment
conda activate qc

# # Running fastqc
# for sample in $(cat sample_list.csv); do
# echo $sample
#     fastqc -t 5 \
#         -o $OUTPUT_DIR/fastqc \
#         ${sample}*.gz

# done

# Running multiqc
multiqc -d $OUTPUT_DIR/fastqc \
 -o $OUTPUT_DIR/multiqc
