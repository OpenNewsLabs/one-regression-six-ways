# import modules
import os
import math
import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import statsmodels.api as sm
import statsmodels.formula.api as smf

# set working directory - just in case
# os.chdir('/Users/christinezhang/Projects/regression/Python')

# read data
d = pd.read_csv('data.csv')

# log transformation of income
d['log_income'] = np.log(d['income'])

# run regression
lm = smf.ols(formula = 'health ~ log_income', data = d).fit()
lm.summary()

# assess the regression model

## put residuals (raw & standardized) plus fitted values into a data frame
results = pd.DataFrame({'resids': lm.resid,
                        'std_resids': lm.resid_pearson,
                        'fitted': lm.predict()})

results.head()

## raw residuals vs. fitted
residsvfitted = plt.plot(results['fitted'], results['resids'],  'o')
l = plt.axhline(y = 0, color = 'grey', linestyle = 'dashed')
plt.xlabel('Fitted values')
plt.ylabel('Residuals')
plt.title('Residuals vs Fitted')
plt.show(residsvfitted)

## q-q plot
qqplot = sm.qqplot(results['std_resids'], line='s')
plt.show(qqplot)


## scale-location
scalelocplot = plt.plot(results['fitted'], abs(results['std_resids'])**.5,  'o')
plt.xlabel('Fitted values')
plt.ylabel('Square Root of |standardized residuals|')
plt.title('Scale-Location')
plt.show(scalelocplot)

## residuals vs. leverage
residsvlevplot = sm.graphics.influence_plot(lm, criterion = 'Cooks', size = 2)
plt.show(residsvlevplot)


# 4 plots in one window
fig = plt.figure(figsize = (8, 8), dpi = 100)

ax1 = fig.add_subplot(2, 2, 1)
ax1.plot(results['fitted'], results['resids'],  'o')
l = plt.axhline(y = 0, color = 'grey', linestyle = 'dashed')
ax1.set_xlabel('Fitted values')
ax1.set_ylabel('Residuals')
ax1.set_title('Residuals vs Fitted')

ax2 = fig.add_subplot(2, 2, 2)
sm.qqplot(results['std_resids'], line='s', ax = ax2)
ax2.set_title('Normal Q-Q')

ax3 = fig.add_subplot(2, 2, 3)
ax3.plot(results['fitted'], abs(results['std_resids'])**.5,  'o')
ax3.set_xlabel('Fitted values')
ax3.set_ylabel('Sqrt(|standardized residuals|)')
ax3.set_title('Scale-Location')

ax4 = fig.add_subplot(2, 2, 4)
sm.graphics.influence_plot(lm, criterion = 'Cooks', size = 2, ax = ax4)

plt.tight_layout()
fig.savefig('regplots.png')




