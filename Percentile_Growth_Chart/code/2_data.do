// Step 0: Clear
clear 

// Step 1: Import Data from CSV files


// Import and save each dataset with a unique name
import delimited "$project_root/data/income_data_1.csv", delimiter(";") clear
save "temp1.dta", replace

import delimited "$project_root/data/income_data_2.csv", delimiter(";") clear
save "temp2.dta", replace

import delimited "$project_root/data/income_data_3.csv", delimiter(";") clear
save "temp3.dta", replace

import delimited "$project_root/data/income_data_4.csv", delimiter(";") clear
save "temp4.dta", replace

import delimited "$project_root/data/income_data_5.csv", delimiter(";") clear
save "temp5.dta", replace

// Append all datasets together
use "temp1.dta", clear
append using "temp2.dta"
append using "temp3.dta"
append using "temp4.dta"
append using "temp5.dta"

// Save the final appended dataset
save "$project_root/data/income_data_combined.dta", replace

// Clean up temporary files
erase "temp1.dta"
erase "temp2.dta"
erase "temp3.dta"
erase "temp4.dta"
erase "temp5.dta"
