library(DESeq2)

data=read.table("merged.count.xls",header=T,sep="\t",row.names=1)
data=round(data,0)

group=c(rep('groupA',3),rep('groupB',3))
sample_info=data.frame(condition=group)
rownames(sample_info)=colnames(data)

dds=DESeqDataSetFromMatrix(countData=data,colData=sample_info,design=~condition)
#过滤低表达量数据，选取至少有 2x重复数 的行
keep=rowSums(counts(dds))>=6
dds=dds[keep,]

dds=DESeq(dds)
res=results(dds,contrast=c('condition','groupA','groupB'))
write.table(res,"DEGseq2.result.groupA_vs_groupB.xls",quote=F,sep="\t")
