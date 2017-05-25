AspectsPolarity<-AspectswithPolarity[2]
aspectterms<-AspectswithPolarity[1]
AspectsPolarity<-as.data.frame.array(AspectsPolarity)
aspectterms<-as.data.frame.array(aspectterms)
c=0
q=0
b=0
p=0
for(i in 1:length(aspectterms[,1]))
{
	if(aspectterms[i,1]=="camera")
	{
		if(AspectsPolarity[i,1]=="Negative")
		{
			c=c-1
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			c=c+1
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			c=c+2
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			c=c-2
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			c=c-1
		}
	}
	if(aspectterms[i,1]=="battery" | aspectterms[i,1]=="life" | aspectterms[i,1]=="backup")
	{
		aspectterms[i,1]=="battery life"
		if(AspectsPolarity[i,1]=="Negative")
		{
			b=b-1
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			b=b+1
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			b=b+2
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			b=b-2
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			b=b-1
		}
	}
	if(aspectterms[i,1]=="quality" | aspectterms[i,1]=="time" | aspectterms[i,1]=="performance")
	{
		aspectterms[i,1]="performance"
		if(AspectsPolarity[i,1]=="Negative")
		{
			q=q-1
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			q=q+1
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			q=q+2
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			q=q-2
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			q=q-1
		}
	}
	if(aspectterms[i,1]=="phone")
	{
		aspectterms[i,1]="price"
		if(AspectsPolarity[i,1]=="Negative")
		{
			p=p-1
		}
		else if(AspectsPolarity[i,1]=="Positive")
		{
			p=p+1
		}
		else if(AspectsPolarity[i,1]=="Verypositive")
		{
			p=p+2
		}
		else if(AspectsPolarity[i,1]=="Verynegative")
		{
			p=p-2
		}
		else if(AspectsPolarity[i,1]=="Neutral")
		{
			p=p-1
		}
	}
	
}

AspectswithPolarity <- data.frame(aspectterms,AspectsPolarity)