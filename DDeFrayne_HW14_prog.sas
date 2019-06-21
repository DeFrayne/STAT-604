/***********************************************************************************/
/* Program Name: DDeFrayne_HW14_prog											   */
/* Date Created: 10/29/2018														   */
/* Author: Don DeFrayne															   */
/* Purpose: Explore formulas and changes between num and char					   */
/* Inputs: ...\School Work\STAT 604\SAS\HWREF\stat747.sas7bdat  	         	   */
/* 		   ...\School Work\STAT 604\SAS\HWREF\conference.sas7bdat				   */
/* Outputs: DDeFrayne_HW14_output.pdf									           */
/***********************************************************************************/

*1 Create libname and filename;
LIBNAME input 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\HWREF' access=readonly;
FILENAME hw 'C:\Users\defraydz\Documents\School Work\STAT 604\SAS\DDeFrayne_HW14_output.pdf';

*2. Import and manipulate the stat747 data set;
data Exams (drop=Ex1Num Ex2Num Ex3Num);
	set input.Stat747 (rename = (exam1 = Ex1Num exam2 = Ex2Num FinalExam = Ex3Num));
	select (Ex1Num);
		when ('ND') Ex1Num = '0'; *2a. Set 'ND' to 0;
		otherwise; *2a. Convert to numeric;
	end;
	select (Ex2Num);
		when ('ND') Ex2Num = '0'; *2a. Set 'ND' to 0;
		otherwise; *2a. Convert to numeric;
	end;
	select (Ex3Num); 
		when ('ND','EX') select (CertScore); *2bi. If Exam3Num is alpha select CertScore;
			when ('.') Ex3Num='0'; *2bi. If CertScore is empty, Exam3Num is 0;
			otherwise Ex3Num=CertScore; *2bii. Replace Exam3Num with CertScore;
			end;
		otherwise;
	end;
	exam1 = input(Ex1Num, 3.); *2a. Convert to numeric;
	exam2 = input(Ex2Num, 3.); *2a. Convert to numeric;
	exam3 = input(Ex3Num, 3.); *2b. Convert to numeric;
	if (exam3<CertScore) then exam3=CertScore*1; *2biii. Replace exam3 with CertScore when CertScore is greater and output to log;
	if (min(of exam1-exam3) ~= exam3) then do; *2c. If exam1 or exam2 are lower than exam3, replace a score with it;
		if exam1 > exam2 then exam2 = exam3;
		else exam1 = exam3;
	end;
	GPA = 0.4*(sum(of Homework1-Homework12)/12)+0.6*(sum(of exam:)/3); *2d. Calculate GPA;
	format GPA 6.3; *2d. Format GPA to have 3 decimal places;
	label exam3 = 'Final Exam';
run;

*PDF output;
ods pdf file = hw bookmarklist;

*3. Print the descriptor portion of the data set;
ods proclabel = 'Grades Data - Descriptor';
proc contents data=work.Exams;
run;

*4. Print students, final exam grades, and GPA;
ods proclabel = 'Final Grades';
proc print data=work.Exams(keep=Student exam3 GPA) label;
run;

*5. Create spreadsheet for speaker events;
data Registry(drop=Regdte target);
	set input.Conference;
	by SpekrID;
	length audience $ 40;
	if First.SpekrID then Audience = '';
	retain Audience;
	Audience = catx(', ',Audience,target);
	select; *5b. Change missing targets and all-4 targets to All;
		when(Audience='2 year, 4 year, Public, Private' & Last.SpekrID) Audience='All';
		when(missing(Audience) & Last.SpekrID) Audience='All';
		otherwise;
	end;
	if Last.SpekrID;
	rdate = catx(', ',substr(left(Regdte),1,3),catx(' ',substr(scan(Regdte,2,','),1,4),scan(Regdte,3,', ')),scan(Regdte,4,' ')); *5c. Format dates;
	label rdate = 'Registration Date' audience = 'Audience' SpekrID = 'Speaker'; *5a. Apply labels;
run;

*6. Print all observations and variables from registry;
ods proclabel = 'Presentation Proposals';
proc print data=Registry;
run;

*End pdf output;
ods pdf close; 
