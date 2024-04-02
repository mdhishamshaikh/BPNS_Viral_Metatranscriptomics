#!/bin/sh
#The aim of this script is to run trimmomatic to extract high quality reads, followed by QC using FatsQC/MultiQC.

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh

# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
DATA_DIR="$WORK_DIR/data"

# Making output directories for fastqc and multiqc
OUTPUT_DIR="$WORK_DIR/working/qc"
mkdir -p $OUTPUT_DIR/trimmomatic
mkdir -p $OUTPUT_DIR/fastqc_trim
mkdir -p $OUTPUT_DIR/multiqc_trim

cd $DATA_DIR
# `sample_list.csv` contains a list of samples

#Activate conda
. ~/.bashrc

#Activate conda environment
conda activate qc

# Running Trimmomatic

# Defining adapters
ADAPTERS="/data/gent/vo/001/gvo00125/vsc44392/miniconda3/envs/qc/share/trimmomatic-0.39-2/adapters/TruSeq2-PE.fa"

for sample in $(cat sample_list.csv); do
echo "Trimmomatic: Processing $sample"
    trimmomatic PE \
        -threads 10 \
        $DATA_DIR/${sample}*R1*.fastq.gz $DATA_DIR/${sample}*R2*.fastq.gz \
        $OUTPUT_DIR/trimmomatic/${sample}_1_paired.fq.gz \
        $OUTPUT_DIR/trimmomatic/${sample}_1_unpaired.fq.gz \
        $OUTPUT_DIR/trimmomatic/${sample}_2_paired.fq.gz \
        $OUTPUT_DIR/trimmomatic/${sample}_2_unpaired.fq.gz \
        ILLUMINACLIP:$ADAPTERS:2:30:7 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:50

done


# Running FastQC
for sample in $(cat sample_list.csv); do
echo "FastQC: Processing $sample"
    fastqc -t 5 \
        -o $OUTPUT_DIR/fastqc_trim \
        $OUTPUT_DIR/trimmomatic/${sample}*.gz

done

# Running MultiQC
multiqc -d $OUTPUT_DIR/fastqc_trim \
 -o $OUTPUT_DIR/multiqc_trim


conda deactivate