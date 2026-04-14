library(ComplexHeatmap)
library(RColorBrewer)
library(viridis)
diff=read.table("diff.HepG2_vs_22Rv1.xls",header=T,sep="\t",row.names=1)
dim(diff)
#DMR
diff=diff[which(diff$fdr<0.1&(diff$meanDiff>=10|diff$meanDiff<=-10)),]
dim(diff)
diff=diff[order(diff$meanDiff),]

data=read.table("mean_methylation_level.xls",header=T,sep="\t",row.names=1)
data=data[rownames(diff),]

sample=data.frame(Cell=c(rep('HepG2',7),rep('22Rv1',6)))
rownames(sample)=colnames(data)

color_cell=c('SteelBlue','Salmon')
names(color_cell)=c('22Rv1','HepG2')
ann_colors=list(Cell=color_cell)

pdf("scTrio_seq2.HepG2_vs_22Rv1.DMR.heatmap.pdf",height=4,width=4)
p=pheatmap(data,main="DMR in HepG2 vs 22Rv1",name="DNAme level",show_rownames=F,show_colnames=F,annotation_col=sample,color=turbo(100),annotation_colors=ann_colors,cluster_rows=F)
draw(p,heatmap_legend_side="right",annotation_legend_side="right",merge_legend=T)
dev.off()
