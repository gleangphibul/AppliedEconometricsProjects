/* 
EC-339: Applied Econometrics, Do-File #2
Garn Leangphibul
Dec 6th, 2024
*/

// Task 1: import data and adjust variables
clear
use "/Users/garnleangphibul/Downloads/Data_2.dta"

replace GDPpc = GDPpc/1000
replace LandArea = LandArea/100000

// Task 2: Label variables
label variable CountryName "Country Name" 
label variable iso "Country Code"
label variable PopGrowthRate "Average Annual Growth Rate of Population"
label variable PopDensity "People per square km of land"
label variable LandArea "Area in 100,000 square km"
label variable GDPpc "GDP per capita (constant 2011 thousand $)"
label variable Mortality "Mortality rate attributed to household and ambient air pollution, age-standardized, male (per 100,000 male population)"
label variable DepRatio "Age dependency ratio (% of working-age population)"
label variable Debt "Total Debt Service (% of GDP)"

// Task 3: Estimate Model 1 (Linear Model)

reg Mortality GDPpc PopGrowthRate PopDensity LandArea 

// Task 4: Estimate Model 2 (Quadratic Model)

reg Mortality c.GDPpc##c.GDPpc PopGrowthRate PopDensity LandArea

// Task 5: Create a table presenting estimates of Model 1 and 2
asdoc reg Mortality GDPpc PopGrowthRate PopDensity LandArea, replace nest cnames(Model 1_OLS) title(Table 1: Estimates from Model 1 and Model 2)
asdoc reg Mortality c.GDPpc##c.GDPpc PopGrowthRate PopDensity LandArea, nest cnames(Model 2_OLS) title(Table 1: Estimates from Model 1 and Model 2)

// Task 6: Finding the turning point value of GDPpc in Model 2

/*
After taking the partial derivative of GDPpc against Mortality and setting it to zero, the turning point value I found
was: GDPpc = $61,369 (as GDPpc was measured in thousand and initial answer was 61.369)
*/

// Task 7: Employ 2SLS methodology to re-estimate Model 1 and 2

// Model 1
ivregress 2sls Mortality (GDPpc = Debt DepRatio) PopGrowthRate PopDensity LandArea
// Model 2
ivregress 2sls Mortality (c.GDPpc##c.GDPpc = Debt DepRatio) PopGrowthRate PopDensity LandArea

// Task 8: Add results from Task 7 to Table 1 

asdoc ivregress 2sls Mortality (GDPpc = Debt DepRatio) PopGrowthRate PopDensity LandArea, nest cnames(Model1_2SLS) title(Table 1: Estimates from Model 1 and Model 2)
asdoc ivregress 2sls Mortality (c.GDPpc##c.GDPpc = Debt DepRatio) PopGrowthRate PopDensity LandArea, nest cnames(Model2_2SLS) title(Table 1: Estimates from Model 1 and Model 2)

/* Task 9: Visualize estimated quadratic relationship between mortality (from pollution) and GDPpc */

// Summarize GDPpc to obtain range of (independent variable) values
sum GDPpc

// Generate graph for OLS method
reg Mortality c.GDPpc##c.GDPpc PopGrowthRate PopDensity LandArea
margins, at(GDPpc = (0 (10) 120))
marginsplot, xdimension(GDPpc)

// Generate graph for 2SLS method
ivregress 2sls Mortality (c.GDPpc##c.GDPpc = Debt DepRatio) PopGrowthRate PopDensity LandArea
margins, at(GDPpc = (0 (10) 120))
marginsplot, xdimension(GDPpc)

// Task 10: Interpretation and discussion of findings

/*
Turning point value for 2SLS Model: GDPpc = $27,380 (maximum point, rounded to 2 decimal points)

In Lin and Liscow's paper, they found evidence for an inverted-U relationship between income and environmental degredation forseven out of eleven water pollutants using the IV (2SLS) model, and no inverted-U relationship for any pollutants using the OLS method. 

In our results however, we found an opposite relationship - a U-shaped curve between environmental degredation (which we measure through mortality rate) and income, that was significant. This contrasts the EKC that was found in Lin and Liscow's paper using the IV/2SLS method. In addition, also contrasting their results as they could not find a statistically significant relationship between environmental degredation and income using the OLS method. In contrast, our findings show that b1 and b2 (parameters for GDPpc and GDPPc squared) were significant at all significant levels (p-value was: 0.000). However, as Lin and Liscow outlined in their paper, there are reasons to believe that environmental degredation and income may be endogenous (e.g. have a cyclical relationship). If this is true, this means rule #4 would be violated and our OLS estimates would not be reliable (even if they currently state itself as significant).

To examine this, it may be more helpful to compare our findings in Model 2 (the quadratic model) but using the 2SLS method instead. I also suggest running the STATA command: estat endog to check if income is truly endogenous in our data. 
*/
// Check endogeneity
ivregress 2sls Mortality (c.GDPpc##c.GDPpc = Debt DepRatio) PopGrowthRate PopDensity LandArea
estat endog

/*
Running Durbin and Hausman's test, the p-value for both tests are 0.0001 and 0.0000 respectively. Therefore, we do reject the null hypothesis and conclude that our model contains endogenous variables (income) and rule #4 is violated. This finding aligns with Lin and Liscow's paper as they too, found that the variable they used for income was endogenous which called for instrument variables. As OLS estimates are no longer reliable, we should instead look at the model using the 2SLS method. 

In our 2SLS model, we do find an inverse u-shaped curve that mirrors EKC theory and the one that is found in Lin and Liscow's paper. This differs from our OLS method estimates which show a "flipped relationship," but as we established that our OLS estimates are not reliable, we should choose the 2SLS model. Unfortunately, our results (p-values) show that the relationship is not statistically significant. This can also be observed by the confidence intervals on the graph itself, which includes zero and are very wide. This differs from Lin and Liscow's results where their relationship was statistically significant for seven out of eleven water pollutants. However, it is important to note that although our dependent variables (water pollutants and mortality from pollution) by theory should be strongly correlated, they are still not the exact same variables and may contain discrepency. In addition, one could argue that our results could line up with the remaining four water pollutants, where a statistically significant relationship was not found. 

A likely better observation however, is that although our and Lin and Liscow's model uses the same variables, debt and dependency ratio to instrument income, the paper pointed out that political variables/indicators may have a statistically significant effect on pollution. This was supported through their findings where five out of eleven pollutions were significantly affected by political indicators. This provides convincing reasons to suggest that our model may similarly be missing political variables, which results in an unaccounted third-party variable that currently makes our model not statistically significant. By adding political indicators, we may be able to re-estimate our regression model using the 2SLS method and obtain results that better align with EKC and Lin and Liscow's paper.   

*/

