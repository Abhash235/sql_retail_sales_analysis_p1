	
	--sql retail sales analysis
	CREATE DATABASE sql_project_p1;

	CREATE TABLE retail_sales(
	id int,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(5),
	age int,
	catagory varchar(10),
	quantity int,
	price_per_unit int,
	cogs int,
	total_sale float);
--

SELECT COUNT(*) FROM retail_sales_analysis;

--DATA CLEANING--

SELECT * FROM retail_sales_analysis 
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
	cogs IS NULL
	OR
	total_sale IS NULL;


--
DELETE FROM retail_sales_analysis
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
	cogs IS NULL
	OR
	total_sale IS NULL;

--DATA EXPLORATION
--how many sales we have?

SELECT COUNT(*) FROM retail_sales_analysis as total_sales;

--how many unique catagory are there

SELECT  DISTINCT customer_id FROM retail_sales_analysis ;
SELECT  DISTINCT category FROM retail_sales_analysis ;

--data analysis and buisness key problems and answers
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

--7.write a sql query to calculate the average sale foreach month.find out best selling month in every year.
--8.write a sql query to find the top 5 customer of heighest total sales.
--9.write a sql query to find customer who purchased item from each catagory.
--10.write a sql query to create each shift and number of orders(example morning <12 afternoon 12-17 and night <17)



--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM  retail_sales_analysis 
WHERE sale_date='2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales_analysis
WHERE
    category = 'clothing'
    AND quantiy >= 4
    AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category,SUM(total_sale) AS TOTAL_SALE,
COUNT(*) AS TOTAL_ORDERS
FROM retail_sales_analysis 
GROUP BY category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT  AVG(age) AS average_age
FROM retail_sales_analysis
WHERE category='Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * 
FROM retail_sales_analysis
WHERE total_sale > '1000';

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT COUNT(*)AS total_tranjection ,gender,category
FROM retail_sales_analysis
GROUP BY gender,category;

--7.write a sql query to calculate the average sale foreach month.find out best selling month in every year.

SELECT year,month,avg_sale FROM
	(
		SELECT 
		DATEPART(YEAR,sale_date) AS year,
		DATEPART(MONTH,sale_date)AS month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY DATEPART(YEAR,sale_date) order by AVG(total_sale)  desc) AS rank
		FROM retail_sales_analysis
		GROUP BY DATEPART(YEAR,sale_date),DATEPART(MONTH,sale_date)
		) AS T1
WHERE rank=1; 




--8.write a sql query to find the top 5 customer of heighest total sales.
SELECT TOP 5 customer_id,
SUM(total_sale) as totalsale
FROM  retail_sales_analysis
group by customer_id
ORDER BY totalsale DESC;

--9.write a sql query to find customer who purchased item from each catagory.

SELECT 
category,count(distinct customer_id) as no_of_user
FROM retail_sales_analysis
GROUP BY category;

--10.write a sql query to create each shift and number of orders(example morning <12 afternoon 12-17 and night <17)

WITH hourly_sale as
(
SELECT * ,
	CASE
	   WHEN DATEPART(HOUR,sale_time)< 12 THEN 'morning'
	   WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	   ELSE 'evening'
	END as shift
FROM retail_sales_analysis
)
SELECT shift,
      COUNT(*)
	  FROM hourly_sale
	  GROUP BY shift;


--END OF PROJECT