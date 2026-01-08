SELECT * FROM nedum_data

--Data Validation and Cleaning
--Null check

SELECT
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS null_state,
	SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
	SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
	SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) AS null_resturant,
	SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location,
	SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
	SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS null_dish,
	SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS null_price,
	SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
	SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM nedum_data;

--Blank or empty strings
SELECT *
FROM nedum_data
WHERE
State ='' OR City='' OR Restaurant_Name = '' OR Location ='' OR Category=''
OR Dish_Name='' 

--Duplicate Detection
SELECT 
State, City, Order_Date, Restaurant_Name, Location, Category,Dish_Name,
Price_INR, Rating, Rating_Count, COUNT(*) as CNT
from nedum_data
GROUP BY 
State, City, Order_Date, Restaurant_Name, Location, Category,Dish_Name,
Price_INR, Rating, Rating_Count
Having COUNT(*) > 1

--Delete Duplication
WITH CTE AS (
SELECT * , ROW_NUMBER() Over(
     PARTITION BY State, City, Order_Date, Restaurant_Name, Location, Category,Dish_Name,
Price_INR, Rating, Rating_Count
ORDER BY (SELECT NULL)
) AS rn
FROM nedum_data
)
DELETE FROM CTE WHERE rn>1


--CREATING SHEMA
--DIMENSIONS TABLES
--DATE TABLE
CREATE TABLE dim_date (
	date_id INT IDENTITY(1,1) PRIMARY KEY,
	FULL_DATE DATE,
	YEAR INT,
	MONTH INT,
	month_name varchar(20),
	quarter INT,
	Day INT,
	week INT
	);

--dim_location
CREATE TABLE dim_location (
	location_id INT IDENTITY(1,1) PRIMARY KEY,
	state varchar(100),
	city varchar(100),
	location varchar(200)
);

--dim_resturant
CREATE TABLE dim_resturant (
	resturant_id INT IDENTITY(1,1) PRIMARY KEY,
	Resturant_Name varchar(200)
);

--dim_category
CREATE TABLE dim_category (
	category_id INT IDENTITY(1,1) PRIMARY KEY,
	Category varchar(200)
);

--dim_dish
CREATE TABLE dim_dish (
	dish_id INT IDENTITY(1,1) PRIMARY KEY,
	Dish_Name varchar(200)
)

--FACT TABLE
CREATE TABLE fact_nedum_orders (
  order_id INT IDENTITY(1, 1) PRIMARY KEY,

  date_id INT,
  Price_INR DECIMAL(10, 2),
  Rating DECIMAL(4, 2),
  Rating_Count INT,

  location_id INT,
  resturant_id INT,
  category_id INT,
  dish_id INT,

  FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
  FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
  FOREIGN KEY (resturant_id) REFERENCES dim_resturant(resturant_id),
  FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
  FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id),
)

SELECT * FROM fact_nedum_orders

--INSERT DATA IN TABLES
--dim_date
INSERT INTO dim_date(FULL_DATE, year, MONTH, month_name, quarter,Day,week)
SELECT DISTINCT
	order_Date,
	YEAR(order_Date),
	MONTH(order_Date),
	DATENAME(MONTH, Order_Date),
	DATEPART(QUARTER, Order_Date),
	DAY(order_Date),
	DATEPART(WEEK, Order_Date)
FROM nedum_data
WHERE Order_Date IS NOT NULL

SELECT * FROM dim_location

--dim location
INSERT INTO dim_location(state, city, location)
SELECT DISTINCT
	state,
	city,
	location
FROM nedum_data

--dim_resturant
INSERT INTO dim_resturant(Resturant_Name)
SELECT DISTINCT
	Restaurant_Name
FROM nedum_data

--dim_category
INSERT INTO dim_category(Category)
SELECT DISTINCT
	Category
FROM nedum_data

--dim_dish
INSERT INTO dim_dish(Dish_Name)
SELECT DISTINCT
	Dish_Name
FROM nedum_data

--Fact_table
INSERT INTO fact_nedum_orders
(
	date_id,
	price_INR,
	Rating,
	Rating_Count,
	location_id,
	resturant_id,
	category_id,
	dish_id
)
SELECT 
    dd.date_id,
    s.Price_INR,
    s.Rating,
    s.Rating_Count,

    dl.location_id,
    dr.resturant_id,
    dc.category_id,
    dsh.dish_id
FROM nedum_data s

-- Date dimension
JOIN dim_date dd
    ON dd.FULL_DATE = s.Order_Date

-- Location dimension
JOIN dim_location dl
    ON dl.State = s.State
   AND dl.City = s.City
   AND dl.Location = s.Location

-- Restaurant dimension
JOIN dim_resturant dr
    ON dr.Resturant_Name = s.Restaurant_Name

-- Category dimension
JOIN dim_category dc
    ON dc.category = s.Category

-- Dish dimension
JOIN dim_dish dsh
    ON dsh.dish_name = s.Dish_Name;

SELECT * FROM fact_nedum_orders

SELECT * FROM fact_nedum_orders f
join dim_date d ON f.date_id = d.date_id
join dim_location l ON f.location_id = l.location_id
join dim_resturant r ON f.resturant_id = r.resturant_id
join dim_category c ON f.category_id = c.category_id
join dim_dish di ON f.dish_id = di.dish_id


--KPI'S
--Total Orders

SELECT COUNT(*) AS Total_Orders
FROM fact_nedum_orders

--Total Revenue (INR Million)
SELECT 
FORMAT (SUM(CONVERT(FLOAT,Price_INR))/1000000, 'N2') + ' INR Million'
AS Total_Revenue 
FROM fact_nedum_orders

--Average Dish Price
SELECT 
FORMAT (AVG(CONVERT(FLOAT,Price_INR)), 'N2') + ' INR'
AS Total_Revenue 
FROM fact_nedum_orders

--Average Rating
SELECT 
Avg (Rating) AS Avg_Rating
FROM fact_nedum_orders

--DEEP DIVE BUSINESS ANALYSIS

--Monthly Order Trends
SELECT 
d.Year,
d.MONTH,
d.Month_Name,
count(*) AS Total_Orders
FROM fact_nedum_orders f 
join dim_date d ON f.date_id = d.date_id
GROUP BY d.year,
d.MONTH,
d.Month_Name
ORDER BY count(*)


SELECT 
d.Year,
d.MONTH,
d.Month_Name,
FORMAT (SUM(CONVERT(FLOAT,Price_INR))/1000000, 'N2') + ' INR Million'
AS Total_Orders
FROM fact_nedum_orders f 
join dim_date d ON f.date_id = d.date_id
GROUP BY d.year,
d.MONTH,
d.Month_Name
ORDER BY SUM(Price_INR) DESC

--Quarterly Trend
SELECT 
d.Year,
d.quarter,
count(*)As Quarterly_Orders
FROM fact_nedum_orders f 
join dim_date d ON f.date_id = d.date_id
GROUP BY d.year,
d.quarter
ORDER BY count(*) DESC

--yearly Trend
SELECT 
d.Year,
count(*)As yearly_Trends
FROM fact_nedum_orders f 
join dim_date d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY count(*) DESC

--weekly orders
SELECT
	DATENAME(WEEKDAY, d.full_date) AS day_name,
	COUNT(*) AS total_orders
FROM fact_nedum_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY DATENAME(WEEKDAY, d.full_date), 
DATEPART(WEEKDAY, d.full_date)
ORDER BY DATEPART(WEEKDAY, d.full_date)

--Top 10 cities by order volume
SELECT TOP 10
l.city,
SUM(f.Price_INR) AS Total_Revenue from fact_nedum_orders f
JOIN dim_location l
ON l.location_id = f.location_id
GROUP BY l.city
ORDER BY SUM(f.Price_INR) DESC

--Revenue contribution by state
SELECT 
l.state,
SUM(f.Price_INR) AS Total_Revenue from fact_nedum_orders f
JOIN dim_location l
ON l.location_id = f.location_id
GROUP BY l.state
ORDER BY SUM(f.Price_INR) DESC

--Top 10 Restaurant
SELECT TOP 10
r.Resturant_Name,
SUM(f.Price_INR) AS Total_Revenue from fact_nedum_orders f
JOIN dim_resturant r
ON r.resturant_id = f.resturant_id
GROUP BY r.Resturant_Name
ORDER BY SUM(f.Price_INR) DESC

--Top Categories by Order Volume
SELECT
	c.category,
	COUNT(*) AS total_orders
FROM fact_nedum_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.Category
ORDER BY total_orders DESC

--Most Ordered Dishes
SELECT Top 10
	d.dish_name,
	COUNT(*) AS order_count
FROM fact_nedum_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.dish_name
ORDER BY order_count DESC

--Total Orders By Price Range
SELECT
	CASE
	   WHEN CONVERT(FLOAT, Price_INR) < 100 THEN 'under 100'
	   WHEN CONVERT(FLOAT, Price_INR) BETWEEN 100 AND 199 THEN '100 - 199'
	   WHEN CONVERT(FLOAT, Price_INR) BETWEEN 200 AND 299 THEN '200 - 299'
	   WHEN CONVERT(FLOAT, Price_INR) BETWEEN 300 AND 499 THEN '300 - 499'
	   ELSE '500+'
	END AS price_range,
	COUNT(*) AS total_orders
FROM fact_nedum_orders
GROUP BY
	CASE
	   WHEN CONVERT(FLOAT, Price_INR) < 100 THEN 'under 100'
	   WHEN CONVERT(FLOAT, Price_INR) BETWEEN 100 AND 199 THEN '100 - 199'
	   WHEN CONVERT(FLOAT, Price_INR) BETWEEN 200 AND 299 THEN '200 - 299'
	   WHEN CONVERT(FLOAT, Price_INR) BETWEEN 300 AND 499 THEN '300 - 499'
	   ELSE '500+'
     END
ORDER BY total_orders DESC;

--Rating Count Distirbution (1-5)
SELECT 
	rating,
	COUNT(*) AS rating_count
FROM fact_nedum_orders
GROUP BY rating
ORDER BY COUNT(*) DESC
