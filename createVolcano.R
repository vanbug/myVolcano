library(ggplot2)
#library(rescale)

createVolcano <- function(dat,point.labels = rep('', length(x)),filename=NULL,condA,condB,label.size=2) {

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

	# colouring the geneLabel entered by the user
	#geneCol=dat[which(dat[,1]==as.character(geneLabel)),]
	#if (length(geneLabel)!)
	geneLabel=tolower(strsplit(geneLabel,';')[[1]])
	geneCol=dat[match(as.character(geneLabel),tolower(dat[,1])),]
  	#geneCol=dat[which(dat[,1]==as.character(geneLabel)),]

	# generating a volcano plot coloured by threshold
	volcano <- ggplot(signi,aes(x=log2.fold_change.,y=-log10(p_value),colour=threshold))+
				geom_point(alpha=0.4,size=1.75)+
				# plotting the threshold passed geneNames only	
				geom_text(data=sub,aes(x=log2.fold_change.,y=-log10(p_value),label=gene),size=label.size)+
				geom_text(data=geneCol,aes(x=log2.fold_change.,y=-log10(p_value),label=gene),colour="red",size=label.size)+
				ggtitle(paste(condA,"->",condB,"(Total DE GENES=",length(signi[,1]),")","after thresh=",length(sub[,1])))
}

exportDat <- function(dat,point.labels = rep('', length(x)),filename=NULL,condA,condB,label.size=2,switch="thresh") {

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

	# colouring the geneLabel entered by the user
	#geneCol=dat[which(dat[,1]==as.character(geneLabel)),]
	#if (length(geneLabel)!)
	geneLabel=tolower(strsplit(geneLabel,';')[[1]])
	geneCol=dat[match(as.character(geneLabel),tolower(dat[,1])),]
	
	# returning data required by user
	ifelse(switch=="manual",return(geneCol),return(sub))
	#return(geneCol)
}