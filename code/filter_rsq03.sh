#!/bin/sh
wd=$(pwd)
id=$1
chr=$2

#modify header
cd imputed/$id/chr$chr

gunzip -c d1.dose.vcf.gz |
awk '{if($1~/##contig/){
   print $0;
   print "##FILTER=<ID=GENOTYPED,Description=\"site was genotyped\">"
}else{print}
}' | 
bgzip -f -c > tmp01.chr${chr}.vcf.gz #mini vcf file

tabix -f -p vcf tmp01.chr${chr}.vcf.gz #index

#filter by rsq0.3
bcftools view \
   -m2 -M2  \
   -i 'R2>0.3' \
   tmp01.chr${chr}.vcf.gz |
bcftools annotate --set-id '%CHROM\_%POS\_%REF\_%FIRST_ALT' -O z  > d1.rsq03.vcf.gz

tabix -f -p vcf d1.rsq03.vcf.gz
   
rm -f tmp01.chr${chr}.vcf.gz



