library(ggplot2)
library(ggrepel)
main_theme <- theme(plot.margin = unit(c(1, 1, 1, 1), 'lines'),
                    plot.title = element_text(family='Times',face = 'bold',size = 12,angle = 0, hjust = 0.5, vjust = 0.5),
                    axis.title = element_text(family='Times',size = 12,color = 'black'),
                    axis.text.x = element_text(family='Times',size = 12,angle = 0, hjust = 0.5, vjust = 1),
                    axis.text.y = element_text(family='Times',size = 12),
                    panel.background = element_rect(fill = 'white',color = 'black'),
                    panel.grid.major.y = element_blank(),
                    panel.grid.minor.y = element_blank(),
                    panel.grid.major.x = element_blank(),
                    panel.grid.minor.x = element_blank(),
                    strip.background=element_rect(fill="white",linetype="solid"),
                    strip.text=element_text(face="bold",size=12,family="Times"),
                    legend.text = element_text(family='Times',size = 12),
                    legend.title = element_text(family='Times',size = 12,face = 'bold'))
data=read.table("DEGseq2.result.groupA_vs_groupB.xls",header=T,sep="\t",row.names=1)
data=na.omit(data)
for(i in 1:nrow(data)){
	if(data$padj[i]<0.05){
		if(data$log2FoldChange[i]>=1){
			data$type[i]='Upregulated'
		}else if(data$log2FoldChange[i]<=-1){
			data$type[i]='Downregulated'
		}else{
			data$type[i]='N.S.'
		}
	}else{
		data$type[i]='N.S.'
	}
}
write.table(data,"DEGseq2.result.groupA_vs_groupB.addType.xls",quote=F,sep="\t")
color=c('Upregulated'='FireBrick','Downregulated'='SteelBlue','N.S.'='gray')

gene=read.table("geneID_geneName.xls",header=F,sep="\t")
colnames(gene)=c('geneID','geneName')
rownames(gene)=gene$geneID
gene=gene[rownames(data),]

data$geneName=gene$geneName

interested_genes=c('geneA','geneB','geneC')

data$label=ifelse(data$geneName %in% interested_genes,data$geneName,'')

pdf("scTrio_seq2.groupA_vs_groupB.DEGs.pdf",height=4,width=6)
ggplot(data,aes(x=log2FoldChange,y=-log10(padj)))+geom_point(aes(color=type),size=0.5)+labs(x="log2FoldChange",y="-log10(adjP)",color="Type")+scale_color_manual(values=color)+ggtitle("HepG2 vs 22Rv1")+guides(color=F,size=F)+geom_label_repel(aes(label=label,color=type),max.overlaps=100)+main_theme
dev.off()
