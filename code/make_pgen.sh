#!/bin/sh
id=$1
chr=$2

mkdir -p pgen/$id

plink2 --make-pgen \
   --vcf  imputed/$id/chr$chr/d1.rsq03.vcf.gz  dosage="DS"  \
   --memory 8000 \
   --threads 1 \
   --out pgen/$id/chr$chr


