#!/bin/sh
# The aim of this script is to assemble individual metatranscriptome assemblies per sample.

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh

# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
DATA_DIR="$WORK_DIR/working/qc/trimmomatic"
SAMPLE_LIST="$WORK_DIR/data/sample_list.csv"

# Making output directories for fastqc and multiqc
OUTPUT_DIR="$WORK_DIR/working/assembly/individual_assembly"
mkdir -p $OUTPUT_DIR

cd $DATA_DIR
# `sample_list.csv` contains a list of samples

# Activate conda
. ~/.bashrc

# Activate conda environment
conda activate spades

# Running rnaSPAdes

for sample in $(sed -n '26,26p' $SAMPLE_LIST); do

    echo "rnaSPAdes: Processing $sample"

    rnaspades.py -t 40 -k 75,99,127 -m 220 -1 ${sample}_1_paired.fq.gz -2 ${sample}_2_paired.fq.gz -o $OUTPUT_DIR/${sample}

    # Changing output names

    for file in $OUTPUT_DIR/${sample}/*transcripts*; do

        filename=$(basename -- "$file")
        mv "$file" "$OUTPUT_DIR/${sample}/${sample}_${filename}"

    done

    echo "rnaSPAdes: Processed $sample"

done

conda deactivate
