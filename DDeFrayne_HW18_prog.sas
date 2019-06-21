/***********************************************************************************/
/* Program Name: DDeFrayne_HW18_prog											   */
/* Date Created: 12/3/2018														   */
/* Author: Don DeFrayne															   */
/* Purpose: Cleaning data exercise												   */
/* Inputs: ...\School Work\STAT 604\SAS\HWREF\poseidon.dat			         	   */
/* Outputs: DDeFrayne_HW18_output.pdf									           */
/***********************************************************************************/

*1 Create libname and filename;
FILENAME poseidon 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\HWREF\poseidon.dat';
FILENAME hw 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\DDeFrayne_HW18_output.pdf';
ods pdf file=hw;

*2 Read the data in;
data salary(drop=Nolevels CutItMore FinalCut Everything);
	infile poseidon; 
	input Everything $115. @@; *Read in each observation as one variable;
	Level = substr(Everything, 7, 1); *Subset for the level variable;
	NoLevels = substr(Everything, 9); *Remove Level from Everything;
	CutItMore = substr(NoLevels, index(NoLevels, '(')+1); *Remove Job_Title from Everything;
	FinalCut = substr(CutItMore, index(CutItMore,')')+1); *Remove Names from Everything;
	Job_Title = substr(NoLevels, 1, index(NoLevels, '(')-1); *Create Job_Title;
	Employee_Name = substr(CutItMore, 1, index(CutItMore, ')')-1); *Create Name;
	Salary = input(substr(FinalCut, index(FinalCut,'$')),DOLLAR32.); *Create Salary;
run;

*Titles;
title1 'Analysis of Poseidon Employee Data for Clean Up';
title3 'Frequency Report of Job Title';

*3 Use FREQ to find job title errors;
proc freq data=salary;
	tables Job_Title;
run;
*Superfluous titles: Accountant i, ii, and iii - Warehouse Assistant i, ii;

*Title;
title2 'Analysis of Salary Values';
title3;

*4 Use UNIVARIATE to validate salary values;
proc univariate data=salary;
	var Salary;
run;
*Extreme salary values at observations 340, 352, 64, and 228;
*Missing values at 21, 23, and 24;

*5 Print a list of employees with suspect salary values;
title2 'Salary Values to be Investigated';
proc print data=salary;
	var Employee_Name Salary;
	where Salary < 10000 or Salary > 1000000 or Salary is missing;
run;

*6 New data set that cleans up job titles;
data final;
	set salary;
	Job_Title = tranwrd(Job_Title,'Accountant iii','Accountant III');
	Job_Title = tranwrd(Job_Title,'Accountant ii','Accountant II');
	Job_Title = tranwrd(Job_Title,'Accountant i','Accountant I');
	Job_Title = tranwrd(Job_Title,'Warehouse Assistant ii','Warehouse Assistant II');
	Job_Title = tranwrd(Job_Title,'Warehouse Assistant i','Warehouse Assistant I');
run;

*7 Frequency of job title appearance to ensure all title errors were caught;
title1 'Number of Different Jobs in Cleaned Data';
title2;
proc freq data=final nlevels;
	tables Job_Title / noprint;
run;

*8 Temporary employees and executive officers;
title1 'List of Poseidon Employees to be Reviewed for Orion Positions';
proc sort data=final;
	by Level;
run;

proc print data=final noobs ;
	var Job_Title Employee_Name;
	id Level;
	by Level;
	where Job_Title like '%Chief%' or
		Job_Title like '%Temp%' or
		Job_Title contains 'Vice President';
run;

*9 Housecleaning;
ods _all_ close;
filename _all_ clear;
