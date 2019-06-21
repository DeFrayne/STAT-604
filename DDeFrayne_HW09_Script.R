#Script Name: DDeFrayne_HW09_Script.R
#Location: D:\School\TAMU\STAT 604 - Statistical Computations
#Created By: Don DeFrayne
#Creation Date: 09/29/18
#Purpose: Practice working with equation editor, formatting, and graphing.
#Last executed: 09/30/18
Sys.time()

#0 Housekeeping
ls()
#rm(list=ls())

#1 Read in NKE.csv as a dataframe. Check its structure.
NKE <- data.frame(read.csv("C:\\Users\\Karst\\Downloads\\NKE.csv"))

#2 Define the pdf margins and output to pdf.
pdf(paper="special",file="D:\\School\\TAMU\\STAT 604 - Statistical Computations\\DDeFrayne_HW09_Output.pdf",height=8.5, width=11)

#3 Create and plot a 30 Day Exponential Moving Average.
#3a Assign a value for alpha and N.
N = 30
a = 2/(1+N)

#3b Create a vector populated with zeroes for EMA's values.
EMA = rep(0,nrow(NKE))

#3c Create a starting average based on the first 30 days of EMA.
EMA[30] <- mean(NKE$Adj.Close[1:30])

#3d Loop the EMA formula from day 31 until the last day.
for(i in 31:nrow(NKE)){
	EMA[i] = NKE$Adj.Close[i]*a+(EMA[i-1]*(1-a))
}

#3e Set the background color for all plots to gray90. Plot a line showing the
#3e last 260 EMA values.
EMAx <- c(1:260)
par(bg='gray90')
plot(EMAx,EMA[(length(EMA)-259):length(EMA)], ylim=c(0,90), xlab="Days", ylab="Adjusted Closing Price", type='l',col="blue", main="30 Day EMA and Daily Stock Prices")

#3f Add EMA formula to graph.
text(130,5,cex=0.95,(expression(paste(EMA[i]==(P[i]%*%alpha)+(EMA[i-1]%*%(1-alpha))," where ", alpha==frac(2,1+30)))))

#3g Add a best fit EMA line.
lines(EMAx,NKE$Adj.Close[(length(NKE$Adj.Close)-259):length(NKE$Adj.Close)],col='red')

#4 Convert code into a function. 
EMAfunc <- function(vec,N=30,ylim=90){
	a = 2/(1+N)
	newvec <- rep(0,length(vec))
	newvec[N] <- mean(vec[1:N])
	for(i in (N+1):length(vec)){
		newvec[i] = vec[i]*a+(newvec[i-1]*(1-a))
	}
	vecx <- c(1:260)
	par(bg='gray90')
	plot(vecx,newvec[(length(newvec)-259):length(newvec)], ylim=c(0,ylim), xlab="Days", ylab="Adjusted Closing Price", type='l',col="blue",main=paste(N," Day EMA and Daily Stock Prices"))
	text(130,5,cex=0.95,(bquote(paste(EMA[i]==(P[i]%*%alpha)+(EMA[i-1]%*%(1-alpha))," where ", alpha==frac(2,1+.(N))))))
	lines(vecx,vec[(length(vec)-259):length(vec)],col='red')
}

#5 Create two columns for graphics. Set margins.
par(mfcol=c(1,2))
par(omi=c(0.5,0.5,1.5,0.5))
par(mar=c(4,4,2,0))

#6 Call function twice. First call calls closing price column. Second adds 100 to N.
EMAfunc(NKE$Adj.Close)
EMAfunc(NKE$Adj.Close, N=100)

#7 Write the system time to the graph legend.
mtext(Sys.time(),adj=0,side=1,outer=T)
graphics.off()

#8 Re-run code - no code for this section.