*******************************Replication Assignment*********************************************************

* Task 0: Import the dta file

clear 
use "/Users/garnleangphibul/Downloads/replication.dta"

* Task 1: Summarize the data in a table
* Stata summarizes all the variables by default, however on the report, I will exclude the entity variable (id_offer)
sum


* Task 2: Summarize data by jobs for which all 8 kinds of resumes were sent
bys all8: sum

* Task 3: Hypothesis test about population mean of one population (age of job applicant)

* extracting information by hand
sum age

* hypothesis testing using stata
ttest age == 30

* Task 4: Hypothesis test about population proportion of one population (sex of labor force)

* extracting information by hand
sum sex

* hypothesis testing using stata
prtest sex == 0.45

* Task 5: Hypothesis test about population proportion of one population (public college attendance)

* extracting information by hand
sum public_college 


* hypothesis testing using stata
prtest public_college == 0.62

* Task 6: Comparing two populations (by gender) and testing for differences in the other variables

* Hypothesis testing differences by gender in the following variables using stata (for table)
prtest married, by(sex)
ttest age, by(sex) unequal
prtest public_highschool, by(sex)
prtest scholarship, by(sex)
prtest public_college, by(sex)
ttest english, by(sex) unequal
prtest other_language, by(sex)
prtest leadership, by(sex)
prtest callback, by(sex)
prtest ss_degree, by(sex)
prtest some_availab, by(sex)
prtest photo1, by(sex)
prtest photo2, by(sex)
prtest photo4, by(sex)

* Testing one variable (other_language) by hand and extracting data for it
bys sex: sum other_language


* Task 7: Hypothesis test about population mean (age) for three or more populations (different phenotypes)

* (scrapped) generating a race variable first
* gen race = 0
* replace race = 1 if photo1 == 1
* replace race = 2 if photo2 == 1
* replace race = 3 if photo4 == 1
* label var race "0 = indigenous, 1 = white, 2 = mestizo, 3 = no photo"

* extracting information by hand
bys photo: sum age

* hypothesis testing using stata 
oneway age photo

* Task 8: Summarizing (& hypothesis testing) callback rates by phenotype for men and women
* restricting sample to only those which received all 8 resumes.

* For women 
tab callback photo if all8 == 1 & sex == 1, chi2
tab callback photo if all8 == 1 & sex == 1 & married == 0, chi2
tab callback photo if all8 == 1 & sex == 1 & married == 1, chi2
tab callback photo if all8 == 1 & sex == 1 & public_college == 1, chi2
tab callback photo if all8 == 1 & sex == 1 & public_college == 0, chi2

* For men
tab callback photo if all8 == 1 & sex == 0, chi2
tab callback photo if all8 == 1 & sex == 0 & married == 0, chi2
tab callback photo if all8 == 1 & sex == 0 & married == 1, chi2
tab callback photo if all8 == 1 & sex == 0 & public_college == 1, chi2
tab callback photo if all8 == 1 & sex == 0 & public_college == 0, chi2

* Task 9: Hypothesis testing about independence for 3 or more populations

* extracting information by hand
tab callback photo

* hypothesis testing using STATA
tab callback photo, chi2


* Task 10: Regression analysis on callback rate as a dependent variable and looking at different 
* independent variables and using the same controlled variables: age, business dummy, scholarship
* dummy, public highschool dummy, dummies for foreign language, and a leadership dummy

* First column
reg callback sex public_college married photo1 photo2 photo4 age ss_degree scholarship public_highschool english other_language leadership 

* Second column
reg callback public_college married photo1 photo2 photo4 age ss_degree scholarship public_highschool english other_language leadership if sex==1


* Third column
reg callback public_college married photo1 photo2 photo4 age ss_degree scholarship public_highschool english other_language leadership if sex==0

* Fourth column
reg callback sex public_college married photo1 photo2 photo4 age ss_degree scholarship public_highschool english other_language leadership if all8==1

* Fifth column
reg callback public_college married photo1 photo2 photo4 age ss_degree scholarship public_highschool english other_language leadership if all8==1 & sex==1

* Sixth column
reg callback public_college married photo1 photo2 photo4 age ss_degree scholarship public_highschool english other_language leadership if all8==1 & sex==0



