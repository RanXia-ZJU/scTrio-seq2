library(DESeq2)

data=read.table("merged.count.xls",header=T,sep="\t",row.names=1)
data=round(data,0)

colnames(data)=gsub('R_22Rv1_batch2','22Rv1',colnames(data))
colnames(data)=gsub('scTrioSeq2Rna_HEp.2','HepG2',colnames(data))

group=gsub("_[1-9]","",colnames(data))
sample_info=data.frame(condition=group)
rownames(sample_info)=colnames(data)

dds=DESeqDataSetFromMatrix(countData=data,colData=sample_info,design=~condition)
#过滤低表达量数据，选取至少有 2x重复数 的行
keep=rowSums(counts(dds))>=6
dds=dds[keep,]

dds=DESeq(dds)
res=results(dds,contrast=c('condition','HepG2','22Rv1'))
write.table(res,"DEGseq2.result.HepG2_vs_22Rv1.xls",quote=F,sep="\t")
