// Set up file: e.g. setting up working directory

local current_path : pwd
cd "`current_path'"
cd ".."
global project_root "`c(pwd)'"
cd "$project_root"
capture mkdir "data"
capture mkdir "output"
capture mkdir "output/logs"
capture mkdir "output/tables"
capture mkdir "output/figures"
set more off
set max_memory 2048m
set linesize 120
quietly display "Stata Session Info"
quietly display "===================="
quietly display "Date: " c(current_date)
quietly display "Student: ${student_name}"
quietly display "Stata version: " c(stata_version)

quietly display "Working directory: " c(pwd)
