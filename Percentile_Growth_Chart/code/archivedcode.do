// Task A: Replicating Percentile Growth Chart (From Saez & Zucman (2020, JEP) -- Task 1)

// https://wid.world/codes-dictionary/#pretax-income

// Step 0: Clear
clear 

// Step 1: Import Data from CSV files


// Import and save each dataset with a unique name
import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW1/Data/income_data_1.csv", delimiter(";") clear
save "temp1.dta", replace

import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW1/Data/income_data_2.csv", delimiter(";") clear
save "temp2.dta", replace

import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW1/Data/income_data_3.csv", delimiter(";") clear
save "temp3.dta", replace

import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW1/Data/income_data_4.csv", delimiter(";") clear
save "temp4.dta", replace

import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW1/Data/income_data_5.csv", delimiter(";") clear
save "temp5.dta", replace

// Append all datasets together
use "temp1.dta", clear
append using "temp2.dta"
append using "temp3.dta"
append using "temp4.dta"
append using "temp5.dta"

// Save the final appended dataset
save "/Users/garnleangphibul/Desktop/STATA/EC319_HW1/Data/income_data_combined.dta", replace

// Clean up temporary files
erase "temp1.dta"
erase "temp2.dta"
erase "temp3.dta"
erase "temp4.dta"
erase "temp5.dta"


// Step 2: Clean the data
// Rename variables

rename v1 percentile
rename v2 year
rename v3 pre_tax_incm

// Drop non data rows
drop in 781/788
drop in 616/620
drop in 411/415
drop in 206/210
drop in 1/5


// Add labels to variables
label variable percentile "Income Percentile"
label variable year "Year"
label variable pre_tax_incm "Pre-Tax Annual Income"

// Make sure variables are of the correct type
destring pre_tax_incm, replace

// Combine equal-split and individual income (for top 1%)
replace pre_tax_incm = v4 if missing(pre_tax_incm)
drop v4

// Drop any missing variables

drop if pre_tax_incm == .

// Step 3: Create Percentile Growth Chart - Calculate average growth for percentile group

// Generate numeric percentile variable (for plotting)
gen percentile_i = 0

forvalues i = 1(5)91 {
    local j = `i' + 4
    replace percentile_i = `j' if percentile == "p`i'p`j'"
}

// Special cases (special percentiles):
replace percentile_i = 98 if percentile == "p96p98"
replace percentile_i = 100 if percentile == "p99p100"

sort percentile_i year

// Calculating growth rate in pre-tax income per each percentile
bys percentile_i: generate growth_rate = (pre_tax_incm - pre_tax_incm[_n-1]) / pre_tax_incm[_n-1] * 100 if _n > 1

// Calculating average growth
egen average_growth = mean(growth_rate), by(percentile_i)


// Step 4: Create Percentile Growth Chart -- produce the graph

twoway line average_growth percentile_i, title("{bf:Average Growth in (Pre-tax) National Income by Percentile Group}", size(med)) subtitle("From 1980-2019") xtitle("Income Percentile") ytitle("Avg. Growth Rate in Pre-tax National Income (%)", size(medsmall)) plotregion(margin(r=10)) graphregion(margin(r=10)) name(scatter1, replace)


// Past code

// twoway line avg_incm_growth percentile_i

// scatter temp2 percentile_i



// gen temp=ln(pre_tax_incm)
// sort   percentile  year 
// bys percentile: gen temp2= temp[_n+1]-temp 
// scatter temp2  percentile_i
// ssc install wid
// help wid
// pop(j) == equal split adults
// age 996 --> adults, excluding elderly

/*
foreach i of numlist 0/99 {
wid, indicators(aptinc) areas(US) perc(p`i'p`i+1') year(1980/2018) ages(996) pop(i)
tempfile d`i'
save d`i'
}

use d0 ,clear
foreach n of numlist 1/99{
	append using d`n'
}

wid, indicators(aptinc) areas(US) perc(p0p10 p10p20 p20p30 p30p40 p40p50 p50p60 p60p70 p70p80 p80p90 p90p95 p95p99 p0p50) year(1980/2018) ages(996) pop(i) 

wid, indicators(aptinc) areas(US) perc(p0p50) year(1980/2018) ages(996) pop(i)
*/

// For Bottom 50
/*replace avg_incm_growth = ((19789.5 - 14490.5) / 14490.5 * 100) / 40 if percentile =="p0p50"
replace percentile_i = 50 if percentile == "p0p50"
*/

// gen avg_incm_growth = 1



/*
// Calculating growth between each year
gen temp=ln(pre_tax_incm)
sort   percentile_i  year 
bys percentile: gen temp2= temp[_n+1]-temp 

// Calculating average growth for each percentile group
egen average_growth = mean(temp2), by(percentile)
*/

