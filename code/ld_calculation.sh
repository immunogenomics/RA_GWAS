#!/bin/sh
snp=$1
pop=$2
chr=$( echo $snp | cut -d "_" -f 1)
pos=$( echo $snp | cut -d "_" -f 2)
from=$( echo $snp | cut -d "_" -f 2 | awk '{from=$1 - 5e06; if(from < 0){ from = 1}; print from }' )
to=$( echo $snp | cut -d "_" -f 2 | awk '{to=$1 + 5e06; print to }' )
region=$chr:$from-$to
odir=LD/$pop/$snp
mkdir -p $odir
cd $odir

 #1KG data
if [ $chr = X ] ; then 
   orgvcfFile=/data/srlab/external-data/1000genomes/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
else
    orgvcfFile=/data/srlab/external-data/1000genomes/ftp/release/20130502/ALL.chr$chr.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
fi

 #extract target region
bcftools view \
   -S /data/srlab/kishigaki/reference/1KG/$pop.ids \
   -r  $region  \
   $orgvcfFile  |
bcftools norm -m - |
bcftools annotate --set-id '%CHROM\_%POS\_%REF\_%FIRST_ALT'  > tmp.vcf.gz

plink --vcf tmp.vcf.gz \
   --make-bed \
   --silent  \
   --out tmp

mv tmp.bim tmp.save.bim

cat tmp.save.bim |
sed -e "s/<//g" -e "s/>//g" > tmp.bim #modify snp id

 #calculate LD
plink \
   --bfile tmp  \
   --r2  \
   --allow-no-sex   \
   --threads 1  \
   --memory  8000   \
   --ld-window-kb 9999 \
   --ld-window 99999   \
   --ld-snp  $snp  \
   --ld-window-r2 0.0 \
   --out  tmp.out

cat tmp.out.ld |
awk '{print $6,$7}' > $snp.$pop.info

gzip -f $snp.$pop.info

rm -f tmp.*


