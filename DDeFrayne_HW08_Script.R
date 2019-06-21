#Script Name: DDeFrayne_HW08_Script.R
#Location: D:\School\TAMU\STAT 604 - Statistical Computations
#Created By: Don DeFrayne
#Creation Date: 09/29/18
#Purpose: Practice working with graphs.
#Last executed: 09/29/18
Sys.time()

#1 Housekeeping.
ls()
#rm(list=ls())

#2 Load HW04; confirm load.
load("C:\\Users\\Karst\\Downloads\\HW04.RData")
ls()

#3 Output graphics to DDeFrayne_HW08_Graph.pdf.
pdf(file="D:\\School\\TAMU\\STAT 604 - Statistical Computations\\DDeFrayne_HW08_Graph.pdf")

#4 Create histogram of PTRatio in OK schools.
#4a Histogram with default breaks.
hist(Oklahoma$PTRatio, freq=F, ylab="Density", xlab="Pupils/Teacher",main="Pupil/Teacher Ratios in Oklahoma Schools")

#4b Create a vector to force histogram breaks at 4 pupils/teacher.
hbreak <- seq(0,156,4)

#4c Historgram with forced breaks at 4 pupils/teacher.
hist(Oklahoma$PTRatio, freq=F, breaks=hbreak, ylab="Density", xlab="Pupils/Teacher",xlim=c(0,156),main="Pupil/Teacher Ratios in Oklahoma Schools")

#5 Add a line to show normal distributio density of PTRatio numbers.
PTRx <- seq(0,155,1)
PTRy <- dnorm(PTRx,mean=mean(Oklahoma$PTRatio,na.rm=T), sd=sd(Oklahoma$PTRatio,na.rm=T))
lines(PTRx,PTRy,col="#FF9900")

#6 Add a vertical line at PTRatio's average.
abline(v=mean(Oklahoma$PTRatio,na.rm=T), col=6) 

#7 New plot showing number of teachers vs. PTRatio.
plot(Oklahoma$Teachers, Oklahoma$PTRatio, col="maroon",xlim=c(0,140), xlab="Teachers", ylab="Pupil/Teacher Ratio",pch=3)

#8 Add a best fit line. Show summary statistics.
abline(lm(Oklahoma$PTRatio ~ Oklahoma$Teachers), col="yellow")
summary(lm(Oklahoma$PTRatio ~ Oklahoma$Teachers))

#9 Put system date and time in the upper-right corner of the graph.
text(100,150,as.character(Sys.time()))

#10 Boxplot of the number of students in each grade.
boxplot(Oklahoma$Grade7, Oklahoma$Grade8, Oklahoma$Grade9, Oklahoma$Grade10, Oklahoma$Grade11, Oklahoma$Grade12,names=c("7","8","9","10","11","12"),col="light green",xlab="Grades",ylab="Students",main="Tulsa County vs. State",range=0)

#11 Diamonds added for average number of students in each grade in Tulsa.
tulsastavg <- apply(Oklahoma[Oklahoma$County=="TULSA COUNTY",6:11],2,mean,na.rm=T)
points(c(1:6),tulsastavg,pch=23,col="red",bg="dark green",cex=2)
graphics.off()