library(dplyr)
library(corrplot)
library(pheatmap)
library(viridis)

data=read.table("mean_methylation_level.xls",header=T,sep="\t",row.names=1)
data=data[which(rowSums(data)>0),]

pdf("scTrio_seq2.HepG2_22Rv1.mC_100kb.pearson.pdf",width=6,height=6)
M1=cor(data,method="pearson")
pheatmap(M1,clustering_method="ward.D2",main="Pearson",color=turbo(100))
dev.off()
pdf("scTrio_seq2.HepG2_22Rv1.mC_100kb.spearman.pdf",width=6,height=6)
M2=cor(data,method="spearman")
pheatmap(M2,clustering_method="ward.D2",main="Spearman",color=turbo(100))
dev.off()
