args <- commandArgs(trailingOnly = T)   # enable reading factors from linux command line
ifile <- as.character( args[1] )
ofile <- as.character( args[2] )

library(data.table)

alldata <- fread(ifile)
alldata <- as.data.frame(alldata)

 #sorting: important: snps with score 0, add shuffling
alldata.1 <- subset(alldata, Score != 0 )
alldata.2 <- subset(alldata, Score == 0 )

alldata.1 <- alldata.1[ order( - alldata.1$Score ), ]
alldata.2 <- alldata.2[ sample(row.names(alldata.2)), ]

alldata.update <- rbind(alldata.1, alldata.2) 

write.table(alldata.update, ofile, col.names=T, row.names=F, append=F, quote=F, sep="\t")


