#nRow(no: of nsubjs)
nRow2<-which("amod"==dependencymodified[,3])
for(j in 1:length(aspectterms))
{
	if(length(nRow2)==0)
	{
		if(length(nRow)==0)
	{
	}
	else
	{
		for(k in 1:length(nRow))	#no: of rows with nsubj
		{
			c<-dependencymodified[nRow[k],2]
			if(POS(c)=="NN")	
			{
				nRow3<-which("neg"==dependencymodified[,3])
				if(dependencymodified[nRow[k],1] == dependencymodified[nRow3,1])
				{
					#print("yellow")
					dependencymodified[nRow[k],1] <-paste("not" ,dependencymodified[nRow[k],1] , sep=" ")
					AspectsPolarity<-c(AspectsPolarity,getSentiment(annotateString(dependencymodified[nRow[k],1]))$sentiment)
				}
				
			}
		}
	}
	}
	else
	{
		for(k in 1:length(nRow2))	#with amod
		{
			c<-dependencymodified[nRow2[k],1]
			if(aspectterms[j]==c)
			{
				AspectsPolarity<-c(AspectsPolarity,getSentiment(annotateString(dependencymodified[nRow2[k],2]))$sentiment)
			}
		}
	}
	
}
AspectsPolarity