* set working directory - modify as necessary
* CD "home/christine/Projects/one-regression-six-ways/PSPP/".

* read data 
GET DATA
  /TYPE = TXT
  /FILE = "data.csv"
  /FIRSTCASE = 2
  /DELIMITERS = ","
  /QUALIFIER = '"'
  /VARIABLES =
    country A30
    income F6.0
    health F5.1
    population F10.0.

*  log transformation of income
COMPUTE log_income = ln(income).

* run regression
REGRESSION 
  /VARIABLES = log_income 
  /DEPENDENT = health
  /SAVE pred resid.