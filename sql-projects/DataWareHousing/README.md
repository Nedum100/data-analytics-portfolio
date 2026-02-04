📊 Sales Performance & Customer Analytics (SQL Project)
📌 Project Overview

This project focuses on analyzing sales performance, product contribution, and customer behavior using SQL.

The goal is to transform raw transactional data into meaningful business insights that help answer questions such as:

How are sales changing over time?

Which products and categories drive the most revenue?

How does current performance compare to historical trends?

How can customers and products be segmented for better decision-making?

The analysis is built on a star-schema style data warehouse with fact and dimension tables.

🎯 Business Problems Addressed

Track sales trends over time (monthly and yearly)

Measure cumulative growth to understand business performance

Compare product performance against averages and previous years

Identify top contributing product categories

Segment products based on cost ranges

Segment customers based on spending behavior and loyalty

Build an aggregated product and customer performance report for KPIs

🗂️ Dataset Structure

The analysis uses the following tables:

Fact Table

gold.fact_sales

order_number

order_date

sales_amount

quantity

product_key

customer_key

Dimension Tables

gold.dim_products

product_key

product_name

category

cost

gold.dim_customers

customer_key

customer_number

first_name

last_name

birthdate

📈 Key SQL Analysis Strategies Used
1. Sales Trend Analysis (Change Over Time)

Aggregated monthly and yearly sales

Tracked:

Total sales

Number of customers

Quantity sold

Purpose:
To identify growth patterns, seasonality, and performance shifts over time.

2. Cumulative & Moving Average Analysis

Running total of sales using window functions

Moving average of product prices

Purpose:
To understand long-term growth trends and smooth out short-term fluctuations.

3. Performance Comparison (Year-over-Year)

Compared:

Current sales vs average sales per product

Current year vs previous year using LAG()

Purpose:
To determine:

Products performing above or below average

Growth or decline year-over-year

4. Part-to-Whole Analysis (Category Contribution)

Calculated each category’s contribution to total sales

Displayed percentage share of overall revenue

Purpose:
To identify the most impactful product categories.

5. Product Segmentation by Cost

Products were grouped into:

Below 100

100–500

500–1000

Above 1000

Purpose:
To understand distribution of products across pricing ranges.

6. Customer Segmentation by Behavior

Customers were classified as:

VIP – At least 12 months activity and high spending

Regular – At least 12 months but lower spending

New – Less than 12 months lifespan

Purpose:
To analyze loyalty and customer value.

7. Customer Performance Report (KPI View)

A consolidated report was built using CTEs that calculates:

Total orders

Total sales

Total quantity

Total products purchased

Customer lifespan

Recency (months since last purchase)

Average order value

Average monthly spending

Purpose:
To create a business-ready customer analytics table.

🛠️ SQL Techniques Applied

Common Table Expressions (CTEs)

Window Functions (SUM() OVER, AVG() OVER, LAG())

Date functions (YEAR, MONTH, DATETRUNC, DATEDIFF)

Aggregations (SUM, COUNT, AVG)

Conditional logic (CASE WHEN)

Joins between fact and dimension tables

📊 Key Insights Generated

✔ Sales growth patterns over time
✔ High and low performing products
✔ Revenue contribution by category
✔ Customer loyalty segmentation
✔ Cost-based product distribution
✔ Business KPIs for decision making
