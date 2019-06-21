/***********************************************************************************/
/* Program Name: DDeFrayne_HW15_prog											   */
/* Date Created: 12/3/2018														   */
/* Author: Don DeFrayne															   */
/* Purpose: Cleaning data exercise												   */
/* Inputs: ...\School Work\STAT 604\SAS\HWREF\poseidon.dat			         	   */
/* Outputs: DDeFrayne_HW15_output.pdf									           */
/***********************************************************************************/

*1 Create libname and filename;
LIBNAME input 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\HWREF' access=readonly;
FILENAME hw 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\DDeFrayne_HW15_output.pdf';

*2 Create a narrow data set of only employee IDs and the charities they contribute to;
data rotated(keep=Employee_ID Charity i); *Keep only necessary information;
	set input.charity(drop=Name Department Salary amount:); *Drop unnecessary information;
	array temp{*} charity:;
	do i=1 to dim(temp);
		if ~missing(temp{i}) then do; *Only output non-missing values;
			Charity = temp{i};
			output;
		end;
	end;
	
run;

*3 Sort the rotated data set by charity for merging;
proc sort data=rotated;
	by Charity;
run;

*4 Sorted copy of the charities data set;
proc sort data=input.charities out=work.charities; 
	by Organization;
run;

*5 Merge the data sets by organization/charity;
data mergedcharities(keep=employee_id charity category i);
	merge rotated charities(rename=(organization=charity)); *Rename variables for merge;
	by charity;
	if ~missing(employee_id); *Remove charities with no donations;
run;

*Sort by employee_ID and then i to prepare for transposition;
proc sort data=mergedcharities;
	by Employee_ID i;
run;

*6 Transpose mergedcharities back into a wide data set;
proc transpose data=mergedcharities out=wmergedcharities(drop= _NAME_ _LABEL_) prefix = CH_Type;
	by employee_id; *Sort variable;
	var category; *Wide variable;
run;

*7 Crate final data set - list donations for children, disease, and total amount for each employee;
data finalset(drop=i);
	merge input.charity wmergedcharities;
	by Employee_ID; *Merge by employee_id;
	array tempamount{*} amount:;
	array catcolumn{*} CH_type:;
	childdonate = 0; *Initialize donation amounts to 0;
	curedonate = 0;
	totaldonate = 0;
	do i=1 to dim(catcolumn); *Accumulate donation amounts for each individual by category;
		if catcolumn{i} = 'Children' then childdonate + tempamount{i};
		if catcolumn{i} = 'Disease' then curedonate + tempamount{i};
		totaldonate + tempamount{i};
	end;
	label childdonate = 'Donations for Children'
		curedonate = 'Donations for Cures'
		totaldonate = 'Total Donations'; *Variable labels;
run;

*8 Print descriptor portion and data portion of final data set to pdf;
ods pdf file=hw;

proc contents data=finalset varnum;
run;

proc print data=finalset noobs;
	var employee_id name department salary childdonate curedonate totaldonate;
run;

ods pdf close;
