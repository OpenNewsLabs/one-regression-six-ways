* set working directory - modify as necessary;
* x 'CD E:\SAS';

* read data;
PROC IMPORT OUT = d
            DATAFILE = "data.csv" 
            DBMS = CSV REPLACE;
     GETNAMES = YES;
     DATAROW = 2; 

* log transformation of income;
DATA d;
	SET d;
	log_income = log(income);
RUN;

* run regression;
PROC REG DATA = d;
model health = log_income;
/* calculate residuals (raw & standardized) plus fitted values
note - make sure you understand the meaning of these residuals */
output out = d 
	p = fitted 
	r = resids
	rstudent = stu_resids
	student = std_resids;
RUN;

PROC PRINT DATA = d(obs = 5);
var country fitted std_resids stu_resids; 
RUN;
