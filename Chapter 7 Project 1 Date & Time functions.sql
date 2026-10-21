create database func;
use func;

CREATE TABLE  Orders_Data (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Order_Time TIME,
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Region VARCHAR(50),
    Order_Status VARCHAR(50),
    Shipment_Date DATE,
    Delivery_Date DATE,
    Total_Amount DECIMAL(12,2)
);

-- Attendance_Data table
CREATE TABLE   Attendance_Data (
    Employee_ID VARCHAR(20),
    Employee_Name VARCHAR(100),
    Department VARCHAR(50),
    Login_Date DATE,
    Login_Time TIME,
    Logout_Time TIME
);

select * from orders_data;
select * from attendance_data;

-- 1. Extract year from Order_Date
SELECT Order_ID, Order_Date, YEAR(Order_Date) AS Order_Year
FROM Orders_Data;


-- 2. Extract month name from Order_Date
SELECT Order_ID, Order_Date, MONTHNAME(Order_Date) AS Order_Month
FROM Orders_Data;

-- 3. Extract quarter from Order_Date
SELECT Order_ID, Order_Date, QUARTER(Order_Date) AS Order_Quarter
FROM Orders_Data;

-- 4. Find total orders placed in each year
SELECT YEAR(Order_Date) AS Order_Year, COUNT(*) AS Total_Orders
FROM Orders_Data
GROUP BY YEAR(Order_Date);

-- 5. Find total orders placed in each month
SELECT MONTHNAME(Order_Date) AS Order_Month, COUNT(*) AS Total_Orders
FROM Orders_Data
GROUP BY MONTHNAME(Order_Date), MONTH(Order_Date)
ORDER BY MONTH(Order_Date);

-- 6. Calculate number of days between Order_Date and Delivery_Date
SELECT  Order_Date, Delivery_Date,
       DATEDIFF(Delivery_Date, Order_Date) AS Days_To_Deliver
FROM Orders_Data;

-- 7. Find average delivery time in days
SELECT AVG(DATEDIFF(Delivery_Date, Order_Date)) AS Avg_Delivery_Days
FROM Orders_Data;

-- 8. Identify orders delivered in less than 3 days
SELECT Order_ID, Order_Date, Delivery_Date,
       DATEDIFF(Delivery_Date, Order_Date) AS Days_To_Deliver
FROM Orders_Data
WHERE DATEDIFF(Delivery_Date, Order_Date) < 3;

-- 9. Find orders placed on weekends
SELECT Order_ID, Order_Date, DAYNAME(Order_Date) AS Day_Name
FROM Orders_Data
WHERE DAYOFWEEK(Order_Date) IN (1, 7);

-- 10. Find orders placed in the last 30 days
SELECT Order_ID, Order_Date
FROM Orders_Data
WHERE Order_Date >= CURDATE() - INTERVAL 30 DAY;

-- 11. Calculate total sales for current year
SELECT SUM(Total_Amount) AS Current_Year_Sales
FROM Orders_Data
WHERE YEAR(Order_Date) = YEAR(CURDATE());

-- 12. Calculate total sales for previous year
SELECT SUM(Total_Amount) AS Previous_Year_Sales
FROM Orders_Data
WHERE YEAR(Order_Date) = YEAR(CURDATE()) - 1;

-- 13. Find first order date per customer
SELECT Customer_ID, MIN(Order_Date) AS First_Order_Date
FROM Orders_Data
GROUP BY Customer_ID;

-- 14. Find latest order date per customer
SELECT Customer_ID, MAX(Order_Date) AS Latest_Order_Date
FROM Orders_Data
GROUP BY Customer_ID;

-- 15. Extract hour from Order_Time
SELECT Order_ID, Order_Time, HOUR(Order_Time) AS Order_Hour
FROM Orders_Data;

-- 16. Count how many orders were placed in each hour of the day
SELECT HOUR(Order_Time) AS Order_Hour, COUNT(*) AS Total_Orders
FROM Orders_Data
GROUP BY HOUR(Order_Time)
ORDER BY Order_Hour;

-- 17. Find peak order hour
SELECT HOUR(Order_Time) AS Order_Hour, COUNT(*) AS Total_Orders
FROM Orders_Data
GROUP BY HOUR(Order_Time)
ORDER BY Total_Orders DESC
LIMIT 1;

-- 18. Calculate employee working hours using Login_Time and Logout_Time
SELECT Employee_ID, Login_Time, Logout_Time,
       TIMEDIFF(Logout_Time, Login_Time) AS Working_Hours
FROM Attendance_Data;

-- 19. Find employees who worked more than 9 hours
SELECT Employee_ID, Login_Time, Logout_Time,
       TIMESTAMPDIFF(HOUR, Login_Time, Logout_Time) AS Hours_Worked
FROM Attendance_Data
WHERE TIMESTAMPDIFF(HOUR, Login_Time, Logout_Time) > 9;

-- 20. Find monthly attendance count per department
SELECT Department, MONTHNAME(Login_Date) AS Month, COUNT(*) AS Attendance_Count
FROM Attendance_Data
GROUP BY Department, MONTHNAME(Login_Date), MONTH(Login_Date)
ORDER BY Department, MONTH(Login_Date);

-- 21. Calculate difference between current date and Order_Date
SELECT Order_ID, Order_Date,
       DATEDIFF(CURDATE(), Order_Date) AS Days_Since_Order
FROM Orders_Data;

-- 22. Find orders shipped within 2 days of Order_Date
SELECT Order_ID, Order_Date, Shipment_Date,
       DATEDIFF(Shipment_Date, Order_Date) AS Days_To_Ship
FROM Orders_Data
WHERE DATEDIFF(Shipment_Date, Order_Date) <= 2;

-- 23. Identify cancelled orders in current month
SELECT Order_ID, Order_Date, Order_Status
FROM Orders_Data
WHERE Order_Status = 'Cancelled'
  AND MONTH(Order_Date) = MONTH(CURDATE())
  AND YEAR(Order_Date) = YEAR(CURDATE());

-- 24. Find customers who ordered in consecutive months
SELECT DISTINCT a.Customer_ID
FROM Orders_Data a
JOIN Orders_Data b
  ON a.Customer_ID = b.Customer_ID
  AND PERIOD_DIFF(DATE_FORMAT(b.Order_Date, '%Y%m'), DATE_FORMAT(a.Order_Date, '%Y%m')) = 1;

-- 25. Calculate week number from Order_Date
SELECT Order_ID, Order_Date, WEEK(Order_Date) AS Week_Number
FROM Orders_Data;

-- 26. Group sales by year and quarter
SELECT YEAR(Order_Date) AS Order_Year, QUARTER(Order_Date) AS Order_Quarter,
       SUM(Total_Amount) AS Total_Sales
FROM Orders_Data
GROUP BY YEAR(Order_Date), QUARTER(Order_Date)
ORDER BY Order_Year, Order_Quarter;

-- 27. Find orders placed in the same month last year
SELECT Order_ID, Order_Date
FROM Orders_Data
WHERE MONTH(Order_Date) = MONTH(CURDATE())
  AND YEAR(Order_Date) = YEAR(CURDATE()) - 1;

-- 28. Calculate cumulative monthly sales
SELECT Order_Year, Order_Month,
       SUM(Total_Amount) AS Monthly_Sales,
       SUM(SUM(Total_Amount)) OVER (ORDER BY Order_Year, Order_Month) AS Cumulative_Sales
FROM (
    SELECT YEAR(Order_Date) AS Order_Year, MONTH(Order_Date) AS Order_Month, Total_Amount
    FROM Orders_Data
) AS t
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

-- 29. Find average login time per department
SELECT Department,
       SEC_TO_TIME(AVG(TIME_TO_SEC(Login_Time))) AS Avg_Login_Time
FROM Attendance_Data
GROUP BY Department;

-- 30. Identify late logins (after 10:00 AM)
SELECT Employee_ID, Login_Date, Login_Time
FROM Attendance_Data
WHERE Login_Time > '10:00:00';

-- 31. Find total orders per weekday
SELECT DAYNAME(Order_Date) AS Weekday, COUNT(*) AS Total_Orders
FROM Orders_Data
GROUP BY DAYNAME(Order_Date), DAYOFWEEK(Order_Date)
ORDER BY DAYOFWEEK(Order_Date);

-- 32. Find difference between Shipment_Date and Delivery_Date
SELECT Order_ID, Shipment_Date, Delivery_Date,
       DATEDIFF(Delivery_Date, Shipment_Date) AS Days_Shipment_To_Delivery
FROM Orders_Data;

-- 33. Calculate yearly growth in total sales
SELECT Order_Year, Total_Sales,
       Total_Sales - LAG(Total_Sales) OVER (ORDER BY Order_Year) AS Growth_From_Last_Year
FROM (
    SELECT YEAR(Order_Date) AS Order_Year, SUM(Total_Amount) AS Total_Sales
    FROM Orders_Data
    GROUP BY YEAR(Order_Date)
) AS yearly;

-- 34. Find orders placed in financial year (Apr-March)
SELECT Order_ID, Order_Date
FROM Orders_Data
WHERE Order_Date BETWEEN '2023-04-01' AND '2024-03-31';

-- 35. Identify employees with consecutive attendance days
SELECT DISTINCT a.Employee_ID
FROM Attendance_Data a
JOIN Attendance_Data b
  ON a.Employee_ID = b.Employee_ID
  AND DATEDIFF(b.Login_Date, a.Login_Date) = 1;







 