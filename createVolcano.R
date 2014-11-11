library(ggplot2)
#library(rescale)

createVolcano <- function(dat,point.labels = rep('', length(x)),filename=NULL,condA,condB,label.size=2,threshold) {

#size=label.cex
# dummy volcano plotting function
#	volcano <- ggplot(dat,aes_string(x,y)) + geom_point(size=label.cex)

	signi=subset(dat,significant=='yes')
	signi$value_1[signi$value_1==0]=0.00001
	signi$value_2[signi$value_2==0]=0.00001
	signi$p_value[which(signi$p_value==0)]=0.00001

	# calculating the log fold change again with normalized values
	signi$log2.fold_change.=log2(signi$value_2/signi$value_1)

	signi$threshold=0
	signi$threshold[which(signi$log2.fold_change.<(-(threshold)))]=-1
	signi$threshold[which(signi$log2.fold_change.>(threshold))]=1

	sub=signi[c(which(signi$threshold==-1),which(signi$threshold==1)),]

	# generating a volcano plot coloured by threshold
	volcano <- ggplot(signi,aes(x=log2.fold_change.,y=-log10(p_value),colour=threshold))+
				geom_point(alpha=0.4,size=1.75)+
				# plotting the threshold passed geneNames only	
				geom_text(data=sub,aes(x=log2.fold_change.,y=-log10(p_value),label=gene),size=label.size)+
				ggtitle(paste(condA,"->",condB,"(TOTAL DE GENES=",length(signi[,1]),")"))
}