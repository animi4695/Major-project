library(coreNLP)
initCoreNLP()
library("openNLP")
library("NLP")
library(rjson)
library(stringr)
library(googleVis)
#for finding parts of speech
POS<- function(a){
	s <-as.String(a)
	sent_token_annotator <-Maxent_Sent_Token_Annotator()
	word_token_annotator <-Maxent_Word_Token_Annotator()
	a2 <-annotate(s, list(sent_token_annotator, word_token_annotator))
	pos_tag_annotator <-Maxent_POS_Tag_Annotator()
	a3 <-annotate(s, pos_tag_annotator, a2)
	a3w <-subset(a3, type == "word")
	tags <-sapply(a3w$features, '[[', "POS")
	x <-sprintf("%s",tags)
	return(x)
}
args<-commandArgs(TRUE)
mobile<-args[1]
#mobile <- "Apple iPhone 6"
rawreview <- readLines("mobilereviews.txt")
rawreview<-as.data.frame(rawreview)
reviews<-do.call(rbind, str_split(rawreview$rawreview, "@"))
#reviewsind<-do.call(rbind, str_split(rawreview$rawreview, "*"))
mRow<- which(mobile == reviews[,2])
aspectterms={}
AspectsPolarity={}
AspectswithPolarity={}
for(i in 1:length(mRow))  #mRow = no of selected mobiles
{
	String<-reviews[mRow[i],1]
	s<-annotateString(String)
	dependencytree<-getDependency(s)
	dependencymodified<-dependencytree[,c("governor","dependent","type")]
	nRow<-which("nsubj"==dependencymodified[,3])
	for (j in 1:length(nRow)) 	#check whether sentence has nsubj dependency
	{
		a<-dependencymodified[nRow[j],1]
		#Rule2
		if(POS(a)=="VBZ")	#POS(a) function call. eg: It has nice camera.
		{
			nRow1<-which("dobj"==dependencymodified[,3])
			for(k in 1:length(nRow1))
			{
				aspectterms<- c(aspectterms,dependencymodified[nRow1[k],2])	#aspectterms=dependencymodified[nRow1[j],2]
			}
		}
		#Rule3
		if(POS(a)=="JJ" | POS(a)=="JJS")		#The mobile's battery is good.
		{
			if(POS(dependencymodified[nRow[j],2])=="NN")
			{
				aspectterms<- c(aspectterms,dependencymodified[nRow[j],2])
			}
		}
		#Rule1
		if(POS(a)=="NN")		#It is a nice camera
		{
			aspectterms<- c(aspectterms,dependencymodified[nRow1[k],1])
		}
	}
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
							if(length(nRow3)==0)
							{
								if(dependencymodified[nRow[k],1]=="costly" | dependencymodified[nRow[k],1]=="overpriced")
								{
									AspectsPolarity<-c(AspectsPolarity,"Negative")
								}
								else if(dependencymodified[nRow[k],1]=="cheap" | dependencymodified[nRow[k],1]=="budget")
								{
									AspectsPolarity<-c(AspectsPolarity,"Positive")
								}
								else
								{
									AspectsPolarity<-c(AspectsPolarity,getSentiment(annotateString(dependencymodified[nRow[k],1]))$sentiment)
								}
							}
							else
							{
								if(dependencymodified[nRow[k],1] == dependencymodified[nRow3,1])
								{
									#print("yellow")
									dependencymodified[nRow[k],1] <-paste("not" ,dependencymodified[nRow[k],1] , sep=" ")
									AspectsPolarity<-c(AspectsPolarity,getSentiment(annotateString(dependencymodified[nRow[k],1]))$sentiment)
								}
							}	
						}
						else if(POS(c)=="PRP")
						{
							nRow4<-which("acl:relcl"==dependencymodified[,3])
							if(length(nRow4)==0)
							{
							}
							else
							{
								if(dependencymodified[nRow[k],1] == dependencymodified[nRow4,1])
								{
									AspectsPolarity<-c(AspectsPolarity,getSentiment(annotateString(dependencymodified[nRow4[1],2]))$sentiment)
								}
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
		AspectswithPolarity <- rbind(AspectswithPolarity, data.frame(aspectterms,AspectsPolarity))		
		aspectterms={}
		AspectsPolarity={}
		
}



#catagorize


AspectsPolarity<-AspectswithPolarity[2]
aspectterms<-AspectswithPolarity[1]
AspectsPolarity<-as.data.frame.array(AspectsPolarity)
aspectterms<-as.data.frame.array(aspectterms)
c=0
q=0
b=0
p=0
d=0
for(i in 1:length(aspectterms[,1]))
{
	if(aspectterms[i,1]=="camera")
	{
		if(AspectsPolarity[i,1]=="Negative")
		{
			c=c-3
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			c=c+3
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			c=c+5
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			c=c-5
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			c=c-2
		}
	}
	if(aspectterms[i,1]=="battery" | aspectterms[i,1]=="life" | aspectterms[i,1]=="backup")
	{
		aspectterms[i,1]=="battery life"
		if(AspectsPolarity[i,1]=="Negative")
		{
			b=b-3
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			b=b+3
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			b=b+5
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			b=b-5
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			b=b-2
		}
	}
	if(aspectterms[i,1]=="quality" | aspectterms[i,1]=="time" | aspectterms[i,1]=="performance")
	{
		aspectterms[i,1]="performance"
		if(AspectsPolarity[i,1]=="Negative")
		{
			q=q-3
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			q=q+3
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			q=q+5
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			q=q-5
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			q=q-2
		}
	}
	if(aspectterms[i,1]=="phone")
	{
		aspectterms[i,1]="price"
		if(AspectsPolarity[i,1]=="Negative")
		{
			p=p-3
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			p=p+3
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			p=p+5
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			p=p-5
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			p=p-2
		}
	}
	if(aspectterms[i,1]=="display" | aspectterms[i,1]=="resolution" | aspectterms[i,1]=="clarity" | aspectterms[i,1]=="design")
	{
		aspectterms[i,1]="display"
		if(AspectsPolarity[i,1]=="Negative")
		{
			d=d-3
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			d=d+3
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			d=d+5
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			d=d-5
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			d=d-2
		}
	}
	
}

Aspects<-c("battery","price","camera","display","quality")
polarity<-c(b,p,c,d,q)
AwithP<-data.frame(Aspects,polarity)

#Gauge plotting
Gauge <-  gvisGauge(AwithP,options=list(min=-30, max=30, greenFrom=15,greenTo=30, yellowFrom=-15, yellowTo=15,
                                  redFrom=-30, redTo=-15, width=400, height=300))
#plot(Gauge)
if(mobile=='Moto G Plus')
{
	capture.output(Gauge,file="Moto G Plus.html")
}else if(mobile=="Samsung Galaxy S6 Edge")
{
	capture.output(Gauge,file="SamsungGalaxyS6Edge.html")
}else if(mobile=="Apple iPhone 4")
{
	capture.output(Gauge,file="AppleiPhone4.html")
}else if(mobile=='Apple iPhone 5')
{
	capture.output(Gauge,file="AppleiPhone5.html")
}else if(mobile=='Apple iPhone 5s')
{
	capture.output(Gauge,file="AppleiPhone5s.html")
}else if(mobile=='Apple iPhone 6')
{
	capture.output(Gauge,file="AppleiPhone6.html")
}else if(mobile=='Apple iPhone 6s')
{
	capture.output(Gauge,file="AppleiPhone6s.html")
}else if(mobile=='Oneplus 3')
{
	capture.output(Gauge,file="Oneplus3.html")
}else if(mobile=='Oneplus 3T')
{
	capture.output(Gauge,file="Oneplus3T.html")
}else if(mobile=='Moto E3')
{
	capture.output(Gauge,file="MotoE3.html")
}else if(mobile=='Moto G Play')
{
	capture.output(Gauge,file="MotoGPlay.html")
}else if(mobile=='Mi 4i')
{
	capture.output(Gauge,file="Mi4i.html")
}else if(mobile=='Xiaomi Redmi 3S')
{
	capture.output(Gauge,file="XiaomiRedmi3S.html")
}else if(mobile=='Xiaomi Mi Max Prime')
{
	capture.output(Gauge,file="XiaomiMiMaxPrime.html")
}else if(mobile=='Samsung On5 Pro')
{
	capture.output(Gauge,file="SamsungOn5Pro.html")
}else if(mobile=='Samsung Galaxy J7')
{
	capture.output(Gauge,file="SamsungGalaxyJ7.html")
}else if(mobile=='Micromax Canvas Nitro 4G E455')
{
	capture.output(Gauge,file="MicromaxCanvasNitro4GE455.html")
}