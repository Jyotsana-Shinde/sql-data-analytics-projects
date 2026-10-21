CREATE DATABASE mixed_clauses;
USE mixed_clauses;

CREATE TABLE Sales_data(
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Region VARCHAR(50),
    Country VARCHAR(50),
    Customer VARCHAR(50),
    Product VARCHAR(50),
    Category VARCHAR(50),
    SalesPerson VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Revenue DECIMAL(10,2)
);


select * from Sales_data;

-- Find top 5 products by total revenue in the last 1 year where average discount is less than 10%.

SELECT Product,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
WHERE YEAR(OrderDate) = 2024
GROUP BY Product
HAVING AVG(Discount) < 10
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Q2. List salespersons whose total sales quantity is above company average.

SELECT SalesPerson,
       SUM(Quantity) AS Total_Quantity
FROM sales0h _data
GROUP BY SalesPerson
HAVING SUM(Quantity) >
(
    SELECT AVG(Quantity)
    FROM sales_data
);

-- Q3. Find regions where total revenue is greater than overall average revenue.

SELECT Region,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Region
HAVING SUM(Revenue) >
(
    SELECT AVG(Revenue)
    FROM sales_data
);

-- Q4. Get top 3 customers by total spending for Electronics category only.

SELECT Customer,
       SUM(Revenue) AS Total_Spending
FROM sales_data
WHERE Category = 'Electronics'
GROUP BY Customer
ORDER BY Total_Spending DESC
LIMIT 3;

-- Q5. Find countries where number of orders is more than 10 and average unit price > 5000.

SELECT Country,
       COUNT(*) AS Total_Orders,
       AVG(UnitPrice) AS Avg_UnitPrice
FROM sales_data
GROUP BY Country
HAVING COUNT(*) > 10
   AND AVG(UnitPrice) > 5000;
   
   -- Q6. Find products sold in more than 2 regions with total quantity > 50.

SELECT Product,
       COUNT(DISTINCT Region) AS Total_Regions,
       SUM(Quantity) AS Total_Quantity
FROM sales_data
GROUP BY Product
HAVING COUNT(DISTINCT Region) > 2
   AND SUM(Quantity) > 50;
   
   -- Q7. List bottom 3 products by total revenue excluding Furniture category.

SELECT Product,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
WHERE Category <> 'Furniture'
GROUP BY Product
ORDER BY Total_Revenue ASC
LIMIT 3;

-- Q8. Find month-wise total revenue for 2024 where revenue > 100000.

SELECT MONTH(OrderDate) AS Month,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
WHERE YEAR(OrderDate) = 2024
GROUP BY MONTH(OrderDate)
HAVING SUM(Revenue) > 100000
ORDER BY Month;

-- Q9. Find salespersons who sold both Electronics and Furniture.

SELECT SalesPerson
FROM sales_data
WHERE Category IN ('Electronics', 'Furniture')
GROUP BY SalesPerson
HAVING COUNT(DISTINCT Category) = 2;

-- Q10. Find region-wise revenue contribution percentage.

SELECT Region,
       SUM(Revenue) AS Total_Revenue,
       ROUND((SUM(Revenue) * 100) / (SELECT SUM(Revenue) FROM sales_data), 2) AS Revenue_Percentage
FROM sales_data
GROUP BY Region;

-- Q11. Get top 5 orders with highest revenue after discount.

SELECT OrderDate,
       Customer,
       Product,
       Revenue
FROM sales_data
ORDER BY Revenue DESC
LIMIT 5;

-- Q12. Find customers with at least 3 orders and total revenue > 50000.

SELECT Customer,
       COUNT(*) AS Total_Orders,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Customer
HAVING COUNT(*) >= 3
   AND SUM(Revenue) > 500;
   
   -- Q13. Find categories where max unit price > average unit price.

SELECT Category,
       MAX(UnitPrice) AS Max_UnitPrice,
       AVG(UnitPrice) AS Avg_UnitPrice
FROM sales_data
GROUP BY Category
HAVING MAX(UnitPrice) > AVG(UnitPrice);

-- Q14. List salespersons whose revenue is greater than their region’s average.

SELECT SalesPerson,
       Region,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY SalesPerson, Region
HAVING SUM(Revenue) > AVG(Revenue);

-- Q15. Find countries where total discount amount exceeds 20000.

SELECT Country,
       SUM((UnitPrice * Quantity * Discount) / 100) AS Total_Discount
FROM sales_data
GROUP BY Country
HAVING SUM((UnitPrice * Quantity * Discount) / 100) > 20000;

-- Q16. Find products with increasing sales trend month over month.

SELECT Product,
       MONTH(OrderDate) AS Month,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Product, MONTH(OrderDate)
ORDER BY Product, Month;

-- Q17. Find region and category combinations with revenue > 150000.

SELECT Region,
       Category,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Region, Category
HAVING SUM(Revenue) > 150000;

-- Q18. Get top 3 months by total revenue.

SELECT MONTH(OrderDate) AS Month,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY MONTH(OrderDate)
ORDER BY Total_Revenue DESC
LIMIT 3;

-- Q19. Find customers who purchased more than 5 different products.

SELECT Customer,
       COUNT(DISTINCT Product) AS Total_Products
FROM sales_data
GROUP BY Customer
HAVING COUNT(DISTINCT Product) > 5;

-- Q20. Find products where max quantity sold in a single order > 8.

SELECT Product,
       MAX(Quantity) AS Max_Quantity
FROM sales_data
GROUP BY Product
HAVING MAX(Quantity) > 8;

-- Q21. Find salespersons with no sales in Furniture category.

SELECT SalesPerson
FROM sales_data
GROUP BY SalesPerson
HAVING SUM(CASE
              WHEN Category = 'Furniture' THEN 1
              ELSE 0
           END) = 0;
           
-- Q22. Find top 5 customers by average order value.

SELECT Customer,
       AVG(Revenue) AS Average_Order_Value
FROM sales_data
GROUP BY Customer
ORDER BY Average_Order_Value DESC
LIMIT 5;

-- Q23. Find regions where Electronics revenue > Furniture revenue.

SELECT Region
FROM sales_data
GROUP BY Region
HAVING SUM(IF(Category='Electronics', Revenue, 0))
     > SUM(IF(Category='Furniture', Revenue, 0));

-- Q24. Find countries contributing more than 20% of total revenue.

SELECT Country,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Country
HAVING SUM(Revenue) > (SELECT SUM(Revenue) * 0.20 FROM sales_data);

-- Q25. Find products with average unit price higher than category average.

SELECT Product,
       AVG(UnitPrice) AS Avg_UnitPrice
FROM sales_data
GROUP BY Product, Category
HAVING AVG(UnitPrice) >
(
    SELECT AVG(UnitPrice)
    FROM sales_data
);

-- Q26. Find customers whose last order value is higher than their first order.

SELECT Customer
FROM sales_data
GROUP BY Customer
HAVING MAX(Revenue) > MIN(Revenue);

-- Q27. Find salespersons whose total revenue rank is in top 5.

SELECT SalesPerson,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY SalesPerson
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Q28. Find products with total revenue between 50000 and 150000.

SELECT Product,
       SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Product
HAVING SUM(Revenue) BETWEEN 50000 AND 150000;


-- Q29. Find regions where minimum order revenue > 5000.

SELECT Region,
       MIN(Revenue) AS Min_Revenue
FROM sales_data
GROUP BY Region
HAVING MIN(Revenue) > 5000;

-- Q30. Find countries where order count is below regional average.
 
SELECT Country,
       COUNT(*) AS Total_Orders
FROM sales_data
GROUP BY Country
HAVING COUNT(*) <
(
    SELECT AVG(Cnt)
    FROM
    (
        SELECT COUNT(*) AS Cnt
        FROM sales_data
        GROUP BY Region
    ) A
);





