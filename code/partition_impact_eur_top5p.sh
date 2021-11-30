#!/bin/sh
id=$1
annot=/data/srlab/amariuta/jobs/ClassifierRegMap/Fig1/CD4Tcell_MasterTFs/testGitPipeline/Cistrome/LDSC_IMPACT/annots/EUR/Kawakami/$id/IMPACT_ENCODE_binarytop5p_${id}
data=ra_meta_eur_trial01
sumstats=ldsc/sumstats/$data.sumstats.gz

dd=/data/srlab/external-data/LDSCORE/data.broadinstitute.org/alkesgroup/LDSCORE

python  ~/tools/LDSC/ldsc/ldsc.py  \
   --h2  $sumstats  \
   --ref-ld-chr  $annot.,$dd/baseline_v1.1/baseline. \
   --w-ld-chr  $dd/1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC. \
   --overlap-annot \
   --frqfile-chr  $dd/1000G_Phase3_frq/1000G.EUR.QC. \
   --out  SLDSC/impact/v1/EUR_top5p/$id  \
   --print-coefficients \
   --print-delete-vals



