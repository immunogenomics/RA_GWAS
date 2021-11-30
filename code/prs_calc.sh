#!/bin/sh
name=$1
id=$2
top=$3
pth=$4
   # name=EUR_wo_ACR_REF; top=5; pth=1e-03; chr=22

 #for top in 1 2 3 4 5 10 100 ; do
 #for pth in 1e-01 3e-02 1e-02 3e-03 1e-03 3e-04 1e-04 3e-05 1e-05 5e-08;do
   odir=score_v3/$name/$top/$pth
   mkdir -p $odir
   
   for chr in $(seq 1 22);do
      #filter beta info file by p values
      #already removed dup ids, variats should exist in plink file
      zcat clump_v3/$name/$top.chr$chr.gwasres.gz |
      sed -e "1d" |
      awk -v pth=$pth '{
          split($1, D, "_");
             #newsnpid = D[1] ":" D[2];
          newsnpid = $1;
          efallele = D[4];
          beta=$2;
          if( $3 < pth ){
             print newsnpid, efallele, beta
          }
      }' >  $odir/tmp.$chr.beta.info
      
      #chech whether there are target snps in this chr..
      N=$( cat $odir/tmp.$chr.beta.info | wc -l )
      echo chr$chr : $N
      
      if [ $N -gt 0 ] ;then
         #calculate prs
         plink2 \
            --pfile   pgen/$id/chr$chr  \
            --score  $odir/tmp.$chr.beta.info  cols=scoresums  ignore-dup-ids \
            --threads 1 \
            --memory 8000 \
            --silent \
            --out $odir/$chr
         
      else
         #output empty file
         echo "#IID SCORE1_SUM" |
         perl -pe "s/ /\t/g" > $odir/$chr.sscore
         
         sed -e "1d" pgen/$id/chr$chr.psam |
         awk '{print $1,"0"}' |
         perl -pe "s/ /\t/g" >> $odir/$chr.sscore
         
      fi
      
      gzip -f $odir/$chr.sscore
      
      rm -f $odir/tmp.$chr.beta.info
      
   done
   
 #done
 #done


