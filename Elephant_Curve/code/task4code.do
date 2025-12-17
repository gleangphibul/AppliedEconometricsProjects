
// Import the data

clear
cd "/Users/garnleangphibul/Desktop/STATA/EC319_HW4/data"

import delimited "data_1.csv", delimiter(";") clear
save "temp1.dta", replace

import delimited "data_2.csv", delimiter(";") clear
save "temp2.dta", replace

import delimited "data_3.csv", delimiter(";") clear
save "temp3.dta", replace

import delimited "data_4.csv", delimiter(";") clear
save "temp4.dta", replace

import delimited "data_5.csv", delimiter(";") clear
save "temp5.dta", replace

// Append all datasets together
use "temp1.dta", clear
append using "temp2.dta"
append using "temp3.dta"
append using "temp4.dta"
append using "temp5.dta"

save "data_combined.dta", replace

// Clean up temporary files
erase "temp1.dta"
erase "temp2.dta"
erase "temp3.dta"
erase "temp4.dta"
erase "temp5.dta"

// Clean the data
// Rename variables

rename v1 percentile
rename v2 year
rename v3 pre_tax_incm

// Drop non data rows
drop in 61/65
drop in 46/50
drop in 31/35
drop in 16/20
drop in 1/5

// Add labels to variables
label variable percentile "Income Percentile"
label variable year "Year"
label variable pre_tax_incm "Pre-Tax Annual Income"

// Make sure variables are of the correct type
destring pre_tax_incm, replace

// Create Percentile Growth Chart - Calculate average growth for percentile group
gen percentile_i = 0

forvalues i = 1(5)91 {
    local j = `i' + 4
    replace percentile_i = `j' if percentile == "p`i'p`j'"
}

replace percentile_i = 99 if percentile == "p96p99"
replace percentile_i = 100 if percentile == "p99p100"

bys percentile_i: generate growth_rate = ((pre_tax_incm - pre_tax_incm[_n-1]) / pre_tax_incm[_n-1]) * 100 if _n > 1

// Now graph it

twoway line growth_rate percentile_i, title("{bf:Change in real pre-tax income by percentile group, 2008-2024}", size(med)) subtitle("(World distribution)") xtitle("World income percentile") ytitle("Real PPP income change (%)") name(elephant_curve, replace)
 
// Save the graph to the output folder
graph export "/Users/garnleangphibul/Desktop/STATA/EC319_HW4/output/elephant_curve.png", as(png) name("elephant_curve")




