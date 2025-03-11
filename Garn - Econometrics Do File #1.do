/* EC-339: Applied Econometrics, Do-File #1
Garn Leangphibul */

// Task 1: Importing data
/* Import excel data into STATA */
clear
use "/Users/garnleangphibul/Downloads/Data_1 (1).dta"

/* Ensure each variable has correct name and is correctly labeled 
(based on provided description) */
label variable Pop "Population (millions)"
label variable PopGrowthRate "Average Annual Growth Rate of Population (%)"
label variable PopDensity "People per square km of land"
label variable GDP "GDP, PPP (constant 2011 billion $)"
label variable LandArea "Area in square km"
label variable GDPpc "GDP per capita (constant 2011 $)"
label variable SDGI "Sustainable Development Goals Index"
label variable EPI2018Score "Value of Environmental Performance Indicator in 2018"
label variable EPI2018Rank "Ranking based on EPI2018Score"

// Task 2: Summarizing our variables
// Generate a table for all descriptive statistics in Data_1
asdoc sum Pop PopGrowthRate PopDensity GDP LandArea GDPpc SDGI EPI2018Score EPI2018Rank, replace dec(2)

// Task 3: Regressing our first model
reg EPI2018Score GDPpc PopGrowthRate PopDensity LandArea

// Task 4: Discussing expectations of relationship between environmental quality and income, and comparing it with our findings

/* In Grossman and Kreuger's paper, they found a quadratic, inverse u-shaped curve between income and measures of environmental pollution where at low levels of income, increases in economic activity (which is linked to increase in income) leads to more environmental damage, however after a certain level and at higher levels of income (e.g. above $8000 real income per capita in the paper), increases in income causes environmental damage to fall. Grossman and Kreuger conclude that their findings do not show evidence that environmental damage consistently deteriorates withe economic growth, but instead economic growth initially brings a period of environmental deterioriation, followed by environmental improvements with later economic growth. 

As we are using a linear model, while Grossman and Kreuger uses a quadratic model, I believe that it is not possible to completely match Grossman and Kreuger's findings to generate expectations of beta-1 in our model. However, it may be possible that our model shows half of the relationship between economic growth and environmental deterioration that is shown in the paper. Applying the conceptual findings of the paper, if most observations' GDP per capita data sits below the turning point, we will see a positive trend between income growth and environmental deterioriation (EPI2018Score goes down as income rises), so beta-1 is negative. If our observations' GDPpc sits above the turning point however, then income growth should result in less environmental degredation (EPI2018Score increases), so beta-1 is positive. As we also use different data sets, I am not able to use the same turning point ($8000) found in the paper, however it is possible to do so through a quadratic model (which I will do in Task 6-7).

Our findings show that the coefficient we receive for b1 is an extremely positive number (0.000496). This shows either a very small positive relationship (indicating that our data sits mostly above the turning point => consistent with our half picture argument), or that there is almost no relationship at all (in this case, the linear model does not/cannot match Grossman and Kreuger's quadratic model which we also acknowledged as a possibility).
*/

// Task 5: Re-estimating model 1 but measuring GDPpc in thousands
/* From question 4, the initial estimated partial impact of GDP per capita on the environmental performance index is 0.000496. */

// Re-estimating partial impact of GDPpc on EPI2018Score, using thousand US dollars
replace GDPpc = GDPpc/1000
reg EPI2018Score GDPpc PopGrowthRate PopDensity LandArea

/* After re-estimating the population regression function in model 1, using thousand US dollars as measurement for GDPpc instead, the new partial impact of GDPpc on EPI2018Score is 0.496. This aligns with our expectations if we were to follow the "half-picture" argument, again, a positive b1/slope value indicates that most our observations sit above the turning point. 

One advantage of measuring GDP per capita in one thousand dollars instead of one dollar is that a change in 1 US dollar is unlikely to make a difference or have a sufficiently evident impact on our dependent variable, EPI2018Score (think a $1 increase in your salary versus a $1000 increase). On the contrary, a $1000 change in income will likely have a more visible impact, allowing us to better (more accurately) estimate the partial relationship between GDPpc and EPI2018Score.
*/
 
// Task 6: Presenting our results of model 1 and model 2 through a table
/* Create a table that presents the results, including the estimates from both
model 1 and model 2 */
 
// Estimating and adding Model 1 to the table
asdoc reg EPI2018Score GDPpc PopGrowthRate PopDensity LandArea, nest cnames(Linear Model)
 
// Estimating and adding Model 2 to the table
gen GDPpc_2 = GDPpc * GDPpc
asdoc reg EPI2018Score c.GDPpc##c.GDPpc PopGrowthRate PopDensity LandArea, nest cnames(Quadratic Model)
 
 // Task 7: Graphs and discussion of our findings
 /* Generate graphs showcasing the estimated relationships between environmental quality and 
 income obtained from models 1 and 2 */
 
 // Generate Graph for Model 1
 reg EPI2018Score GDPpc PopGrowthRate PopDensity LandArea
 gen yhat1 = _b[_cons] + _b[GDPpc]*GDPpc
 twoway(line yhat1 GDPpc, sort)(scatter EPI2018Score GDPpc, sort)
 
 // Generate Graph for Model 2
 reg EPI2018Score c.GDPpc##c.GDPpc PopGrowthRate PopDensity LandArea
 margins, at(GDPpc =  (0 (10) 120))
 marginsplot, xdimension(GDPpc)
 
 /* 
 In Model 1, the graph shows a positive relationship between GDPpc and EPI2018Score, meaning that with economic growth (e.g. as income increases), environmental conditions improve. However, it is importance to note that linear models may only show a part of the picture, and there may be one or more turning points that cannot be represented in linear models. As a result, it is likely more insightful to discuss the nature of the relationship environmental quality and income, based on our findings in our quadratic model (model 2). 
 
Model 2 does indeed show that there is a turning point that was missed by solely  looking at Model 1 (our linear model). Our findings from model 2 illustrate that initially increases in income (GDPpc) results in better environmental quality, up to a turning point of around $70,000 (as GDPpc is now measured in thousand dollars). After this turning point, increaes in income leads to environmental deterioration (EPIScore2018 falls). However, it is important to note that only 4 countries out of our 180 observations have a GDPpc that exceeds $70,000 (this was found using the "drop if GDppc < 70" command). With such a small sample size for high GDPpc countries, the supposed negative relationship between income and environmental quality at higher levels of income may not be statistically significant. Our linear model which shows an overall positive relationship between environmental quality and income may deserve more credit than we initially stated in paragraph 1 (as we cannot be confident in claiming a negative relationship between environmental quality and income). Overall, findings from both models agree that our data shows a generally positive relationship between environmental quality and income (with a potential turning point for extremely high income countries, but this should be further examined, preferably with more observation data). For now, we should conclude that our findings show a positive relationship between environmental quality and income. 
 */

// Task 8: Comparison with Grossman and Kreugar's model
 
/* 

One major similarity between our model and Grossman and Kreuger's model is finding the same inverse u-shaped curve between environmental quality and income. However, it is important to note that although we similarly used GDP per capita as the measure of income, in our dependent variable, we measured environmental quality using the variable EPI2018Score, whereas the paper used various measures of environmental pollution such as sulphur dioxiode and smoke in cities, and nitrates in rivers. Therefore, a major distinction is that an increase in our dependent variable means improving environmental quality, whereas an increase in the paper's dependent variable meant worsening environmental quality. Therefore, this in reality, shows that our model versus Grossman and Kreuger's model shows different relationships between income and environmental quality, or at the very least, potentially the same/similar relationship between environmental quality and income but at different stages (income levels). 

A major explanation for this is that in the paper, Grossman and Kreuger ran their regression using a cubic model, whereas so far we have only regressed using a linear and quadratic model. As a result, there may be other turning points that exist in the reality of the relationship between environmental quality and income that was not found in our models. Our model may not be able to completely match Grossman and Kreuger's as it may only show part of the picture shown in their model. This discrepancy may also be explained by the fact that we used a different data set in our model than Grossman and Kreuger. Not only does different data result in potentially different relationships, for example, Grossman and Kreuger did their regression sometime before 1995 whereas we use data from 2018; the relationship between environmental quality and income may have changed overtime due to external variables (e.g. change in trends, policies, variable of time itself). In addition, the fact that our dataset contains different values for GDP per capita in itself, makes it difficult to map our turning point to the paper's (a challenge which we mentioned in task 4). Assuming that we could use Grossman and Kreuger's turning point at $8000 GDPpc, our mean GDPpc which equals $17744 could explain the difference in relationship between our model versus the paper's model. As our data mainly sits above/beyond Grossman and Kreuger's turning point, both model expectations would then align that there is a positive relationship between environmental quality and income (at high income levels), until another turning point (the turning point in our quadratic model and 2nd turning point in the paper's cubic model) where environmental quality worsens with additional income. Here, a similarity would also be that both models agree that due to a small number of observations above this income level, this negative relationship between environmental quality and economic growth (at extremely high levels of income) may not be statistically significant and would need more examination (e.g. more data). However, these similarities rest on the basis that we can use the same turning point that Grossman and Kreuger found, which is not possible (and not reliable) due to using different data.

Another difference that can be found between our findings and those presented in the paper is that our turning point may not significant due to only 4 observations that sit above the GDPpc turning point. However, in Grossman and Kreuger's paper, they at least found that the first turning point that resulted in their U-shaped curve was significant. If we focus on the relationship however, there may be a similarity. Again, due to insufficient observations (above the turning point) we cannot be confident that environmental quality worsens with income (at extremely high income levels). Grossman and Kreuger initially found the same relationship also for extremely high income levels, and decided to omit this second turning point and instead present just an inverse u-shaped curve for the same reason: "relatively small number of observations for sites with income above $16000". A potential reason as to why these similarities are not immediately clear is due to differences in our regression models. Apart from using a different dependent variable and polynomial power (linear & quadratic vs cubic, as mentioned in paragraph 1 & 2), in addition to GDPpc, Grossman and Kreuger also included an average GDppc over a prior 3-year period as an independent variable. Furthermore, they also used other "covariates" (independent variables) that were not specified and could be different from our model (which were e.g. population growth, density). 

Therefore, despite both models finding similar conclusions that at a certain income level, environmental quality and income have a positive relationship, and that there is yet to be statistically significant evidence suggesting that a growth in income deterioriates the environment, using different data makes it challenging to determine and match a specific GDPpc turning point value. In addition, using dissimilar regression models causes us and the paper to have slightly different expectations on the relationship between environmental quality and income (primarily linear & quadratic vs cubic), making it difficult to determine if both models draw the same conclusion/agree. In our case, this resulted in us trying to match our model as part of the picture of Grossman and Kreuger's model. 

*/
 
 // Task 9: Cubic Model
 sum GDPpc
 
 // reg EPI2018Score c.GDPpc##c.GDPpc_2 PopGrowthRate PopDensity LandArea
 reg EPI2018Score c.GDPpc##c.GDPpc##c.GDPpc PopGrowthRate PopDensity LandArea
 margins, at(GDPpc =  (0 (10) 120))
 marginsplot, xdimension(GDPpc)
 
 /* Through a cubic regression model, we found another potential turning point at around GDPpc = $110,000, suggesting that at extremely high income levels, environmental quality begins to improve again with economic growth. However, because only one country (Qatar) sits above this turning point. This result may be even less statistically significant (and therefore more unreliable), than the initial turning point we found at $70,000 which had only 4 observations.
 
 // Task 10: Discussion - Proposal of 3 feasible ideas to develop upon this research
 
 /*
 
 To further develop this research, one potential idea is to try adding other independent variables that may affect environmental quality. This can include categorical variables such as political party (or even a binary variable such as "agreed to the Paris agreement"), and continuous variables such as "annual funding towards the environmental department." The purpose of this is to experiment and see what other variables may have an impact on environmental quality and by adding them, ideally lowering the unexplained portions in our model. Once we have identified additional independent variables that have a statistically significant impact on environmental quality, we can then hold them constant using regression analysis and taking the partial relationship, allowing us to more accurately estimate the relationship between environmental quality and income. 
 
Another suggestion is to use different dependent variables to measure environmental quality, for example, a change in EPI2018Score, or a water quality index. By examining the relationship between income on different measures of the environment, we may obtain more specific insight, for example how different areas of the environment (e.g. air, water, land) may be affected differently by economic growth, or may experience the impact of an increase in income at varying intensities (strength of relationship). Grossman and Kreuger diversified their measures of environmental quality (e.g. smoke in cities, dissolved oxygen in rivers) which allowed them to draw conclusions on how economic growth affected different parts of the environment. It may be helpful to even use the same dependent variables as they did as we are using a different data set (from 2018 instead of 1995). Therefore, allowing us to contribute insight by testing whether the same relationship they found between economic growth and environmental quality in 1995 is still statistically significant in 2018.

Finally, as current literature on the relationship between environmenmental quality and economic growth primarily theorizes that expanding the economy initially results in detrimental impacts on the environment, but is later rectified due to pressure from citizens and better technology. This relies on the fact that a certain percentage of citizens have reached an income level where they can afford to focus on non-economic variables (such as environmental cleanliness) and begin pursuing improvements in living quality beyond basic survival. Likewise, this income "threshold" similarly applies to businesses who must earn sufficient revenue to expand and invest in more sustainable technology. Therefore, an important part of developing this research is finding measures that accurately represent income/economic growth, to accurately study its relationship with environmental quality. Both of our and the paper's models currently use GDP per capita as a variable representing income. However, a drawback of using GDPpc is that as an average, issues with using GDPpc may arise in countries with high income inequality. For example, a country with extreme wealth concentrated amongst a few individuals may skew GDPpc upwards and on data, depict the country as high-income level, even if a majority of its citizens live in low/medium income conditions, and are still focusing on economic variables for survival. Therefore, further ideas can be directed towards finding more accurate measures of a country's income. For example, using "median salary" could help account that atleast 50% of the poppulation earns income above the median level (potentially providing a slightly more accurate average measure than GDPpc). To be even more thorough, "minimum wage" could also be used as the income measure, to ensure that at least everyone (who is working) is exactly at or above the minimum wage income. 

A notable suggestion directly relevant to both our and Grossman and Kreuger's model is that we could not identify confidently whether some turning points were statistically significant due to a small number of observations for high-income countries. This is a major limitation and increasing observations of high-income countries could be highly beneficial in helping us answer questions related to the relationship between environmental quality and income at high income levels (may help predict future relationships as more countries grow richer). However, I did not include this as a suggestion as both data in our and the paper's model already included so many countries, and it is not exactly feasible to "add" more high-income observations (cannot just make a country richer). Therefore, this point remains as just an important limitation to note.

 */

