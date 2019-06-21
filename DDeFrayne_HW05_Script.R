#Script File Name: DDeFrayne_HW05_Script.R
#Script Save Pathway: C:\Users\defraydz\Documents\School Work\STAT 604 - Statistical Computations\
#Created By: Don DeFrayne
#Creation Date: 9/14/18
#Purpose: To explore data frame manipulation commands.
#Last Executed: 9/17/18
Sys.time()
#1 Housekeeping.
ls()
#rm(list=ls())

#2 Load workspace from HW04.
load("C:\\Users\\defraydz\\Documents\\School Work\\STAT 604 - Statistical
Computations\\HW04.RData")
# Show contents of the workspace.
ls()

#3 Compute the average of the HSTotal column...

#3a ...using index numbers.
mean(Oklahoma[,15], na.rm=T)

#3b ...using a fully qualified column name.
mean(Oklahoma$HSTotal, na.rm=T)

#3c ...using only the column name.
attach(Oklahoma)
search()
mean(HSTotal, na.rm=T)
detach(Oklahoma)

#3d ...using the with function.
with(Oklahoma, mean(HSTotal, na.rm=T))

#4 Perform a logical test to determine which HSTotals that are not missing
# are larger than average.
Oklahoma$HSTotal > mean(Oklahoma$HSTotal, na.rm =T) & !is.na(Oklahoma$HSTotal)

#5 Display the school, city, and HSTotal of records from #4's results.
HSAboveAverage <- Oklahoma$HSTotal > mean(Oklahoma$HSTotal, na.rm =T) &
!is.na(Oklahoma$HSTotal)
Oklahoma[HSAboveAverage,c(1,2,15)]

#6 Use the apply function to compute the average class size for grades 7-12.
apply(Oklahoma[,6:11],2,mean,na.rm=T)

#7 Use the apply function to create a new column called AvgClassSize by
# computing the average class size of grades 7-12 for each school.
Oklahoma$AvgClassSize <- apply(Oklahoma[,6:11],1,mean,na.rm=T)

#8 Display the first 25 rows of the modified data frame.
Oklahoma[1:25,]

#9 Create a new data frame of schools containing HS in the name.
HSSchools <- data.frame(Oklahoma[grep(" HS",Oklahoma$School),-c(6,7,12,13,14)])
# Show the structure of the new data frame.
str(HSSchools)

#10 Read in the zip code database into a data frame for future use.
zipcodes <- read.csv("C:\\Users\\defraydz\\Documents\\School Work\\STAT 604 - Statistical
Computations\\zip_codes.csv")
# Show the structure of the new data frame.
str(zipcodes)

#11 Display the contents of the workspace.
ls()

#12 Save the workspace in a new file.
save.image("C:\\Users\\defraydz\\Documents\\School Work\\STAT 604 - Statistical
Computations\\HW05.RData")