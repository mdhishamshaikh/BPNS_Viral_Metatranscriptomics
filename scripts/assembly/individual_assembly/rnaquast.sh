#!/bin/sh
# The aim of this script is to assess the quality of metatranscriptome assembly.

# Change to the VO part & the home directory
. /user/gent/443/vsc44392/vo_vliz.sh

#Checking if SPAdes finished properly or not

SEARCH_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics/working/assembly/individual_assembly"

# String to search for
SEARCH_STRING="SPAdes pipeline finished"

# Find all .log files in the directory and subdirectories
find "$SEARCH_DIR" -type f -name "*.log" | while read -r file
do
    # Search for the string in each file
    if ! grep -q "$SEARCH_STRING" "$file"; then
        # If the string is not found, print the file name
        echo "String not found in: $file"
    fi
done



# Define directories
WORK_DIR="/data/gent/vo/001/gvo00125/vsc44392/Projects/BPNS_Viral_Metatranscriptomics"
DATA_BASE_DIR="$WORK_DIR/working/assembly/individual_assembly"
SAMPLE_LIST="$WORK_DIR/data/sample_list.csv"

# Making output directories for fastqc and multiqc
OUTPUT_BASE_DIR="$WORK_DIR/working/assembly/rnaquast_individual_assembly"
mkdir -p $OUTPUT_BASE_DIR

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

for sample in $(cat $SAMPLE_LIST); do

    echo "rnaQUAST: Processing $sample"
OUTPUT_DIR="$OUTPUT_BASE_DIR/${sample}"
mkdir $OUTPUT_DIR

    $RNAQUAST_DIR/rnaQUAST.py --transcripts $DATA_BASE_DIR/${sample}/${sample}_transcripts.fasta \
                --reference  $REFERENCE \
                --output_dir $OUTPUT_DIR \
                --threads  45
    
    echo "rnaQUAST: Processed $sample"

done

conda deactivate
