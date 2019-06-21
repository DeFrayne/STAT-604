/***********************************************************************************/
/* Program Name: DDeFrayne_HW10_prog											   */
/* Date Created: 10/15/2018														   */
/* Author: Don DeFrayne															   */
/* Purpose: View library contents for Employee_donations; change titles.		   */
/* Inputs: ...\School Work\STAT 604\SAS\PRG1 Data and Programs\donations.sas7bdat  */
/* Outputs: DDeFrayne_HW10_outputA.pdf and DDeFrayne_HW10_outputB.pdf              */
/***********************************************************************************/

*4. Assign libraries for reading in data (orion) and for data output;
LIBNAME orion 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\PRG1 Data and Programs' access=readonly;
LIBNAME output 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\';

*5. Read in data from orion.Employee_donations;
/*data work.donations;*/
/*   set orion.Employee_donations;*/
/*   keep Employee_ID Qtr1 Qtr2 Qtr3 Qtr4 Total;*/
/*   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);*/
/*run;*/

*6. Commented out as per instructions;
*proc print data=work.donations;

*7. Create donations data set in the new library, output;
/*data output.donations;*/
/*   set orion.Employee_donations;*/
/*   keep Employee_ID Qtr1 Qtr2 Qtr3 Qtr4 Total;*/
/*   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);*/
/*run;*/

*8. Open a pdf destination;
*ods pdf file = 'DDeFrayne_HW10_outputA.pdf' bookmarkgen=no;

*14. Create a new output statement with a style;
ods pdf file = 'DDeFrayne_HW10_outputB.pdf' bookmarkgen = no style = Money;

*9. Set the title and produce the contents of output.donations;
title 'Descriptor Portion of Donations Permanent Data Set';
proc contents data=output.donations;
run;

*10. Produce the contents of the work library;
title 'Descriptor Portion of All Data Sets in Work Library';
proc contents data=work._ALL_;
run;

*11. Produce the contents of the orion library without descriptors;
title 'List of Data Sets in Orion Library';
proc contents data=orion._ALL_ NODS;
run;

*12. Close the pdf output;
ods _all_ close;
