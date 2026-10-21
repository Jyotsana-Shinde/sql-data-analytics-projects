create database ecommerce;
use ecommerce;

CREATE TABLE Orders_Fact (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    region VARCHAR(50),
    segment VARCHAR(50),
    employee_id VARCHAR(20),
    employee_name VARCHAR(100),
    product_id VARCHAR(20),
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_pct DECIMAL(5,2),
    gross_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    net_amount DECIMAL(10,2),
    profit DECIMAL(10,2),
    payment_method VARCHAR(50),
    ship_mode VARCHAR(50),
    ship_date DATE,
    order_status VARCHAR(50)
);

drop table orders_fact;
select * from Orders_fact;

CREATE TABLE Customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    region VARCHAR(50),
    city VARCHAR(100),
    signup_date DATE,
    loyalty_tier VARCHAR(50)
);

drop table Customers;

CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    unit_cost DECIMAL(10,2),
    unit_price DECIMAL(10,2)
);

CREATE TABLE Employees (
    employee_id VARCHAR(20) PRIMARY KEY,
    employee_name VARCHAR(100),
    region VARCHAR(50),
    hire_date DATE
);
select * from customers;

CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    unit_cost DECIMAL(10,2),
    unit_price DECIMAL(10,2)
);


select * from products;

CREATE TABLE Employees (
    employee_id VARCHAR(20) PRIMARY KEY,
    employee_name VARCHAR(100),
    region VARCHAR(50),
    hire_date DATE
);
drop table Employees;
select * from Employees;

create database ecommerce;
use ecommerce;

select * from orders_fact;
select * from customers;
select * from products;
select * from employees;

SET SQL_SAFE_UPDATES = 0;
-- change data type of signup_date column from table cutomers 
ALTER TABLE Customers
MODIFY signup_date DATE;

UPDATE Customers
SET signup_date = STR_TO_DATE(signup_date, '%Y-%m-%d');

-- change data type of hire_date column from table Employees 
ALTER TABLE Employees
MODIFY hire_date DATE;

UPDATE Employees
SET hire_date = STR_TO_DATE(hire_date, '%Y-%m-%d');

-- change data type of order_date and ship_date column from table orders_fact
UPDATE orders_fact
SET ship_date = NULL
WHERE ship_date = '';

ALTER TABLE orders_fact
MODIFY order_date DATE,
MODIFY ship_date DATE;

UPDATE orders_fact
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d'),
    ship_date = STR_TO_DATE(ship_date, '%Y-%m-%d');


select year(order_date), year(ship_date)
from orders_fact;


-- Q1.Find all products whose unit_price is greater than the average unit_price of all products.
SELECT product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) from products);


-- Q2.Find the names and IDs of all customers who have purchased at least one product from the 
--    Electronics category.
SELECT customer_id, customer_name
FROM orders_fact
WHERE category = 'Electronics';

-- OR

SELECT customer_name, customer_id
FROM orders_fact
WHERE customer_name IN (SELECT customer_name 
						FROM orders_fact 
                        where category = 'Electronics');
                        
                        
-- Q3.Find the order(s) with the highest net_amount in the entire dataset.
SELECT *
FROM orders_fact
WHERE net_amount = (SELECT MAX(net_amount) FROM orders_fact);


-- Q4.Find all products that have never been ordered (no matching row in Orders_Fact).
SELECT product_name, Product_id
FROM products
WHERE product_name not in (SELECT product_name FROM orders_fact);


-- Q5.Find the employee(s) who have processed more than 50 orders.
SELECT Employee_Id, Employee_Name,
		COUNT(Order_Id) AS Total_Orders
FROM orders_fact
GROUP BY Employee_Id, Employee_Name
HAVING COUNT(Order_Id) > 50;


-- Q6.List every customer along with their lifetime spend (SUM(net_amount)), but only include customers whose 
--    lifetime spend is above the average lifetime spend across all customers. Order by lifetime spend descending.
SELECT Customer_Id, Customer_Name,
		SUM(Net_Amount) AS lifetime_spend
FROM Orders_fact
GROUP BY Customer_Id, Customer_Name
HAVING SUM(Net_Amount) > 
(
	SELECT AVG(lifetime_spend)
    FROM 
    (
		SELECT SUM(Net_Amount) AS lifetime_spend
        FROM Orders_fact
        GROUP BY Customer_Id
	)AS avg_spend
) ORDER BY lifetime_spend DESC;


-- Q7.For each product category, find the single most expensive product (using a correlated subquery, 
--    not ROW_NUMBER()), showing the category, product name, and price.
SELECT Category, Product_Name, Unit_price
FROM Products p1
WHERE Unit_Price = 
(
	SELECT MAX(Unit_Price) 
	FROM Products p2
	WHERE p1.Category = p2.Category
);


-- Q8.List every employee and their total profit generated, but exclude any employee who has ever processed
--    a Cancelled order. Order by total profit descending.
SELECT Employee_Id, Employee_Name, 
	SUM(Profit) AS Total_Profit
FROM Orders_Fact
WHERE Employee_Id NOT IN
	(SELECT Employee_Id
     FROM Orders_Fact
     WHERE Order_Status = 'Cancelled'
	)
GROUP BY Employee_Id, Employee_Name
ORDER BY Total_Profit DESC;


-- Q9.Find all customers who have purchased products from 3 or more distinct categories 
--    (use EXISTS with a correlated subquery containing GROUP BY/HAVING).
SELECT DISTINCT Customer_Id, Customer_Name
FROM Orders_Fact o1
WHERE EXISTS
	(SELECT 1
    FROM orders_fact o2
    WHERE o1.Customer_Id = o2.Customer_Id
    GROUP BY o2.Customer_Id
    HAVING COUNT(DISTINCT o2.Category) >= 3
    );
    

-- Q10.For each region, calculate the return rate (returned orders ÷ total orders). Return only regions where
--     the return rate exceeds 10%, along with the returned order count and total order count.
SELECT region,
		SUM(CASE WHEN Order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
        COUNT(*) AS Total_orders,
        SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) / COUNT(*) AS return_rate
FROM Orders_Fact
GROUP BY region
HAVING SUM(CASE WHEN Order_Status = 'Returned' THEN 1 ELSE 0 END) / COUNT(*) > 0.10;


-- Q11.For every customer, find their single highest-value order (order_id, order_date, net_amount) using a subquery
--     in the FROM clause with a window function, then return the top 20 customers by that order value.
SELECT Customer_Id, Customer_Name, Order_Id, Order_Date, Net_Amount
FROM ( 
		SELECT Customer_Id, Customer_Name, Order_Id, Order_Date, Net_Amount,
		ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY Net_Amount DESC) AS rn
        FROM Orders_Fact
	) AS t
WHERE rn = 1
ORDER BY net_amount DESC
LIMIT 20;


-- Q12.Find products that are priced at less than 50% of the average price of their own sub-category (a correlated 
--     subquery comparing each product to its peer group) — these are "deep discount / loss-leader" candidates.
SELECT Product_Id, Product_Name, Sub_Category, Unit_Price
FROM Products p1
WHERE Unit_Price < 
	(SELECT AVG(Unit_Price) * 0.5
    FROM Products p2
	WHERE p1.Sub_Category = p2.Sub_Category
    );
    
    
-- Q13.Calculate total revenue per category, and return only the categories whose revenue is above the average 
--     category revenue (subquery inside HAVING, built from a derived table).
SELECT category, SUM(Net_Amount) AS Total_Revenue
FROM Orders_Fact
GROUP BY category
HAVING SUM(Net_Amount) >
(SELECT AVG(category_revenue)
 FROM( SELECT SUM(Net_Amount) AS category_revenue
		FROM Orders_Fact
        GROUP BY category
	) AS t
);


-- Q14.Using ALL, find every product that is more expensive than every single product in the Books category 
--     (i.e., unit_price > ALL (...)).
SELECT Product_Id, Product_Name, Category, Unit_Price
FROM Products
WHERE Unit_Price > ALL
	(SELECT Unit_Price
     FROM Products
     WHERE category = 'Books'
	);


-- Q15.For each order, compare its net_amount to that specific customer's own average order value (correlated 
--     subquery), and return only the orders that are above that customer's personal average — i.e., 
--     each customer's "above-average" purchases.
SELECT order_id, customer_id, customer_name, order_date, net_amount
FROM orders_fact o1
WHERE net_amount >
(
    SELECT AVG(net_amount)
    FROM orders_fact o2
    WHERE o2.customer_id = o1.customer_id
);


-- Q16.Find customers who made at least one purchase, but have made no purchases since the start of 2024
--     (i.e., they have history, but have gone inactive) — use a combination of EXISTS and NOT EXISTS.
SELECT DISTINCT o1.customer_id, o1.customer_name
FROM orders_fact o1
WHERE EXISTS
(
    SELECT 1
    FROM orders_fact o2
    WHERE o2.customer_id = o1.customer_id
)
AND NOT EXISTS
(
    SELECT 1
    FROM orders_fact o3
    WHERE o3.customer_id = o1.customer_id
      AND o3.order_date >= '2024-01-01'
);

 
 -- Q17.Using ANY, find all non-Electronics products whose price is greater than at least one Electronics 
 --     product's price (i.e., unit_price > ANY (...)).
SELECT product_id, product_name, category, unit_price
FROM products
WHERE category <> 'Electronics'
  AND unit_price > ANY
(
    SELECT unit_price
    FROM products
    WHERE category = 'Electronics'
);


-- Q18.Find the region(s) whose average order value is at or above the company-wide average order value 
--     (subquery in HAVING).
SELECT Region, AVG(Net_Amount) AS avg_order_value
FROM Orders_Fact
GROUP BY Region
HAVING AVG(Net_Amount) >= 
				(SELECT AVG(Net_Amount)
				 FROM Orders_Fact
				);
                

-- Q19.Find "VIP" customers: customers with 3 or more orders AND whose total spend is above the average total 
--     spend of all customers who have ordered at least once. Show customer name, order count, and total spend.
SELECT customer_name,
       COUNT(order_id) AS order_count,
       SUM(net_amount) AS total_spend
FROM orders_fact
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) >= 3
   AND SUM(net_amount) >
(
    SELECT AVG(total_spend)
    FROM
    (
        SELECT customer_id,
               SUM(net_amount) AS total_spend
        FROM orders_fact
        GROUP BY customer_id
    ) AS t
)
ORDER BY total_spend DESC;

-- Q20.Find the single employee (or employees, in case of a tie) with the highest total profit generated, 
--     using a subquery on a derived per-employee profit table (do not use LIMIT/ORDER BY to determine 
--     the winner — use = against a MAX() subquery so ties are handled correctly).
SELECT employee_id,
       employee_name,
       total_profit
FROM
(
    SELECT employee_id,
           employee_name,
           SUM(profit) AS total_profit
    FROM orders_fact
    GROUP BY employee_id, employee_name
) AS emp_profit
WHERE total_profit =
(
    SELECT MAX(total_profit)
    FROM
    (
        SELECT SUM(profit) AS total_profit
        FROM orders_fact
        GROUP BY employee_id
    ) AS max_profit
);


-- Q21.Within the Electronics category, find every sub-category whose total units sold is above the average 
--     units sold per sub-category within Electronics (nested aggregate subquery).
SELECT sub_category,
       SUM(quantity) AS total_units_sold
FROM orders_fact
WHERE category = 'Electronics'
GROUP BY sub_category
HAVING SUM(quantity) >
(
    SELECT AVG(total_units)
    FROM
    (
        SELECT SUM(quantity) AS total_units
        FROM orders_fact
        WHERE category = 'Electronics'
        GROUP BY sub_category
    ) AS t
);


-- Q22.Find all "Platinum" tier customers who have placed at least one order but have never had a single order 
--  returned (combine EXISTS and NOT EXISTS on the same correlated customer).
SELECT DISTINCT c.customer_id,
       c.customer_name
FROM customers c
JOIN orders_fact o1
ON c.customer_id = o1.customer_id
WHERE c.loyalty_tier = 'Platinum'
AND EXISTS
(
    SELECT 1
    FROM orders_fact o2
    WHERE o2.customer_id = c.customer_id
)
AND NOT EXISTS
(
    SELECT 1
    FROM orders_fact o3
    WHERE o3.customer_id = c.customer_id
      AND o3.order_status = 'Returned'
);


-- Q23.For every order, calculate how many prior orders that same customer placed before it (correlated subquery 
-- counting earlier rows), then return only each customer's very first order (i.e., where the prior-order count = 0).
SELECT o1.customer_id, o1.customer_name, o1.order_id, o1.order_date
FROM orders_fact o1
WHERE
(
    SELECT COUNT(*)
    FROM orders_fact o2
    WHERE o2.customer_id = o1.customer_id
      AND o2.order_date < o1.order_date
) = 0;


-- Q24.Find every product whose price is higher than the highest of all per-category average prices (i.e., more 
--     expensive than even the priciest category's average) — a nested aggregate-of-aggregates subquery.
SELECT product_id, product_name, category, unit_price
FROM products
WHERE unit_price >
(
    SELECT MAX(avg_price)
    FROM
    (
        SELECT AVG(unit_price) AS avg_price
        FROM products
        GROUP BY category
    ) AS t
);


-- Q25.Find the best month and worst month of total revenue (by net_amount) across the whole dataset, using 
--     a derived monthly-revenue table and MAX()/MIN() scalar subqueries.
SELECT month_name,
       total_revenue,
       'Best Month' AS revenue_rank
FROM
(
    SELECT MONTHNAME(order_date) AS month_name,
           SUM(net_amount) AS total_revenue
    FROM orders_fact
    GROUP BY MONTH(order_date), MONTHNAME(order_date)
) AS m
WHERE total_revenue =
(
    SELECT MAX(total_revenue)
    FROM
    (
        SELECT SUM(net_amount) AS total_revenue
        FROM orders_fact
        GROUP BY MONTH(order_date)
    ) AS x
)

UNION ALL

SELECT month_name,
       total_revenue,
       'Worst Month' AS revenue_rank
FROM
(
    SELECT MONTHNAME(order_date) AS month_name,
           SUM(net_amount) AS total_revenue
    FROM orders_fact
    GROUP BY MONTH(order_date), MONTHNAME(order_date)
) AS m
WHERE total_revenue =
(
    SELECT MIN(total_revenue)
    FROM
    (
        SELECT SUM(net_amount) AS total_revenue
        FROM orders_fact
        GROUP BY MONTH(order_date)
    ) AS y
);



