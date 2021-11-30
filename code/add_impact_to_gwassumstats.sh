#!/bin/sh
file=$1
name=$2
ofile=egwas_scores/tbet/$name.impact_score_sorted.txt

 #extract key info from GWAS
zcat $file |
sed -e "1d" |
awk 'BEGIN{FS="\t"}{
   SNP=$1;
   beta=$2;
   pvalue=$4;
   split(SNP, D ,"_");
   CHR=D[1];
   POS=D[2];
   if( !( CHR == 6 && POS >= 25e06 && POS <= 35e06 ) ){
      print CHR, POS, SNP, beta, pvalue
   }
}' > $ofile.tmp01
    #CHR, POS, SNP, beta, pvalue

 #add impact score
echo "Snp Beta Pvalue Score" > $ofile.tmp02

for chr in $(seq 1 22);do
   
   echo  $chr
   
   #annotfile=/data/srlab/amariuta/jobs/ClassifierRegMap/Fig1/GenomeWide/GenomeTracks/bedgraph/Foxp3_IMPACT_scaled_predictions_chr${chr}_bedgraph.txt.gz
   
   annotfile=/data/srlab/amariuta/jobs/ClassifierRegMap/Fig1/CD4Tcell_MasterTFs/testGitPipeline/Cistrome/LDSC_IMPACT/bedgraph/transferred/IMPACT_predictions_92_chr${chr}_bedgraph.txt.gz
   
   #extract target chr
   cat $ofile.tmp01 |
   awk -v chr=$chr '{OFS="\t";
      if( $1 == chr ){
         print "chr"$1, $2-1, $2, $3, $4, $5
      }
   }' |
   sort -k 2n > $ofile.tmp03
        #bed info, SNP, beta, pvalue
   
   #get scores for target position
   zcat $annotfile |
   sed -e "1d" |
   bedtools intersect -wb -a $ofile.tmp03 -b - |
   awk '{print $4, $5, $6, $10}' > $ofile.tmp04
        # Snp Beta Pvalue Score
   
   cat  $ofile.tmp04 >> $ofile.tmp02
   
done

 #sort by impact score
 #extract snp, beta, pvalue
R --vanilla --slave  --args  $ofile.tmp02  $ofile  <  sort_by_score.R

rm -f $ofile.tmp*
gzip -f $ofile


