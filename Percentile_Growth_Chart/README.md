
## Overview
This package contains the code and data for [Task 1A - Saez and Zucman] submitted by [Garn Leangphibul]. The code is
written in Stata and is designed to be run by peers for review. All outputs (tables, graphs) are saved
to the `output/` folder.
## Directory Structure
- `main.do`: Master do-file that runs the entire assignment.
- `1_setup.do`: Sets up directories and installs required Stata packages.
- `2_data.do`: Sets up directories and installs required Stata packages.
- `3_analysis.do`: Contains the core analysis code.
- `data/`: Contains the dataset (`data.dta`).
- `output/`: Stores generated results (e.g., tables, graphs).
## Prerequisites
- **Stata**: Version 13 or later.
- **Internet Access**: Required to install Stata packages (e.g., `estout`) if not already installed.
- **Dataset**: Ensure `data.dta` is in the `data/` folder.
## How to Run
1. Unzip the assignment folder (`student_assignment/`) to your computer.
2. Open Stata and set the working directory to the `student_assignment/` folder by entering:
> cd "path/to/student_assignment"