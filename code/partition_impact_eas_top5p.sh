#!/bin/sh
id=$1
annot=/data/srlab/amariuta/jobs/ClassifierRegMap/Fig1/CD4Tcell_MasterTFs/testGitPipeline/Cistrome/LDSC_IMPACT/annots/EAS/Kawakami/$id/IMPACT_ENCODE_binarytop5p_${id}
data=ra_meta_eas_trial01_nomal
sumstats=ldsc/sumstats/$data.sumstats.gz

ddeas=/data/srlab/kishigaki/data/LDSC_EAS/1000G_EAS_Phase3

python  ~/tools/LDSC/ldsc/ldsc.py  \
   --h2  $sumstats  \
   --ref-ld-chr  $annot.,$ddeas/baseline_v1.1/baseline. \
   --w-ld-chr  $ddeas/weights/weights.EAS.hm3_noMHC. \
   --overlap-annot \
   --frqfile-chr  $ddeas/plink_files/1000G.EAS.QC. \
   --out  SLDSC/impact/v1/EAS_top5p/$id  \
   --print-coefficients  \
   --print-delete-vals




