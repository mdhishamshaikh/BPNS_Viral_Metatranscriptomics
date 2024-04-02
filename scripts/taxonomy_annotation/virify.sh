# Installing VIRify
# https://github.com/EBI-Metagenomics/emg-viral-pipeline?tab=readme-ov-file#virify

module load Nextflow/23.10.0

#Pulling nextflow pipeline
nextflow pull EBI-Metagenomics/emg-viral-pipeline

cd /data/gent/vo/001/gvo00125/vsc44392

nextflow run EBI-Metagenomics/emg-viral-pipeline \
-r v0.4.0 \
--fasta "./.nextflow/assets/EBI-Metagenomics/emg-viral-pipeline/nextflow/test/assembly.fasta" \
--cores 4 \
--singularity_cachedir $VSC_SCRATCH \
-profile slurm,singularity 
