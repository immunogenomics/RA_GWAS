#!/bin/sh
id=$1
chr=$2

mkdir -p plink_assoc_v4/$id

plink2  --pfile  pgen/$id/chr$chr  \
   --logistic  hide-covar  \
       cols=chrom,pos,ref,alt,test,nobs,beta,se,tz,p,a1freq,a1freqcc  \
   --chr $chr \
   --pheno  pheno/$id.txt  \
   --threads 1 \
   --covar  cov/$id.pca_sex.txt  \
   --covar-variance-standardize \
   --keep Sample/$id/keepsample_ibd_pca.ids \
   --memory 8000 \
   --out plink_assoc_v3/$id/chr$chr


