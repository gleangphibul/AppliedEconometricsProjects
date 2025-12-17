// Task A: Recreating Wealth-Income Ratio Graph for US 1950-today (2024) (From Piketty & Zucman (2014, JEP) -- Task 2)

// For the US

// Step 0: Clear
clear

// Step 1: Import CSV File

import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW2/data/wealth_income_data.csv", delimiter(";") clear


// Step 2: Clean the Data

// Rename the variables

rename v1 id
rename v2 year
rename v3 wealth
rename v4 national_inc

// Drop non-data rows

drop in 1/8

// Add labels to variables
label variable wealth "Market value national wealth (US)"
label variable national_inc "National Income (US)"

// Make sure variables are of the correct type
destring wealth, replace
destring year, replace

// Step 3: Create Wealth-Income Ratio Graph

// Calculating wealth-income ratio
generate wi_ratio = wealth / national_inc

// Graph the wealth-income ratio over the years (1950-2024)
twoway line wi_ratio year, title("{bf: Wealth-Income Ratio in the US (1950-Present)}", size(med)) xtitle("Year") ytitle("Wealth-Income Ratio", size(medsmall)) name(US_wi_graph, replace)

// Save the graph to the output folder
graph export "/Users/garnleangphibul/Desktop/STATA/EC319_HW2/output/US_wi_graph.png", as(png) name("US_wi_graph")

// For the UK

// Step 0: Clear
clear

// Step 1: Import CSV File

import delimited "/Users/garnleangphibul/Desktop/STATA/EC319_HW2/data/wealth_income_data2.csv", delimiter(";") clear


// Step 2: Clean the Data

// Rename the variables

rename v1 id
rename v2 year
rename v3 wealth
rename v4 national_inc

// Drop non-data rows

drop in 1/8

// Add labels to variables
label variable wealth "Market value national wealth (UK)"
label variable national_inc "National Income (UK)"

// Make sure variables are of the correct type
destring wealth, replace
destring year, replace

// Step 3: Create Wealth-Income Ratio Graph

// Calculating wealth-income ratio
generate wi_ratio = wealth / national_inc

// Graph the wealth-income ratio over the years (1950-2024)
twoway line wi_ratio year, title("{bf: Wealth-Income Ratio in the UK (1870-2010)}", size(med)) xtitle("Year") ytitle("Wealth-Income Ratio", size(medsmall)) name(UK_wi_graph, replace)

// Save the graph to the output folder
graph export "/Users/garnleangphibul/Desktop/STATA/EC319_HW2/output/UK_wi_graph.png", as(png) name("UK_wi_graph")


