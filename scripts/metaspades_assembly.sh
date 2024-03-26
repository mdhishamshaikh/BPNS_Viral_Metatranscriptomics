#!/bin/bash

#PBS -N metaspades_test_viral_BPNS
#PBS -l nodes=2:ppn=4
#PBS -l walltime=2:00:00

# Activating Conda
. /data/gent/vo/001/gvo00125/vsc44392/miniconda3/bin/activate

# Defining sample (fastq) directory
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_viral_metatranscriptomics/working/metaspades"
SAMPLE_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_viral_metatranscriptomics/data"

# Activating SPAdes conda environment
conda activate spades

# Iterating through the first two samples in sample_list.csv
for sample in $(head -n 1 ${SAMPLE_DIR}/sample_list.csv)
do
    # Specifying output directory for each sample to avoid overwriting
    SAMPLE_OUT_DIR="$WORK_DIR/${sample}"
    mkdir -p "$SAMPLE_OUT_DIR"

    # Running rnaspades.py for each sample
    rnaspades.py -o "$SAMPLE_OUT_DIR" \
    -1 ${SAMPLE_DIR}/${sample}_R1*.gz \
    -2 ${SAMPLE_DIR}/${sample}_R2*.gz \
    -k 75,99,127
done



