library(ggpointdensity)
library(ggplot2)
library(viridis)
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
data=read.table("copyNumbersSmooth.1000kb.txt",header=T,sep="\t",row.names=1)
pdf("Copy_number_1000kb.scTrio-seq2.pdf",width=3.5,height=3)
ggplot(data,aes(x=M_sample1,y=M_sample2))+geom_pointdensity()+scale_x_continuous(limits=c(-5,5))+scale_y_continuous(limits=c(-5,5))+labs(x="CNV ratio (scTrio-seq2, cell #1)",y="CNV ratio (scTrio-seq2, cell2)")+ggtitle("Copy number")+guides(color=F)+scale_color_viridis()+main_theme
dev.off()
cor.test(data$M_sample1,data$M_sample2,method="pearson")
cor.test(data$M_sample1,data$M_sample2,method="spearman")
