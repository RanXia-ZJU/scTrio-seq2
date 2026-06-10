library(ggplot2)
library(patchwork)
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
data=read.table("copyNumbersSmooth.1000kb.txt",header=T,sep="\t")
chrLen=c(248956422,242193529,198295559,190214555,181538259,170805979,159345973,145138636,138394717,133797422,135086622,133275309,114364328,107043718,101991189,90338345,83257441,80373285,58617616,64444167,46709983,50818468)
offset <- c(0, cumsum(chrLen[-length(chrLen)]))
data$start <- data$start + offset[data$chromosome]
chrPos=matrix(nrow=length(chrLen),ncol=4)
chrPos[1,1]=1
chrPos[1,2]=1
chrPos[1,3]=chrLen[1]
chrPos[1,4]=(1+chrLen[1])/2
for(i in 2:length(chrLen)){
	chrPos[i,1]=i
	chrPos[i,2]=chrPos[i-1,3]+1
	chrPos[i,3]=chrPos[i,2]+chrLen[i]-1
	chrPos[i,4]=(chrPos[i,2]+chrPos[i,3])/2
}
colnames(chrPos)=c('chr','chrStart','chrEnd','chrMid')
chrPos=as.data.frame(chrPos)

start=c(1,1+chrLen[1],1+chrLen[1]+chrLen[2],1+chrLen[1]+chrLen[2]+chrLen[3],1+chrLen[1]+chrLen[2]+chrLen[3]+chrLen[4],1+chrLen[1]+chrLen[2]+chrLen[3]+chrLen[4]+chrLen[5],1+chrLen[1]+chrLen[2]+chrLen[3]+chrLen[4]+chrLen[5]+chrLen[6],1+chrLen[1]+chrLen[2]+chrLen[3]+chrLen[4]+chrLen[5]+chrLen[6]+chrLen[7],1+chrLen[1]+chrLen[2]+chrLen[3]+chrLen[4]+chrLen[5]+chrLen[6]+chrLen[7]+chrLen[8])
end=c(chrLen[1],chrLen[1]+chrLen[2])

pdf("Copy_number.1000kb.all_in_one.pdf",height=6,width=10)
p1=ggplot()+geom_bar(data=data[data$chromosome%%2==1,],aes(x=start,y=M_sample1),fill="SteelBlue",stat="identity")+geom_bar(data=data[data$chromosome%%2==0,],aes(x=start,y=M_sample1),fill="FireBrick",stat="identity")+scale_y_continuous(limits=c(-4,4))+labs(x=NULL,y="CN")+ggtitle("scTrio-seq2 sample1")+main_theme+theme(axis.text.x = element_blank())+geom_rect(data=chrPos[chrPos$chr%%2==1,],aes(xmin=chrStart,xmax=chrEnd,ymin=-Inf,ymax=-4),inherit.aes=F,fill="SteelBlue")+geom_rect(data=chrPos[chrPos$chr%%2==0,],aes(xmin=chrStart,xmax=chrEnd,ymin=-Inf,ymax=-4),inherit.aes=F,fill="FireBrick")+geom_text(data=chrPos,aes(x=chrMid,y=-4,label=chr))
p2=ggplot()+geom_bar(data=data[data$chromosome%%2==1,],aes(x=start,y=M_sample2),fill="SteelBlue",stat="identity")+geom_bar(data=data[data$chromosome%%2==0,],aes(x=start,y=M_sample2),fill="FireBrick",stat="identity")+scale_y_continuous(limits=c(-4,4))+labs(x=NULL,y="CN")+ggtitle("scTrio-seq2 sample2")+main_theme+theme(axis.text.x = element_blank())+geom_rect(data=chrPos[chrPos$chr%%2==1,],aes(xmin=chrStart,xmax=chrEnd,ymin=-Inf,ymax=-4),inherit.aes=F,fill="SteelBlue")+geom_rect(data=chrPos[chrPos$chr%%2==0,],aes(xmin=chrStart,xmax=chrEnd,ymin=-Inf,ymax=-4),inherit.aes=F,fill="FireBrick")+geom_text(data=chrPos,aes(x=chrMid,y=-4,label=chr))
p1/p2
dev.off()
