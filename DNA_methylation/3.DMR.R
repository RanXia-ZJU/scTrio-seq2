data=read.table("mean_methylation_level.xls",header=T,sep="\t",row.names=1)
out=matrix(nrow=nrow(data),ncol=4)
for(i in 1:nrow(data)){
	ttest=tryCatch(t.test(data[i,grep('groupA',colnames(data))],data[i,grep('groupB',colnames(data))]),error=function(e) NA)
	out[i,1]=rowMeans(data[i,grep('groupA',colnames(data))],na.rm=T)
	out[i,2]=rowMeans(data[i,grep('groupB',colnames(data))],na.rm=T)
	out[i,3]=out[i,1]-out[i,2]
	out[i,4]=ifelse(length(ttest)>1,ttest[3]$p.value,ttest)
}
rownames(out)=rownames(data)
colnames(out)=c('groupA','groupB',"meanDiff","p")
out=as.data.frame(out)
out$fdr=p.adjust(out$p,method="fdr")
write.table(out,"diff.groupA_vs_groupB.xls",quote=FALSE,sep="\t")
