create database windowdata;
use windowdata;

CREATE TABLE Sales_Data (
    Order_ID          VARCHAR(20),
    Order_Date        DATE,
    Customer_ID       VARCHAR(20),
    Customer_Name     VARCHAR(100),
    Region            VARCHAR(50),
    Salesperson       VARCHAR(100),
    Product_Category  VARCHAR(100),
    Product_Name      VARCHAR(100),
    Quantity          INT,
    Unit_Price        DECIMAL(12,2),
    Total_Amount      DECIMAL(14,2)
);
select * from Sales_data;


-- 1. Rank salespeople based on Total_Amount in each Region using RANK().
SELECT Salesperson, Region, Total_Amount,
       RANK() OVER (PARTITION BY Region ORDER BY Total_Amount DESC) AS rank_num
FROM Sales_Data;


-- 2. Find the top 3 highest sales in each Region using DENSE_RANK().
SELECT * FROM (
   SELECT *, DENSE_RANK() OVER (PARTITION BY Region ORDER BY Total_Amount DESC) AS drnk
   FROM Sales_Data
) t
WHERE drnk <= 3;


-- 3. Assign row numbers to each order per Customer based on Order_Date using ROW_NUMBER().
SELECT *, ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS row_num
FROM Sales_Data;


-- 4. Calculate running total of sales per Salesperson ordered by Order_Date.
SELECT *, SUM(Total_Amount) OVER (PARTITION BY Salesperson ORDER BY Order_Date) AS running_total
FROM Sales_Data;


-- 5. Calculate cumulative sales per Region.
SELECT *, SUM(Total_Amount) OVER (PARTITION BY Region ORDER BY Order_Date) AS cumulative_sales
FROM Sales_Data;


-- 6. Find previous order amount per Customer using LAG().
SELECT *, LAG(Total_Amount) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS prev_amount
FROM Sales_Data;


-- 7. Find next order amount per Customer using LEAD().
SELECT *, LEAD(Total_Amount) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS next_amount
FROM Sales_Data;


-- 8. Calculate difference between current and previous order amount using LAG().
SELECT *, Total_Amount - LAG(Total_Amount) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS diff_amount
FROM Sales_Data;


-- 9. Find first order amount per Customer using FIRST_VALUE().
SELECT *, FIRST_VALUE(Total_Amount) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS first_order
FROM Sales_Data;


-- 10. Find latest order amount per Customer using LAST_VALUE().
SELECT *, LAST_VALUE(Total_Amount) OVER (
   PARTITION BY Customer_ID ORDER BY Order_Date
   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_order
FROM Sales_Data;


-- 11. Calculate average sales per Region using AVG() OVER().
SELECT *, AVG(Total_Amount) OVER (PARTITION BY Region) AS region_avg
FROM Sales_Data;


-- 12. Calculate moving average of last 3 sales per Salesperson.
SELECT *, AVG(Total_Amount) OVER (
   PARTITION BY Salesperson ORDER BY Order_Date
   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS moving_avg_3
FROM Sales_Data;


-- 13. Divide sales into 4 quartiles using NTILE(4).
SELECT *, NTILE(4) OVER (ORDER BY Total_Amount) AS quartile
FROM Sales_Data;


-- 14. Find percentage contribution of each order to total Region sales.
SELECT *,
   Total_Amount * 100.0 / SUM(Total_Amount) OVER (PARTITION BY Region) AS pct_contribution
FROM Sales_Data;


-- 15. Identify highest sale per Salesperson using MAX() OVER().
SELECT *, MAX(Total_Amount) OVER (PARTITION BY Salesperson) AS max_sale
FROM Sales_Data;


-- 16. Count total orders per Customer using COUNT() OVER().
SELECT *, COUNT(*) OVER (PARTITION BY Customer_ID) AS total_orders
FROM Sales_Data;


-- 17. Find monthly total sales using window functions.
SELECT *,
   SUM(Total_Amount) OVER (PARTITION BY MONTH(Order_Date)) AS monthly_total
FROM Sales_Data;


-- 18. Compare each order with Region average and mark Above/Below average.
SELECT *,
   CASE WHEN Total_Amount > AVG(Total_Amount) OVER (PARTITION BY Region)
        THEN 'Above' ELSE 'Below' END AS avg_comparison
FROM Sales_Data;


-- 19. Find second highest sale per Region.
SELECT * FROM (
   SELECT *, DENSE_RANK() OVER (PARTITION BY Region ORDER BY Total_Amount DESC) AS drnk
   FROM Sales_Data
) t
WHERE drnk = 2;


-- 20. Identify customers whose latest order is greater than their average order.
SELECT * FROM (
   SELECT *,
      LAST_VALUE(Total_Amount) OVER (
         PARTITION BY Customer_ID ORDER BY Order_Date
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS latest_order,
      AVG(Total_Amount) OVER (PARTITION BY Customer_ID) AS avg_order
   FROM Sales_Data
) t
WHERE latest_order > avg_order;