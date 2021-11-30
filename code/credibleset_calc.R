args <- commandArgs(trailingOnly = T)   # enable reading factors from linux command line
snp <- as.character( args[1] )
library(data.table)
 #Trans-ethnic and Ancestry-Specific Blood-Cell Genetics in 746,667 Individuals from 5 Global Populations
 #Cell 2020
 #dist=1Mb
 #use Z score, due to inacurate beta/se estimate, at PTPN22 locus, 
 #the order of P value and the order of BF was not consistent
 #Wakefield’s Approximate Bayes Factor (ABF) derivation 
 # Wakefield J. Bayes factors for Genome-wide association studies: 
 # Comparison with P-values. Genetic Epidemiology. 2009;33(1):79–86. pmid:18642345

w=0.04

 #Trans
ofile <- paste0("credibleset/v1_1mb/",snp,"/trans.95credibleset.txt")

file=paste0("gunzip -c credibleset/v1_1mb/",snp,"/trans.snp_beta_se.dat.gz") #250 kb
d1 <- fread(cmd=file)
colnames(d1) <- c("SNP","Beta","SE","P")
d1$Z <- qnorm(d1$P/2, lower.tail = FALSE)
d1$abf <- sqrt( d1$SE^2 /( d1$SE^2 + w ) ) * exp( w * d1$Z^2 /( 2 *  (d1$SE^2 + w)) )
d1$pip <- d1$abf / sum(d1$abf)
d1 <- d1[order(d1$pip,decreasing = T),]
cumsum <- c()
for(i in 1:nrow(d1)){
    cumsum <- c(cumsum, sum(d1$pip[1:i])) 
}
d1$cumsum <- cumsum
lastrow <- (1:nrow(d1))[cumsum>0.95][1]
d2 <- d1[1:lastrow, ]
write.table(d2, ofile, col.names=T, row.names=F, append=F, quote=F, sep="\t")

 #EUR
ofile <- paste0("credibleset/v1_1mb/",snp,"/eur.95credibleset.txt")

file=paste0("gunzip -c credibleset/v1_1mb/",snp,"/eur.snp_beta_se.dat.gz") #250 kb
d1 <- fread(cmd=file)
colnames(d1) <- c("SNP","Beta","SE","P")
d1$Z <- qnorm(d1$P/2, lower.tail = FALSE)
d1$abf <- sqrt( d1$SE^2 /( d1$SE^2 + w ) ) * exp( w * d1$Z^2 /( 2 *  (d1$SE^2 + w)) )
d1$pip <- d1$abf / sum(d1$abf)
d1 <- d1[order(d1$pip,decreasing = T),]
cumsum <- c()
for(i in 1:nrow(d1)){
    cumsum <- c(cumsum, sum(d1$pip[1:i])) 
}
d1$cumsum <- cumsum
lastrow <- (1:nrow(d1))[cumsum>0.95][1]
d2 <- d1[1:lastrow, ]
write.table(d2, ofile, col.names=T, row.names=F, append=F, quote=F, sep="\t")

 #EAS
ofile <- paste0("credibleset/v1_1mb/",snp,"/eas.95credibleset.txt")

file=paste0("gunzip -c credibleset/v1_1mb/",snp,"/eas.snp_beta_se.dat.gz") #250 kb
d1 <- fread(cmd=file)
colnames(d1) <- c("SNP","Beta","SE","P")
d1$Z <- qnorm(d1$P/2, lower.tail = FALSE)
d1$abf <- sqrt( d1$SE^2 /( d1$SE^2 + w ) ) * exp( w * d1$Z^2 /( 2 *  (d1$SE^2 + w)) )
d1$pip <- d1$abf / sum(d1$abf)
d1 <- d1[order(d1$pip,decreasing = T),]
cumsum <- c()
for(i in 1:nrow(d1)){
    cumsum <- c(cumsum, sum(d1$pip[1:i])) 
}
d1$cumsum <- cumsum
lastrow <- (1:nrow(d1))[cumsum>0.95][1]
d2 <- d1[1:lastrow, ]
write.table(d2, ofile, col.names=T, row.names=F, append=F, quote=F, sep="\t")

 #Trans ds3
ofile <- paste0("credibleset/v1_1mb/",snp,"/trans_ds3.95credibleset.txt")

file=paste0("gunzip -c credibleset/v1_1mb/",snp,"/trans_ds3.snp_beta_se.dat.gz") 
d1 <- fread(cmd=file)
colnames(d1) <- c("SNP","Beta","SE","P")
d1$Z <- qnorm(d1$P/2, lower.tail = FALSE)
d1$abf <- sqrt( d1$SE^2 /( d1$SE^2 + w ) ) * exp( w * d1$Z^2 /( 2 *  (d1$SE^2 + w)) )
d1$pip <- d1$abf / sum(d1$abf)
d1 <- d1[order(d1$pip,decreasing = T),]
cumsum <- c()
for(i in 1:nrow(d1)){
    cumsum <- c(cumsum, sum(d1$pip[1:i])) 
}
d1$cumsum <- cumsum
lastrow <- (1:nrow(d1))[cumsum>0.95][1]
d2 <- d1[1:lastrow, ]
write.table(d2, ofile, col.names=T, row.names=F, append=F, quote=F, sep="\t")

 #output all (same as in g-chromvar original article)
 #Trans
ofile <- paste0("credibleset/v1_1mb/",snp,"/trans.all_pip.txt.gz")

file=paste0("gunzip -c credibleset/v1_1mb/",snp,"/trans.snp_beta_se.dat.gz") #250 kb
d1 <- fread(cmd=file)
colnames(d1) <- c("SNP","Beta","SE","P")
d1$Z <- qnorm(d1$P/2, lower.tail = FALSE)
d1$abf <- sqrt( d1$SE^2 /( d1$SE^2 + w ) ) * exp( w * d1$Z^2 /( 2 *  (d1$SE^2 + w)) )
d1$pip <- d1$abf / sum(d1$abf)
d1 <- d1[order(d1$pip,decreasing = T),]

gz1 <- gzfile(ofile,"w")
write.table(d1, gz1, sep = "\t", quote = F, row.names = FALSE)
close(gz1)



