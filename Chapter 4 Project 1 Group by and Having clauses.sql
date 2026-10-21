create database sales;
use sales;

CREATE TABLE SalesData (
    SaleID INT PRIMARY KEY,
    OrderDate DATE,
    Region VARCHAR(50),
    Country VARCHAR(50),
    Product VARCHAR(50),
    Category VARCHAR(50),
    SalesPerson VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Revenue DECIMAL(10,2)
);
INSERT INTO SalesData VALUES
(1,'2024-02-02','Asia','India','Laptop','Electronics','Neha',5,50000,5,237500),
(2,'2024-02-03','Asia','India','Phone','Electronics','Jagruti',10,20000,10,180000),
(3,'2024-02-04','Europe','UK','Table','Furniture','Kajal',3,15000,5,42750),
(4,'2024-02-05','Europe','UK','Chair','Furniture','Suraj',6,5000,2,29400),
(5,'2024-02-06','North','USA','Laptop','Electronics','Neha',2,52000,5,98800),
(6,'2024-02-07','North','USA','Desk','Furniture','Yogesh',4,10000,10,36000),
(7,'2024-02-08','South','India','Printer','Electronics','Jyotsana',3,8000,7,22320),
(8,'2024-02-09','South','India','Mouse','Electronics','Neha',20,500,0,10000),
(9,'2024-02-10','Asia','India','Keyboard','Electronics','Jagruti',15,1200,8,16560),
(10,'2024-02-11','Europe','UK','Sofa','Furniture','Kajal',2,30000,12,52800),
(11,'2024-02-12','North','USA','Laptop','Electronics','Suraj',3,50000,5,142500),
(12,'2024-02-13','South','India','Chair','Furniture','Yogesh',10,4500,3,43650),
(13,'2024-02-14','Asia','India','Monitor','Electronics','Neha',4,15000,6,56400),
(14,'2024-02-15','Asia','India','Tablet','Electronics','Jagruti',8,25000,9,181000),
(15,'2024-02-16','Europe','UK','Bed','Furniture','Kajal',1,40000,5,38000),
(16,'2024-02-17','North','USA','Mouse','Electronics','Suraj',30,600,2,17640),
(17,'2024-02-18','South','India','Laptop','Electronics','Neha',1,50000,5,47500),
(18,'2024-02-19','Asia','India','Desk','Furniture','Jyotsana',5,12000,7,55800),
(19,'2024-02-20','Europe','UK','Monitor','Electronics','Yogesh',6,14000,4,79800),
(20,'2024-02-21','North','USA','Chair','Furniture','Jagruti',12,4000,10,43200);
-- 1	Find total revenue by Region.
SELECT Region,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
GROUP BY Region;

-- 2 Count number of sales per Product.
SELECT Product,
       COUNT(*) AS Total_Sales
FROM SalesData
GROUP BY Product;

-- 3 Find total quantity sold per Category.
SELECT Category,
       SUM(Quantity) AS Total_Quantity_Sold
FROM SalesData
GROUP BY Category;

-- 4 Find average unit price per Product.
SELECT Product,
       AVG(UnitPrice) AS Avg_UnitPrice
FROM SalesData
GROUP BY Product;

-- 5 Find number of orders per SalesPerson.
SELECT SalesPerson,
       COUNT(*) AS Total_Orders
FROM SalesData
GROUP BY SalesPerson;

-- 6 Find maximum revenue per Country.
SELECT Country,
       MAX(Revenue) AS Max_Revenue
FROM SalesData
GROUP BY Country;

-- 7 Find minimum discount per Category.
SELECT Category,
       MIN(Discount) AS Min_Discount
FROM SalesData
GROUP BY Category;

-- 8 Find total revenue per Product and Category.
SELECT Product,
       Category,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
GROUP BY Product, Category;

-- 9 Find Regions where total revenue is greater than 500000.
SELECT Region,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
GROUP BY Region
HAVING SUM(Revenue) > 500000;

-- 10 Find Products where total quantity sold is at least 100.
SELECT Product,
       SUM(Quantity) AS Total_Quantity
FROM SalesData
GROUP BY Product
HAVING SUM(Quantity) >= 100;

-- 11 Find SalesPersons who made more than 8 sales.
SELECT SalesPerson,
       COUNT(*) AS Total_Sales
FROM SalesData
GROUP BY SalesPerson
HAVING COUNT(*) > 8;

-- 12 Find Categories where average discount is greater than 7.5%.
SELECT Category,
       AVG(Discount) AS Avg_Discount
FROM SalesData
GROUP BY Category
HAVING AVG(Discount) > 5;

-- 13 Find Countries where maximum revenue is greater than 1000.
SELECT Country,
       MAX(Revenue) AS Max_Revenue
FROM SalesData
GROUP BY Country
HAVING MAX(Revenue) > 100000;



-- 14  Find Products sold in more than 3 Regions.
SELECT Product,
       COUNT(DISTINCT Region) AS Total_Regions
FROM SalesData
GROUP BY Product
HAVING COUNT(DISTINCT Region) > 3;

 drop table SalesData;
 
 -- 15 Find total revenue by Region for orders after 2024-02-01.
 
SELECT Region,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
WHERE OrderDate >= '2024-02-02'
GROUP BY Region;

-- 16 Find SalesPersons who sold more than 50 items for Category = 'Electronics'.
SELECT SalesPerson,
       SUM(Quantity) AS Total_Items_Sold
FROM SalesData
WHERE Category = 'Electronics'
GROUP BY SalesPerson
HAVING SUM(Quantity) > 22;

-- 17 Find Countries where average unit price is greater than 500 considering Quantity >= 2.
SELECT Country,
       AVG(UnitPrice) AS Avg_UnitPrice
FROM SalesData
WHERE Quantity >= 2
GROUP BY Country
HAVING AVG(UnitPrice) > 500;

-- 18 Find top 3 Regions by total revenue for sales after 2024-02-01.
SELECT Region,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
WHERE OrderDate > '2024-02-01'
GROUP BY Region
ORDER BY Total_Revenue DESC
LIMIT 3;

-- 19 Find top 5 Products by total quantity sold for Category = 'Furniture'.
SELECT Product,
       SUM(Quantity) AS Total_Quantity
FROM SalesData
WHERE Category = 'Furniture'
GROUP BY Product
ORDER BY Total_Quantity DESC
LIMIT 5;

-- 20 Find top 3 SalesPersons by total revenue where Discount < 20%.
SELECT SalesPerson,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
WHERE Discount < 20
GROUP BY SalesPerson
ORDER BY Total_Revenue DESC
LIMIT 3;

-- 21 Find bottom 2 Countries by total revenue for Region = 'Asia'.
SELECT Country,
       SUM(Revenue) AS Total_Revenue
FROM SalesData
WHERE Region = 'Asia'
GROUP BY Country
ORDER BY Total_Revenue ASC
LIMIT 2;


