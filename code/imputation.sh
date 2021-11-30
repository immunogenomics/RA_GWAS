#!/bin/sh
wd=$(pwd)
id=$1
chr=$2

mkdir -p imputed/$id/chr$chr
cd imputed/$id/chr$chr

shapeit -convert \
   --input-haps  $wd/phased/$id/chr$chr/d1_phased \
   --output-vcf   tmp.chr${chr}.vcf

refhaps=/data/srlab/external-data/Minimac3Ref/$chr.1000g.Phase3.v5.With.Parameter.Estimates.m3vcf.gz

/PHShome/ki991/tools/minimac3/Minimac3/bin/Minimac3-omp \
   --refHaps    $refhaps  \
   --haps   tmp.chr${chr}.vcf \
   --prefix  d1 \
   --cpus 4 \
   --chr $chr

rm -f tmp.chr${chr}.vcf


