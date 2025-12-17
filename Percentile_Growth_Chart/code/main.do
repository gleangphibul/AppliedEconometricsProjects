// clear all
// set more off
// global student_name "enter your name here"
// set seed 12345
// You do not need to edit the following section:
*-------------------------------------------------------------*
* Set the path to this do-file dynamically
local thisfile "`c(pwd)'/main.do"
* Run setup do-file to define directories and install packages
do "$project_root/1_setup.do"
* Run data processing and analysis do-file
do "2_data.do"
do "3_analysis.do"
* Display completion message
display as result "Assignment execution completed. Check output/ folder for results."
*-------------------------------------------------------------*
