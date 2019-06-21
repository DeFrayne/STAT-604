# Script File Name: DDeFrayne_HW04_Script.R
# Script Save Pathway: C:/Users/defraydz/Documents/School Work/STAT 604 - Statistical
Computations/HW04.log
# Created By: Don DeFrayne
# Creation Date: 9/5/18
# Purpose: explore vectors, sequences, databases, and matrices.
# Last executed: 9/10/18
Sys.time()

#1 Housekeeping.
ls()
#rm(list=ls())

#2 Output to console and file destination.
sink("C:/Users/defraydz/Documents/School Work/STAT 604 - Statistical Computations/HW04.log",
type=c("output", "message"), split=TRUE)

#3 Create and display a vector of values from 4 to 100, going by 4s.
(seq4to100by4 <- c(seq(4,100,4)))
#Show data type of the vector.
mode(seq4to100by4)

#4 Create and display a vector of values from 8 to 8, going by 0.8s.
(seq8to40by8 <- c(seq(0.8,40,0.8)))
#Show data type of the vector.
mode(seq8to40by8)

#5 Create a matrix by columns with a column width of 5 using seq8to40by8; display matrix.
(seq8to40by8matix <- matrix(seq8to40by8,ncol=5,byrow=F))

#6 Combine the two vectors as columns in a matrix; display matrix.
(colbindseq <- cbind(seq4to100by4,seq8to40by8))

#7 Combine the two vectors as rows in a matrix; display matrix.
(rowbindseq <- rbind(seq4to100by4,seq8to40by8))

#8a Show contents of workspace.
ls()

#8b Load previously saved workspace.
load("C:/Users/defraydz/Documents/School Work/STAT 604 - Statistical Computations/HW04.RData")

#8c Show workspace again.
ls()

#9 Display object type and mode for the object loaded in the workspace.
class(Oklahoma)
mode(Oklahoma)

#10 Display the object type and mode for the first column of the loaded object.
class(Oklahoma[,1])
mode(Oklahoma[,1])

#11 Display the structure of the object loaded in the workspace.
str(Oklahoma)

#12 Display a summary of the object loaded in the workspace.
summary(Oklahoma)

#13 Display the first 10 rows, and all but column 12 of the object.
Oklahoma[1:10,-12]

#14 Create and display a subset of Oklahoma: rows 1-25 and columns 1,2,4,5,13,14, and 15.
(OklahomaClip <- Oklahoma[1:25,c(1,2,4,5,13:15)])

#15 Close output file.
sink()