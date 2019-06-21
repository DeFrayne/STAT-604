/***********************************************************************************/
/* Program Name: DDeFrayne_HW12_prog                                               */
/* Date Created: 10/23/2018                                                        */
/* Author: Don DeFrayne                                                            */
/* Purpose: Explore methods to improve program efficiency and create data subsets. */
/* Inputs: ...\School Work\STAT 604\SAS\HWREF\Tabled1x.sas7bdat  				   */
/* Outputs: ...\School Work\STAT 604\DDeFrayne_HW12_output.pdf'		               */
/***********************************************************************************/

*1. Create input, output, and pdf output locations;
LIBNAME input 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\HWREF\' access=readonly;
filename hw 'C:\Users\defraydz\Documents\School Work\STAT 604\DDeFrayne_HW12_output.pdf';

*2. Create a new data set, Project;
data work.Narrow_Table;
	set input.Tabled1x;
	keep Industry State Month Year Jobs; *2a. Only keep the Industry and State variables;
	if Industry = 'PROFESSIONAL AND BUSINESS SERVICES' 
		then Industry = 'PROFESSIONAL-BUSINESS SERVICES'; *2b. Update P&BS values;
	Industry = PropCase(Industry); *2c. Change industry to proper case;
	if Sept_2017 ~= '.' then do; *2d. For each month and year, output a jobs value;
		Month = 'September';
		Year = '2017';
		Jobs = Sept_2017;
		output;
	end;
	if Aug_2017 ~= '.' then do;
		Month = 'August';
		Year = '2017';
		Jobs = Aug_2017;
		output;
	end;
	if Oct_2017 ~= '.' then do;
		Month = 'October';
		Year = '2017';
		Jobs = Oct_2017;
		output;
	end;
	if Nov_2017 ~= '.' then do;
		Month = 'November';
		Year = '2017';
		Jobs = Nov_2017;
		output;
	end;
	if Dec_2017 ~= '.' then do;
		Month = 'December';
		Year = '2017';
		Jobs = Dec_2017;
		output;
	end;
	if Jan_2018 ~= '.' then do;
		Month = 'January';
		Year = '2018';
		Jobs = Jan_2018;
		output;
	end;
	if Feb_2018 ~= '.' then do;
		Month = 'February';
		Year = '2018';
		Jobs = Feb_2018;
		output;
	end;
	if Mar_2018 ~= '.' then do;
		Month = 'March';
		Year = '2018';
		Jobs = Mar_2018;
		output;
	end;
	if Apr_2018 ~= '.' then do;
		Month = 'April';
		Year = '2018';
		Jobs = Apr_2018;
		output;
	end;
	if May_2018 ~= '.' then do;
		Month = 'May';
		Year = '2018';
		Jobs = May_2018;
		output;
	end;
	if June_2018 ~= '.' then do;
		Month = 'June';
		Year = '2018';
		Jobs = June_2018;
		output;
	end;
	if July_2018 ~= '.' then do;
		Month = 'July';
		Year = '2018';
		Jobs = July_2018;
		output;
	end;
	if Aug_2018 ~= '.' then do;
		Month = 'August';
		Year = '2018';
		Jobs = Aug_2018;
		output;
	end;
run;

*3. Create temporary data sets based on job types and numbers;
data work.Services (keep=Industry State avg_jobs mkt_size)
	work.Large (keep=Industry State avg_jobs)
	work.Medium (keep=Industry State avg_jobs)
	work.Small (keep=Industry State avg_jobs)
	work.Government (keep=State avg_jobs mkt_size)
	work.Goods (keep=Industry State avg_jobs mkt_size);
	set input.Jobsdata(drop=rep_date ann_chg); *3a. Drop variables rep_date and ann_chg;
	avg_jobs = sum(of Aug_2017--Aug_2018)/13; *3b. Create a variable that averages each obs;
	label avg_jobs = 'Average Jobs'; *3b. Relabel avg_jobs;
	format avg_jobs 10.1; *3b. Format to 1 decimal place;
	label mkt_size = 'Market Size';
	if avg_jobs; *3c. Do not count observations with null avj_jobs values;
	if avg_jobs >= 100 & avg_jobs <= 750 then do;
		mkt_size = 'Medium'; *3d. Assign mkt_size by avg_jobs;
		output work.Medium; *3d. Output to Medium;
	end;
	else if avg_jobs > 0 & avg_jobs < 100 then do;
		mkt_size = 'Small'; *3d. Assign mkt_size by avg_jobs;
		output work.Small; *3d. Output to Small;
	end;
	else do;
		mkt_size = 'Large'; *3d. Assign mkt_size by avg_jobs;
		output work.Large; *3d. Output to Large;
	end;
	select (Industry); *3e. Create reports based on industry types;
		when('FINANCIAL ACTIVITIES','PROFESSIONAL AND BUSINESS SERVICES',
			'EDUCATION AND HEALTH SERVICES','LEISURE AND HOSPITALITY') output work.Services;
		when('CONSTRUCTION','MANUFACTURING')output work.Goods;
		when('GOVERNMENT') output work.Government;
		otherwise;
	end;
run;

*4. PDF output;
ods pdf file = hw bookmarklist = hide;

*5 Print to PDF;
title '5.1 - First 50 Observations from Narrow Data Set';
proc print data=work.Narrow_Table(OBS=50) label NOOBS; *Print first 50 obs;
run;

title '5.2 - Last 50 Observations from Narrow Data Set';
proc print data=work.Narrow_Table(FIRSTOBS=5410) label NOOBS; *Print last 50 obs;
run;

title '5.3 - Fifty Observations from Narrow Data Set Beginning with #2700';
proc print data=work.Narrow_Table(FIRSTOBS=2700 OBS=2749) label NOOBS; *Print 50 obs starting at obs 2700;
run;

*6. Print from the temporary data sets;
title '6a - First 30 Observations of Small Markets';
proc print data=work.Small(OBS=30) label; *6a. Print first 30 obs of small markets;
run;

title '6b - First 30 Observations of Medium Markets';
proc print data=work.Medium(OBS=30) label; *6b. Print first 30 obs of medium markets;
run;

title '6c - Large Markets';
proc print data=work.Large label; *6c. Print all obs from large markets;
run;

title '6d - Selected Observations from Goods industry';
proc print data=work.Goods(FIRSTOBS=70 OBS=99) label NOOBS; *6d. Print 30 obs starting at 70 from Goods;
run;

title '6e - Small Markets in the Services industry';
proc print data=work.Services(OBS=30) label; *6e. Print first 30 obs of small services;
	WHERE mkt_size='Small';
run;

title '6f - Government industry';
proc print data=work.Government label; *6f. Print all obs from government set;
run;

*7. Print all data sets in work library;
title '7 - Data Sets in the WORK Library';
proc print data=sashelp.vtable(WHERE = (libname='WORK') KEEP=libname memname crdate nobs nvar);
run;

*End output;
ods _all_ close; 
