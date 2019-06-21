#Script Name: DDeFrayne_HW06_Script.R
#Location: D:\School\TAMU\STAT 604 - Statistical Computations
#Created By: Don DeFrayne
#Creation Date: 09/20/18
#Purpose: Practice working with vectors, matrices, and data frames. Analyze Oklahoma school data.
#Last executed: 09/24/18
Sys.time()

#1 Housekeeping.
ls()
#rm(list=ls())

#2 Load previously saved workspace.
load("C:\\Users\\Karst\\Downloads\\HW05.RData")

#3 Show contents of workspace.
ls()

#3a Create a data frame of Oklahoma zips. Remove PO Box and decomissioned zips.
zipframe <- data.frame(zipdata[zipdata$type!="PO BOX" & zipdata$state=="OK" & zipdata$decommissioned==0,c(1,3,7,15)])

#3b Chance the name of primary_city to MailCity.
colnames(zipframe)[2] <- "MailCity"

#3c Change the names of the cities to the upper case.
zipframe$MailCity <- toupper(zipframe$MailCity)

#3d Create a zip3 column using the first 3 digits of the zip code.
zipframe$ZipRegion <- substr(zipframe$zip,1,3)

#3e Display information on the new data frame.
str(zipframe)
zipframe[1:25,]

#4 Merge the zip data with the Oklahoma High School data.
OKHSzip <- merge(OKHS, zipframe, by="MailCity")
dim(OKHSzip)

#5 Create a data frame of unduplicated High Schools.
OKHSzip <- OKHSzip[duplicated(OKHSzip$School)==F,] 

#6 Display the 20 smallest and largest schools based on number of teachers.
OKHSzip[order(OKHSzip$Teachers)[1:20],]
OKHSzip[order(OKHSzip$Teachers, decreasing=T)[1:20],]

#7 Create csv file of schools using zipRegion and system time.
cat(paste(OKHSzip$School, OKHSzip$MailCity, OKHSzip$County, OKHSzip$ZipRegion, OKHSzip$HSTotal, Sys.time(), sep=","), sep="\n", file="D:\\School\\TAMU\\STAT 604 - Statistical Computations\\DDeFrayne_HW06.csv")