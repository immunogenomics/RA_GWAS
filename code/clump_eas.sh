#!/bin/sh
id=$1
gwasres=$2
odir=$3 #clump_v2/$name
rsq=0.2
P=0.5

mkdir -p $odir

 # filter by common vars (use EAS variants)
zcat metal/input/trial01/*/$id.auto.txt.gz |
sed -e "1d" |
awk '{print $1}' >  $odir/tmp01 #test dataset pass snps

cat data/snps/1kg_eas_ref_maf01.snps |
grep -F -w -f $odir/tmp01 -  > $odir/tmp02 #test dataset pass snps + 1KG, common snps

zcat $gwasres |
grep -F -w -f $odir/tmp02 - > $odir/tmp.gwasres.filt_common #discovery gwas res filtered by common variants

for top in  5 ;do
   #1,  filter top x % of gwas res (conduct in genome wide)
   N=$( cat $odir/tmp.gwasres.filt_common |
      wc -l )
   Nkeep=$( expr $N \* $top \/ 100 )
   
   cat $odir/tmp.gwasres.filt_common |
   sed -n 1,${Nkeep}p  >  $odir/tmp.$top.gwasres #Snp Beta Pvalue Score, with top impact variants
   
   #2, association data with prioritize snps
   for chr in $(seq 1 22);do
      ofile=$odir/$top.chr$chr.gwasres
      
      echo "SNP P" > $odir/tmp.$top.$chr.gwasres
      
      cat $odir/tmp.$top.gwasres |
      awk -v chr=$chr '{
         split($1, D, "_");
         if( D[1] == chr ){ print $1,$3}}'  >> $odir/tmp.$top.$chr.gwasres
      
      plink --bfile /data/srlab/kishigaki/reference/1KG/EAS_plink/chr$chr.m2.M2.nodupid \
         --allow-no-sex \
         --clump  $odir/tmp.$top.$chr.gwasres \
         --clump-p1 $P \
         --clump-p2 $P \
         --clump-r2  $rsq \
         --chr $chr \
         --threads 1 \
         --memory 8000 \
         --out  $odir/tmp.$top.$chr
      
      sed -e "1d" $odir/tmp.$top.$chr.clumped |
      awk '{print $3}' > $odir/tmp.$top.$chr.keepsnps
      
      #output
      echo "Snp Beta Pvalue" > $ofile
      
      cat $odir/tmp.$top.gwasres |
      awk -v chr=$chr '{
         split($1, D, "_");
         if( D[1] == chr ){ print $1, $2, $3 }}' |
      grep -F -w -f $odir/tmp.$top.$chr.keepsnps - >> $ofile
      
      gzip -f $ofile
      
      rm -f $odir/tmp.$top.$chr.*
   
   done
   
   rm -f $odir/tmp.$top.*
   
done

rm -f $odir/tmp*


