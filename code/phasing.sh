#!/bin/sh
wd=$(pwd)
id=$1
chr=$2
refdir=/data/srlab/external-data/ImputeRef

mkdir -p phased/$id/chr$chr
cd phased/$id/chr$chr

#extract imput plink
BED=$wd/postqc/auto/$id/$id.postqc
plink --bfile $BED --make-bed --chr $chr --out d1

#phasing
shapeit  \
   -B  d1 \
   -M  $refdir/genetic_map_chr${chr}_combined_b37.txt \
   -O  d1_phased \
   --thread 4
      #--no-mcmc


