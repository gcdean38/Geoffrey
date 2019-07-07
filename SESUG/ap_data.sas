


/** FOR CSV Files uploaded from Unix/MacOS **/

FILENAME CSV "/folders/myfolders/ap_data_all.csv";
/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=WORK.MYCSV
		    DBMS=CSV
		    REPLACE;
		    guessingrows=200;
RUN;

/** Print the results. **/

PROC PRINT DATA=WORK.MYCSV(obs=10); RUN;

/** Unassign the file reference.  **/

FILENAME CSV;
libname d '/folders/myfolders';
data d.ap_data;
	set mycsv;
	rename var9=subject;
	ratio = male/female;
run;
/* data _null_; */
/* 	set d.ap_data; */
/* 	foo = ' STEM '; */
/* 	subject2 = strip(compress(subject)); */
/* 	l = length(subject); */
/* 	l2 = length(subject2); */
/* 	foo_l = length(foo); */
/* 	foo_l2 = length(compress(foo)); */
/* 	where year=2014;* and class ? upcase('world'); */
/* 	put year= subject= subject2= class= l= l2= ; */
/* 	put foo= foo_l= foo_l2=; */
/* run; */

proc sort data=d.ap_data;
	by year;
run;

ODS GRAPHICS / IMAGEMAP=ON;
proc sgplot data=d.ap_data;
	by year;
	scatter x= male_percent y=total_taking_exams / 
		tip=(class) group=subject markerattrs=(symbol=CircleFilled);
run;

proc freq data=d.ap_data;
	table subject;
run;

title "Students taking each exam";
title2 "2014-2018";
proc sgplot data=d.ap_data;
	vbar class/
	response=total_taking_exams group=subject;
run;

title "gender gap by subject (% males - % females)";
proc sgplot data=d.gap;
	series x=year y=g_gap/ 
	group=subject;
run;

title "male to female ratio by subject";
title2 "2014-2018";
proc sgplot data=d.gap;
	series x=year y=ratio / 
		group=subject;
	yaxis label = 'male to female ratio';
run;


proc sgpanel data = d.ap_data;
	panelby subject/
		layout=columnlattice uniscale=row spacing=0 onepanel;
	series x=year y = ratio /  
		group=class;
run;

proc sgplot data= d.ap_data;
	where subject = 'STEM';
	vbar class/
	response=male colorresponse=ratio colorstat=mean nostatlabel;
run;