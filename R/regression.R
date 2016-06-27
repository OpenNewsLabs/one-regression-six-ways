# set working directory
# setwd("/Users/christinezhang/Projects/regression/R")

# read data
d <- read.csv("data.csv")

# run regression
reg <- lm(health ~ log(income), data = d)
summary(reg)

# assess the regression model
png('regplots.png', width = 8, height = 7, units = 'in', res = 200)
par(mfrow = c(2,2))
plot(reg)
dev.off()

# put residuals (raw & standardized) plus fitted values into a data frame
results <- as.data.frame(cbind(resid = resid(reg), 
                 std_resids = rstandard(reg), 
                 stu_resids = rstudent(reg),
                 fitted = fitted(reg)))

library('dplyr')

results <- results %>% mutate(sd = sd(fitted))
head(results)
results$resid.pearson <- results$resid/results$sd
head(results)


