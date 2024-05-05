# NBA-Salary-Performance-Analysis

# Economic Efficiency in Fantasy Sports: A Detailed Analysis of NBA Salaries and Performance

## Project Overview
This project investigates the economic efficiency in fantasy sports by analyzing the relationship between NBA players' salaries and their performance outcomes. Using data from the NBA Daily Fantasy Market on DraftKings, we explored trends and factors influencing players' salaries across different games and scenarios from 2019 to 2023.

## Objectives
- To determine how salaries of NBA players in daily fantasy sports correlate with their actual game performance.
- To identify instances of players being overvalued or undervalued in relation to their performance metrics.

## Data Sources
- NBA player performance and salary data spanning from 2019 to 2023, extracted from the DraftKings platform.

## Methodology
- **Data Cleaning**: Standardized and cleaned data to ensure accuracy in analysis.
- **Exploratory Data Analysis**: Conducted initial analysis to understand the distribution of data and identify outliers.
- **Statistical Analysis**: Used linear regression models to assess the relationship between player salaries and performance. Analyzed residuals to identify overvalued and undervalued players.
- **Visualizations**: Created histograms, scatter plots, and box plots to visualize data distributions and regression results.

## Key Findings
- **Salary Justification**: Players' salaries showed a positive relationship with fantasy points across all platforms, suggesting that higher salaries are generally justified by higher performance.
- **Salary Inconsistency**: Salaries set by DraftKings show inconsistencies, especially for players on teams lacking star power, and seem not to significantly factor in whether games are home or away.
- **Impact of External Factors**: Both team and venue showed significant effects on players' salaries and performance. Defensive strength of opposing teams also influenced salary settings.
- **Economic Inefficiencies**: Identified economic inefficiencies where players were overvalued or undervalued based on the variance of residuals in their salary-performance model.

## How to Run the Code

This section provides step-by-step instructions to set up and execute the analysis for the project "Economic Efficiency in Fantasy Sports: A Detailed Analysis of NBA Salaries and Performance".

### Prerequisites
To run the code, you will need:
- R: The code is written in R. If you do not have R installed, you can download and install it from [The Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/mirrors.html).
- RStudio (optional): While not necessary, RStudio provides a convenient and user-friendly interface for working with R projects. Download and install it from [RStudio's website](https://rstudio.com/products/rstudio/download/).

### Required R Packages
The script uses several R packages. Before running the analysis, you need to install these packages. Open R or RStudio, and run the following commands:

```R
install.packages("dplyr")      # For data manipulation
install.packages("ggplot2")    # For data visualization
install.packages("readr")      # For reading CSV data files
install.packages("lmtest")     # For diagnostic tests on linear regression models
