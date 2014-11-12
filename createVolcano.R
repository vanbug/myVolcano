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
	# splitting the input gene names with the delimiter ";" to construct the queries
	geneLabel=strsplit(geneLabel,';')[[1]]

## SOME BUG STILL, CODE BREAKS FOR LST1 etc.
	###geneCol=dat[match(tolower(as.character(geneLabel)),tolower(dat[,1])),]
	## FOR STOPPING PROMISCUIS GREPPING, BLOCK THESE TWO LINES AND USE ABOVE LINE
	# getting all the gene names, recursively by constructing user queries
	geneNames=unique(grep(paste(geneLabel,collapse='|'),dat[,1],ignore.case=TRUE,value=TRUE))
	# converting these names to whole dataset
	geneCol=dat[match(geneNames,dat[,1]),]


  	#geneCol=dat[which(dat[,1]==as.character(geneLabel)),]

	# generating a volcano plot coloured by threshold
	volcano <- ggplot(signi,aes(x=log2.fold_change.,y=-log10(p_value),colour=threshold))+
				geom_point(alpha=0.4,size=1.75)+
				# plotting the threshold passed geneNames only	
				geom_text(data=sub,aes(x=log2.fold_change.,y=-log10(p_value),label=gene),size=label.size)+
				geom_text(data=geneCol,aes(x=log2.fold_change.,y=-log10(p_value),label=gene),colour="Black",size=label.size)+
				ggtitle(paste(condA,"->",condB,"(Total DE GENES=",length(signi[,1]),")","after thresh=",length(sub[,1])))+
				xlab(xlabel)+ylab(ylabel)+scale_color_gradient(low=scheme[1], high=scheme[2])+theme_bw()+xlim(as.numeric(c(xlim)))+ylim(as.numeric(c(ylim)))
}

# function for exporting, edit the code to reduce redundancy
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