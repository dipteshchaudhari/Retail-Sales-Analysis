-- SQL RETAILS SALES ANALYSIS

-- CREATE DATABASE SQL_PROJECT2;

-- 1) CREATE TABLE

-- DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales 
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- DATA CLEANING 

SELECT * FROM retail_sales
LIMIT 10

SELECT 
	COUNT(*) 
FROM retail_sales

SELECT COUNT(DISTINCT customer_id) FROM retail_sales  


-- FATCHED THE ROWS WHO HAS NULL VALUES IN ANY COLUMN 

SELECT * FROM retail_sales 
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NUlL
	OR 
	total_sale IS NULL


-- DELETING ROWS WHO HAVE NULL VALUES IN ANY COLUMN 

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NUlL
	OR 
	total_sale IS NULL

-- NOW AFTER REMOVING 13 ROWS , 1987 ROWS LEFT 

SELECT COUNT(transactions_id) FROM retail_sales


-- DATA EXPLORATION

-- how many sales we have made
SELECT COUNT(*) as total_sales FROM retail_sales

--how many UNIQUE customers we have
SELECT COUNT(DISTINCT customer_id) as CUSTO FROM retail_sales

--how many UNIQUE category we have and which are those
SELECT COUNT(DISTINCT category) as TOTAL_CATEGORY FROM retail_sales
SELECT DISTINCT category as cat from retail_Sales


-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS & ANSWERS 


-- 1) Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales 
	WHERE 
		sale_date = '2022-11-05'

-- 2) Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--    and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales 
	WHERE
		category = 'Clothing'
		AND
		quantiy >= 4 
		AND 
		TO_CHAR(sale_date,'YYYY-MM') = '2022-11'

-- 3) Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
 	category ,
	 SUM(total_sale) as total_sales,
	 COUNT(*) as total_orders
	  FROM retail_sales
GROUP BY 1 

-- 4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select * from retail_sales

SELECT 
	category,
	avg(age) as average_Age
	FROM retail_sales
	GROUP BY 1


SELECT ROUND(AVG(age),2) as AVG_AGE
	FROM retail_sales
	WHERE
		category = 'Beauty'

-- 5) Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
	WHERE
		total_sale > 1000

-- 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
	category,	
	gender,
	count(*) as total_transactions
		FROM retail_sales
	GROUP BY 
		category,
		gender
	ORDER BY 1

-- 7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT * FROM retail_sales

SELECT 
	EXTRACT(YEAR FROM sale_date) as year,   -- for MySQL --> YEAR(sale_date)
	EXTRACT(MONTH FROM sale_date) as month,	
	AVG(total_sale) as AVG_sale
	FROM retail_sales
	GROUP BY 
		1,2
	ORDER BY 1, 3 DESC

-- for best selling months


SELECT 
	year,
	month,
	AVG_sale
FROM 
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,  
	EXTRACT(MONTH FROM sale_date) as month,	
	AVG(total_sale) as AVG_sale,

	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	
	FROM retail_sales
	GROUP BY 
		1,2
) as t1
WHERE rank = 1

-- 8) Write a SQL query to find the top 5 customers based on the highest total sales :

SELECT 
	customer_id,
	SUM(total_sale) as TOTAL_SALES
	FROM retail_sales
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

-- 9) Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
	category,
	count(DISTINCT customer_id) as UNQ_CUSOTO
	FROM retail_sales
	GROUP BY category


-- 10) Write a SQL query to create each shift and number of orders 
--     (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

-- WE USE [CTE] here -> Common Table Expression

WITH hourly_Sales
AS(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning' 
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
FROM retail_sales
)
SELECT
	Shift,
	count(*) as total_orders
FROM hourly_sales
GROUP BY 1

