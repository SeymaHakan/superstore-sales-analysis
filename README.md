# Superstore Sales Analysis

# Project Overview

This project analyzes the Superstore Sales dataset to uncover key insights about sales performance, regional trends, and profitability. The analysis includes data cleaning, exploratory data analysis (EDA), and interactive dashboard visualization.

The goal is to transform raw sales data into actionable business insights that can support data-driven decision-making.

# Dataset

The dataset used in this project is the Supermarket Sales dataset, commonly used in business analytics and data visualization applications.

It contains information about:

Customer segments

Product categories

Sales

Profit

Discounts

Ship mode

Regions and cities

# Tools Used

SQL (MySQL) – Data cleaning and exploratory data analysis

Tableau – Interactive dashboard visualization

Excel / CSV Dataset

# Data Cleaning

The following data cleaning steps were performed:

A backup working table was created for safe analysis

Duplicate records were checked using window functions

Missing (NULL) values ​​were verified

Column names were standardized

Data consistency was verified

# Example SQL used:

ROW_NUMBER() OVER (
PARTITION BY Ship_Mode, Segment, Country, City, State, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit
)
# Exploratory Data Analysis (EDA)

Key business questions examined:

Which product category generates the highest sales?

Which region generates the highest revenue?

Which city generates the highest sales?

How do discounts affect profitability?

# Key insights

Some findings from the analysis:

Technology is the category that generates the highest revenue.

The western region generates the highest total sales.

New York City has the highest sales among all cities.

Higher discounts are generally associated with lower profitability.

# Tableau Dashboard

The interactive dashboard visualizes key metrics including:

Sales by Category

Sales by Region

Top Cities by Sales

Profit Analysis

Discount Impact

Dashboard Preview:

# Interactive Tableau Dashboard:

https://public.tableau.com/app/profile/.eyma.hakan/viz/superstore_sales_dashboard_17736049391320/SuperstoreSalesProfitPerformanceAnalysis?publish=yes&showOnboarding=true

Author

Şeyma Hakan
Data Analyst Candidate

# Skills:

SQL

Data Cleaning

Data Analysis

Tableau

Power BI

# LinkedIn:

www.linkedin.com/in/şeyma-hakan-4b84b3205

