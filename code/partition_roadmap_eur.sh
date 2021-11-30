#!/bin/sh
id=$1
dd=/data/srlab/external-data/LDSCORE/data.broadinstitute.org/alkesgroup/LDSCORE
annot=$dd/LDSC_SEG_ldscores/Multi_tissue_chromatin_1000Gv3_ldscores/Roadmap.$id
data=ra_meta_eur_trial01
sumstats=ldsc/sumstats/$data.sumstats.gz

python  ~/tools/LDSC/ldsc/ldsc.py  \
   --h2  $sumstats  \
   --ref-ld-chr  $annot.,$dd/baseline_v1.1/baseline. \
   --w-ld-chr  $dd/1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC. \
   --overlap-annot \
   --frqfile-chr  $dd/1000G_Phase3_frq/1000G.EUR.QC. \
   --out  SLDSC/roadmap/v1/EUR/$id  \
   --print-coefficients \
   --print-delete-vals



