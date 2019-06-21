/***********************************************************************************/
/* Program Name: DDeFrayne_HW11_prog                                               */
/* Date Created: 10/18/2018                                                        */
/* Author: Don DeFrayne                                                            */
/* Purpose: To learn how to manipulate variables, inputs, printing, and conditions */
/* Inputs: ...\School Work\STAT 604\SAS\HWREF\Tabled1x.sas7bdat  				   */
/* Outputs: ...\School Work\STAT 604\DDeFrayne_HW11_output.pdf'		               */
/***********************************************************************************/

*2 Create input and output designations;
LIBNAME input 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\HWREF\' access=readonly;
LIBNAME output 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\';

*3 Designate pdf output file;
filename hw 'C:\Users\defraydz\Documents\School Work\STAT 604\DDeFrayne_HW11_output.pdf';

*4 Read in tabled1x and save to the working directory output, relabel months,
add a report date and percent change YOY for august;
data output.EmpRec;
	set input.Tabled1x;
	where State ~= ' ';
	label Apr_2018 = 'April 2018'
	Aug_2017 = 'August 2017'
	Aug_2018 = 'August 2018'
	Dec_2017 = 'December 2017'
	Feb_2018 = 'February 2018'
	Jan_2018 = 'January 2018'
	July_2018 = 'July 2018'
	June_2018 = 'June 2018'
	Mar_2018 = 'March 2018'
	May_2018 = 'May 2018'
	Nov_2017 = 'November 2017'
	Oct_2017 = 'October 2017'
	Sept_2017 = 'September 2017'
	Report_Date = 'Report Date'
	Annual_Change = 'Annual Change';
	Report_Date = 21464;
	Format Report_Date mmddyy10.;
	Annual_Change = (Aug_2018-Aug_2017)/Aug_2017;
	Format Annual_Change percent8.1;
run;

*5. Create a table of observations that have August YOY changes greater than 5%;
data work.EmpRec5PChange;
	set output.EmpRec;
	keep Industry State Aug_2017 Aug_2018 Report_Date Annual_Change;
	where (Annual_Change >= 0.05 OR Annual_Change <= -0.05) AND NOT missing(Annual_Change);
run;

*6. Create a table of observation that have job growth Aug to July 2018;
data work.EmpRecGrowth;
	set output.EmpRec;
	drop Annual_Change Report_Date Aug_2017 Sept_2017 Oct_2017 Nov_2017 Dec_2017;
	where Aug_2018-July_2018 >= 1;
run;

*7. Create a temporary data set of service industries;
data work.EmpRecService;
	set output.EmpRec;
	keep Industry State Aug_2017 Aug_2018 Annual_Change Report_date;
	format Aug_2017 Aug_2018 COMMA10.;
	where Industry LIKE '%SERVICES%' AND not missing(Annual_Change);
run;

*8. Create a temporary data set with only southern states;
data work.EmpRecSouth;
	set output.EmpRec;
	where Industry = '%GOVERNMENT%';
	drop Aug_2017 Sept_2017 Oct_2017 Nov_2017 Dec_2017 Report_Date;
	where State IN('Texas', 'Oklahoma', 'Arkansas', 'Louisiana', 'Mississippi',
		'Alabama', 'Florida', 'Georgia', 'South Carolina', 'North Carolina')
		OR State LIKE 'Tennessee%';
run;

*9. Open a pdf destination;
ods pdf file = hw bookmarkgen=no;

*10. Output #4 with a title;
title '#10. Descriptor Portion of Cleaned Jobs Data Set';
proc contents data=output.EmpRec;
run;

*11. Output all temp data sets - no details;
title '#11. List of Temporary Data Sets';
proc contents data=work._ALL_ NODS;
run;

*12. Print the temp data set from #5;
title '#12 Records with over 5% Annual Change';
proc print data=work.EmpRec5PChange NOOBS label;
	var Annual_Change State Industry Aug_2018 Aug_2017;
run;

*13. Print the temporary date sets from #6-8;
title '#13. Records with Recent Monthly Increase';
proc print data=work.EmpRecGrowth NOOBS label;
	var Industry State Jan_2018 Feb_2018 Mar_2018 Apr_2018
		May_2018 June_2018 July_2018 Aug_2018;
run;

title '#13. Services';
proc print data=work.EmpRecService label;
	var State Aug_2017 Aug_2018 Annual_Change Industry Report_Date;
run;

title '#13. Southern States';
proc print data=work.EmpRecSouth label NOOBS;
	var Industry State Jan_2018 Feb_2018 Mar_2018 Apr_2018 May_2018 June_2018
		July_2018 Aug_2018 Annual_Change;
run;

*Close the pdf output;
ods _all_ close;
