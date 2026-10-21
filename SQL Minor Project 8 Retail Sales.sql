create database retail_sales;
use retail_sales;

select * from retail_sales;

-- Q.1 Retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Retrieve all transactions where category is 'Clothing'
--     and quantity sold is more than 10, in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 10
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- Q.3 Calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;


-- Q.4 Find the average age of customers who purchased items
--     from the 'Beauty' category
SELECT AVG(age) AS average_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Find the total number of transactions made by each gender
--     in each category
SELECT category, gender, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender;