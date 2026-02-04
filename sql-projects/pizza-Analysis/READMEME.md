Pizza Sales Analysis SQL Project
Project Overview

This SQL project analyzes pizza sales data from an online pizza ordering system. The primary goal is to generate Key Performance Indicators (KPIs) and answer business questions that provide insights into sales performance, customer behavior, and product popularity. This analysis can help the management team make data-driven decisions, optimize sales strategies, and understand trends in pizza orders.

The dataset includes the following main tables:

order_details: Contains details about each pizza in an order, including quantity and price.

pizzas: Stores information about pizzas, such as pizza_id, pizza_type_id, name, size, and price.

pizza_types: Stores categories of pizzas, such as "Vegetarian", "Meat", "Cheese", etc.

order: Stores metadata about orders, including order date and time.

Problem Being Solved

The business wants to answer key questions to improve operations and sales, such as:

How much revenue is being generated?

What is the average order value and the average number of pizzas per order?

Which pizza categories and sizes are performing best?

When (day of week, hour of day) do most orders occur?

Which pizzas are top sellers or underperforming?

By analyzing these metrics, the business can optimize menu offerings, staffing, promotions, and inventory management.

Analysis Strategy

The strategy used involves aggregating and joining the relevant tables to calculate KPIs and trends:

KPIs: Using SUM, COUNT, and ROUND functions to calculate:

Total Revenue

Average Order Value

Total Pizzas Sold

Total Orders

Average Pizzas Per Order

Trends Analysis: Grouping orders by day of the week and hour of the day to identify peak sales periods using FORMAT and DATEPART functions.

Product Analysis: Joining pizzas with pizza_types and order_details to calculate:

Percentage of sales by pizza category and size

Total pizzas sold by category

Top and bottom sellers

Joins: The queries frequently join order_details with pizzas and pizza_types to enrich sales data with product details.

This strategy ensures all metrics are accurate, actionable, and easy to interpret for business decisions.
