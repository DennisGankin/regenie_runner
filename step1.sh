#!/bin/bash

# downloading mamba 
echo "Downloading micromamba..."
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

export MAMBA_ROOT_PREFIX=/some/prefix  # optional, defaults to ~/micromamba
eval "$(./bin/micromamba shell hook -s posix)"

# create the environment with regenie, bgenix and plink
echo "Creating conda environment..."
micromamba create -n regenie_env regenie plink2 bgenix -c conda-forge -c bioconda

# activate the environment
echo "Activating conda environment..."
micromamba activate regenie_env

# upload covariate file
# adjust covariate file to match the format

# upload all data needed for step 1


# run plink to prepare snps
echo "Running plink2 ..."
plink2 --bfile genetics/UKBB_470K_Autosomes_QCd_WBA --min-ac 100  --max-ac {str(max_mac)} --write-snplist  --out REGENIE_extract

regenie --step 1 --bed genetics/UKBB_470K_Autosomes_QCd_WBA --extract REGENIE_extract.snplist --covarFile phenotypes_covariates.formatted.txt \
--phenoFile /test/phenotypes_covariates.formatted.txt \
--maxCatLevels 110 \
--bsize 1000 \
--out /test/fit_out \
--threads 32