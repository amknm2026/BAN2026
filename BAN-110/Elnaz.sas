/************************************************************************** 
Group Assignment 1

	Adriana Moura 	
	Elnaz Farahani
	Harsha Jyoti
*********************************************************************************/
LIBNAME grouplib '/home/u64514051/GroupAssignment';

/* checks if there is already a dataset called subset and deletes it */
%web_drop_table(grouplib.subset);

/* set it up filename msleep.csv */
FILENAME REFFILE '/home/u64514051/GroupAssignment/msleep.csv';

/* import csv file without the need to set it up the data columns */
PROC IMPORT DATAFILE=REFFILE			/* uses filename previously set */
	DBMS=CSV							/* indicates datasource type */	
	OUT=grouplib.subset;				/* output from import is the grouplib.subset dataset */
	GETNAMES=YES;						/* get column names from csv file */
RUN;

title 'Subset dataset information'; 
PROC CONTENTS DATA=grouplib.subset; 	/* displays dataset metadata */	
RUN;

title 'Subset dataset values'; 
proc print data=grouplib.subset; 		/* displays dataset values */ 
run ;

/* i. Group according to order and genus - use proc sort 
*/
proc sort data=grouplib.subset; 
    by order genus; 
run;

title 'Subset sorted by order and genus';
proc print data=grouplib.subset;
run;


/* ii Add a new variable for the proportion of REM sleep as a fraction of the total hours of sleep */
data grouplib.subsetRemPerc; 		/* create new dataset */
	set grouplib.subset; 			/* use subset */
	/* if sleep_rem = 'NA', uses default format for missing number "." 
	else converts sleep_rem to number (same format as sleep_total) and calculate proportional value*/
	if sleep_rem = 'NA' then perc_sleep_rem=.; else perc_sleep_rem= (input(sleep_rem,best12.) / sleep_total); 
;		 
run; 


title 'Mammals Sleep info dataset including proportion of REM Sleep'; 
proc print data=grouplib.subsetRemPerc; 					
run; 

/* iii Summarize the average sleep_total, average rem_prop, minimum sleep_total, and maximum sleep_total */
/* use proc means */

title 'Summary by Order and Genus';
proc means data=grouplib.subsetRemPerc;
    class order genus;
    var sleep_total perc_sleep_rem;
    output out=grouplib.summary 
        mean(sleep_total)=avg_sleep_total
        mean(perc_sleep_rem)=avg_rem_prop
        min(sleep_total)=min_sleep_total
        max(sleep_total)=max_sleep_total;
run;


/* iv. Filter the data so that the average sleep hours are greater than 5v. 
	Arrange the data from lowest to highest by average sleep hours  
	
	-- you can use sql, proc sort and proc print with filter 
*/


/* Export the msleep data set to a SAS dataset called “mammal_sleep */
data grouplib.mammal_sleep; 
	set grouplib.subset;
run; 


/* use proc contents to examine the list of variables. 
Within a data step, perform the following: 
▪ keep the output dataset name same as input 
▪ Rename "brainwt" as Brian_Weight 
▪ print the first 5 observations in the dataset 
▪ drop the column "conservation" from the dataset.
*/

title 'Mammal Sleep dataset - Variable List';
Proc contents data=grouplib.mammal_sleep;
run;

data grouplib.mammal_sleep;
	set grouplib.mammal_sleep;
	rename brainwt = Brain_Weight;
run;

proc print data = grouplib.mammal_sleep (obs=5);
run;

data grouplib.mammal_sleep;
	set grouplib.mammal_sleep;
	drop conservation;
run;
	





