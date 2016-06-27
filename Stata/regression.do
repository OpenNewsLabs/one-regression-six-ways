* set working directory
* cd "V:/czhang/Stata"

log using "output.log", replace

* Read in data
import delimited "data.csv", clear

* log transformation of income
gen log_income = log(income)

* run regression
regress health log_income

* calculate residuals (raw & standardized) plus fitted values
predict resids, residuals
predict std_resids, rstandard
predict stu_resids, rstudent
predict fitted 

list resids std_resids stu_resids fitted in 1/5

* assess the regression model

** raw residuals v. fitted
rvfplot, yline(0) title("Residuals vs Fitted")
graph save "residsvfitted", replace

** q-q plot
qnorm std_resids, title("Normal Q-Q") // overlays 45% line
graph save "qqplot", replace

** scale-location
rvfplot2, rstandard rscale(sqrt(abs(X))) lowess title("Scale-Location")
graph save "scaleloc", replace

** leverage plot
lvr2plot, mlabel(country) mlabsize(small) title("Leverage") // leverage v. resid^2
graph save "leverage", replace

graph combine "residsvfitted.gph" "qqplot.gph" "scaleloc.gph" "leverage.gph"
graph export "regplots.png", replace

** Cook's D
predict cooksD, cooksd

gsort -cooksD // sort in descending order
list cooksD country health log_income in 1/5 

log close
