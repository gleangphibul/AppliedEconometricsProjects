
clear all 
set more off 
cd "/Users/garnleangphibul/Desktop/STATA/EC319_HW3/data"
use "usa_00027.dta",clear 
*--------- STEP1 --------*
gen byte occ_field = .
replace occ_field = 1 if inrange(occ1990, 3, 38)
replace occ_field = 2 if inrange(occ1990, 43, 200)
replace occ_field = 3 if inrange(occ1990, 203, 390)
replace occ_field = 4 if inrange(occ1990, 403, 470)
replace occ_field = 5 if inrange(occ1990, 473, 500)
replace occ_field = 6 if inrange(occ1990, 503, 700)
replace occ_field = 7 if inrange(occ1990, 703, 890)
lab def occf 1 "Managerial" 2 "Professional" 3"Technical,Sales, AdminSupport" 4 "Service" 5 " Farming" 6 "Production" 7"Laborer"
lab values occ_field occf 
gen byte degree_type =.
    replace degree_type =1 if educd==81|educd==82|educd==83 // associate 
    replace degree_type =2 if educd==101 // bachelor
    replace degree_type =3 if educd==114 // master 
    replace degree_type =4 if educd==115|educd==116 // professional; phd degrees 
lab def degt 1 "AA" 2 "BA" 3"MS" 4 "PHD&Prof." 
lab values degree degt 
egen ID= group(degree occ_f), lab
// for simplicity, only kept employed with non-zero income
keep if empstat==1 
drop if occ_field == .
drop if degree_type==. 
drop if age<30 | age>55
drop if incwage==0
*--------- STEP2 --------*
// calculate hourly wage, 
gen labor_hours= wkswork1*uhrswork 
gen tempwage= incwage / labor_hours 
drop if tempwage==0
// adjust for inflation, and  some trimming 
display 195.3/292.8
* .6670082
replace  tempwage = tempwage / 0.6670082 if year==2006
 summarize tempwage , detail 
 replace tempwage = r(p99) if   tempwage!=. & tempwage>r(p99) 
*--------- STEP3 --------*
// min(10th) as 90% cut  ; min(9th) as 80% cut 
foreach n in 2006 2023 {
 xtile q`n' =tempwage [aw=perwt] if year==`n', nq( 10)
}
foreach n in 2006 2023 {
foreach q in 9 10{
sum tempwage if q`n'==`q'
gen temp_ID`n'_`q'  =ID if tempwage==r(min)
}
}
sum temp_ID*
/* IDs for 80%  & 90 %
temp_ID2006_9 : 10 & 16 
 temp_ID2006_10 : 16 
*/
/*
 temp_ID2023_9 : 9 & 16 
temp_ID2023_10 : 10 
*/
gen femalewage= tempwage if sex==2 
gen malewage= tempwage if sex==1
*--------- STEP4 --------*
save  "cleaned.dta", replace  
*--------- STEP5 --------*
use  "cleaned.dta", clear 
collapse (rawsum) perwt  (mean) femalewage malewage [pw=perwt],by( birthyr year ID )
rename perwt population 
gen f_m= femalewage/malewage
gen f_m_d=1-f_m
// look at your data by year, 2023 VS 2006; 
 scatter f_m_d birthyr if ID==9 , by(year) 
