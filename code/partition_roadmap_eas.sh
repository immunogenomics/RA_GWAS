#!/bin/sh
id=$1
ddeas=/data/srlab/kishigaki/data/LDSC_EAS/1000G_EAS_Phase3
annot=$ddeas/genesets_2017/Roadmap/Roadmap.EAS.$id
data=ra_meta_eas_trial01_nomal
sumstats=ldsc/sumstats/$data.sumstats.gz

python  ~/tools/LDSC/ldsc/ldsc.py  \
   --h2  $sumstats  \
   --ref-ld-chr  $annot.,$ddeas/baseline_v1.1/baseline. \
   --w-ld-chr  $ddeas/weights/weights.EAS.hm3_noMHC. \
   --overlap-annot \
   --frqfile-chr  $ddeas/plink_files/1000G.EAS.QC. \
   --out  SLDSC/roadmap/v1/EAS/$id  \
   --print-coefficients  \
   --print-delete-vals



