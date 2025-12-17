// Task A: Replicating Percentile Growth Chart (From Saez & Zucman (2020, JEP) -- Task 1)

// Data from: https://wid.world/codes-dictionary/#pretax-income

// Step 1: Get the data
use "$project_root/data/income_data_combined.dta", clear

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

twoway line average_growth percentile_i, title("{bf:Average Growth in (Pre-tax) National Income by Percentile Group}", size(med)) subtitle("From 1980-2019") xtitle("Income Percentile") ytitle("Avg. Growth Rate in Pre-tax National Income (%)", size(medsmall)) plotregion(margin(r=10)) graphregion(margin(r=10)) name(income_per_chart, replace)
graph export "$project_root/output/income_per_chart.png", replace
