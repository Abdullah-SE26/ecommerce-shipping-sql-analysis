# SQL E-Commerce Shipping Data Analysis Project

## Project Overview

This project focuses on exploring and analyzing an e-commerce shipping dataset using SQL.

The project was divided into two main parts:

1. Data Cleaning
2. Exploratory Data Analysis (EDA)

The goal of this project was to practice cleaning raw operational data and uncovering business insights related to shipment delays, warehouse performance, customer behavior, and logistics operations.

---

# Dataset

The dataset contains e-commerce shipping and customer-related information, including:

- Warehouse blocks
- Shipment modes
- Customer ratings
- Product costs
- Discounts offered
- Product importance
- Delivery status
- Product weight
- Customer care calls
- Prior purchases

---

# Tools Used

- MySQL
- SQL
- Aggregate Functions
- CASE Statements
- GROUP BY
- ORDER BY

---

# Project Structure

```text
ecommerce-shipping-sql-analysis/
│
├── README.md
├── Ecommerce_Shipping_EDA.sql
└── Ecommerce_Shipping_Data.csv
```

---

# Data Cleaning Process

The raw dataset contained inconsistent column names and required preparation before analysis.

The following cleaning steps were performed:

## 1. Created a Staging Table

- Created a duplicate working table for safe analysis
- Preserved the original raw dataset

## 2. Renamed Corrupted Columns

- Fixed improperly formatted column names
- Improved readability and query consistency

Example:

```sql
ALTER TABLE ecommerce_staging
RENAME COLUMN ï»¿ID TO ID;

ALTER TABLE ecommerce_staging
RENAME COLUMN `Reached.on.Time_Y.N`
TO Reached_on_Time_Y_N;
```

## 3. Checked for Missing Values

- Inspected important columns for NULL values
- Verified shipment and warehouse-related fields

---

# Exploratory Data Analysis (EDA)

After cleaning the dataset, exploratory analysis was performed to identify patterns and operational insights.

## Analysis Performed

### Warehouse Analysis

- Shipment distribution by warehouse block
- Delay percentage by warehouse

### Shipment Mode Analysis

- Most commonly used shipment methods
- Delay percentage by shipment mode

### Customer Analysis

- Customer care calls vs ratings
- Customer ratings by delivery status
- Prior purchases vs delays

### Product Analysis

- Product importance distribution
- Product cost vs customer ratings
- Product weight vs shipment mode

### Delivery & Logistics Analysis

- Delayed vs on-time deliveries
- Discounts offered by delivery status
- Shipment mode combined with product importance

---

# Key Business Insights

- Warehouse F handled the highest shipment volume.
- Shipment mode differences had only a minor impact on delay percentages.
- Delayed deliveries received significantly higher discounts compared to on-time deliveries.
- Customer ratings remained relatively stable regardless of delivery outcome.
- Product weight showed minimal impact on shipment delays.
- Delivery delays appear to be influenced by broader operational inefficiencies rather than a single isolated factor.

---

# SQL Concepts Used

- Aggregate Functions
- CASE Statements
- GROUP BY
- ORDER BY
- AVG()
- COUNT()
- SUM()
- ROUND()
- Data Cleaning Techniques

---

# How to Run the Project

## 1. Create the Database

Create the database and import the dataset.

## 2. Import the Dataset

Import:

```text
ecommerce_shipping_data.csv
```

into your MySQL database.

## 3. Run the SQL Script

Execute:

```sql
ecommerce_shipping_analysis.sql
```

---

# Key Learnings

Through this project, I improved my understanding of:

- Real-world SQL data cleaning workflows
- Exploratory data analysis using SQL
- Business-focused analytical thinking
- Data grouping and aggregation techniques
- Identifying operational patterns from raw datasets

---

# Future Improvements

- Create a Power BI dashboard
- Add visualizations and KPI reporting
- Perform deeper statistical analysis
- Build advanced SQL queries using CTEs and Window Functions

---

# Author

Abdullah Saleem  
Software Engineering Student | Aspiring Data Analyst
