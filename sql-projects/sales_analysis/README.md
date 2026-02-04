Nedum Food Orders Analysis SQL Project
Project Overview

This SQL project analyzes a food delivery dataset (nedum_data) to provide insights into orders, customer behavior, restaurant performance, and revenue trends. The goal is to clean, transform, and structure the data into a star schema (dimensions and fact table) to enable meaningful business intelligence analysis and KPI reporting.

The dataset contains information such as:

Location: State, City, and Location of the restaurant

Restaurant details: Restaurant Name and Category

Dish details: Dish Name, Price, Ratings, and Rating Count

Order details: Order Date

Problem Being Solved

The business wants to:

Ensure data quality by identifying and handling missing, blank, or duplicate records.

Create a structured schema suitable for analytics, including dimension tables (dim_date, dim_location, dim_restaurant, dim_category, dim_dish) and a fact table (fact_nedum_orders).

Calculate key metrics such as total orders, revenue, average price, average rating, and performance trends across time, location, restaurants, categories, and dishes.

Support business decisions such as marketing, menu optimization, and operational planning.

This approach converts raw operational data into an analytics-ready format for easy reporting and visualization.
