#!/bin/sh
# The aim of this script is to assess the quality of the final metatranscriptome assembly.

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh


# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
DATA_BASE_DIR="$WORK_DIR/working/assembly/cross_assembly"

# Making output directories for fastqc and multiqc
OUTPUT_DIR="$WORK_DIR/working/assembly/cross_assembly/rnaquast"
mkdir -p $OUTPUT_DIR

cd $DATA_BASE_DIR
# `sample_list.csv` contains a list of samples

# Activate conda
. ~/.bashrc

# Activate conda environment
conda activate rnaquast #contains rnaQUAST

# Defining reference database
REFERENCE="/data/gent/vo/001/gvo00125/vsc44392/viral_tools/phylodb/phylodb_database/phylodb_1.076.pep.fa"
RNAQUAST_DIR="/data/gent/vo/001/gvo00125/vsc44392/viral_tools/rnaquast"
# Running rnaSPAdes

echo "rnaQUAST: Processing"

$RNAQUAST_DIR/rnaQUAST.py --transcripts $DATA_BASE_DIR/final_transcriptome.fasta \
                --reference  $REFERENCE \
                --output_dir $OUTPUT_DIR \
                --threads  45
    
echo "rnaQUAST: Processed"


conda deactivate
