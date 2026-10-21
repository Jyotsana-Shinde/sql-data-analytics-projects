create database minorpro4;
use minorpro4;

select * from customers_dirty_data;
select * from orders_dirty_data;
select * from Employees_dirty_data;

SET SQL_SAFE_UPDATES = 0;

-- Q1. Identify duplicate customer_id records and remove duplicates using ROW_NUMBER().
WITH CTE_Duplicates AS (
    SELECT customer_id, registration_date,
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY registration_date DESC) as row_num
    FROM Customers_Dirty_Data
)
DELETE Customers_Dirty_Data 
FROM Customers_Dirty_Data
JOIN CTE_Duplicates 
  ON Customers_Dirty_Data.customer_id = CTE_Duplicates.customer_id 
  AND Customers_Dirty_Data.registration_date = CTE_Duplicates.registration_date
WHERE CTE_Duplicates.row_num > 1;


-- Q2. Standardize city names (remove extra spaces and fix casing issues).
UPDATE Customers_Dirty_Data
SET city = CONCAT(UPPER(SUBSTRING(TRIM(city), 1, 1)), LOWER(SUBSTRING(TRIM(city), 2)));


-- Q3. Replace NULL phone numbers with 'Not Available'.
UPDATE Customers_Dirty_Data
SET phone_number = COALESCE(phone_number, 'Not Available')
WHERE phone_number IS NULL;


-- Q4. Identify invalid registration_date values.
SELECT * 
FROM Customers_Dirty_Data
WHERE registration_date IS NULL 
   OR STR_TO_DATE(registration_date, '%Y-%m-%d') IS NULL;


-- Q5. Convert registration_date to proper DATE data type.
ALTER TABLE Customers_Dirty_Data MODIFY COLUMN registration_date DATE;


-- 6. Find duplicate order_id records.
SELECT order_id, COUNT(*) 
FROM Orders_Dirty_Data
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 7. Remove negative quantity orders.
DELETE FROM Orders_Dirty_Data
WHERE quantity < 0;


-- 8. Fix inconsistent order_status values (trim spaces and standardize case).
UPDATE Orders_Dirty_Data
SET order_status = CONCAT(UPPER(SUBSTRING(TRIM(order_status), 1, 1)), LOWER(SUBSTRING(TRIM(order_status), 2)));


-- 9. Identify and remove orders with invalid order_date format.
DELETE FROM Orders_Dirty_Data
WHERE STR_TO_DATE(order_date, '%Y-%m-%d') IS NULL;


-- 10. Recalculate total_amount where incorrect.
UPDATE Orders_Dirty_Data
SET total_amount = quantity * unit_price
WHERE total_amount <> (quantity * unit_price);


-- 11. Remove duplicate employee_id keeping latest hire_date.
DELETE e1 FROM Employees_Dirty_Data e1
INNER JOIN Employees_Dirty_Data e2 
ON e1.employee_id = e2.employee_id AND e1.hire_date < e2.hire_date;


-- 12. Standardize department names (IT vs it).
UPDATE Employees_Dirty_Data
SET department = UPPER(TRIM(department));


-- 13. Remove employees with negative salary.
DELETE FROM Employees_Dirty_Data
WHERE salary < 0;	


-- 14. Identify invalid hire_date values.
SELECT * FROM Employees_Dirty_Data
WHERE STR_TO_DATE(hire_date, '%Y-%m-%d') IS NULL;


-- 15. Convert hire_date to proper DATE format.
ALTER TABLE Employees_Dirty_Data MODIFY COLUMN hire_date DATE;


-- 16. Remove customers who never placed any order.
DELETE FROM Customers_Dirty_Data
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM Orders_Dirty_Data WHERE customer_id IS NOT NULL
);


-- 17. Identify customers with missing phone and email.
SELECT * FROM Customers_Dirty_Data
WHERE (phone_number IS NULL OR phone_number = 'Not Available') 
  AND (email IS NULL OR email = '');


-- 18. Detect outlier salaries using statistical functions.
SELECT * FROM Employees_Dirty_Data
WHERE salary > (SELECT AVG(salary) + (3 * STDDEV(salary)) FROM Employees_Dirty_Data)
   OR salary < (SELECT AVG(salary) - (3 * STDDEV(salary)) FROM Employees_Dirty_Data);


-- 19. Find orders with negative total_amount.
SELECT * FROM Orders_Dirty_Data
WHERE total_amount < 0;


-- 20. Create cleaned tables for Customers, Orders, and Employees.
CREATE TABLE Cleaned_Customers AS
SELECT DISTINCT customer_id, customer_name, email, phone_number, city, registration_date
FROM Customers_Dirty_Data;

CREATE TABLE Cleaned_Orders AS
SELECT DISTINCT order_id, customer_id, order_date, product_name, quantity, unit_price, total_amount, order_status
FROM Orders_Dirty_Data;

CREATE TABLE Cleaned_Employees AS
SELECT DISTINCT employee_id, employee_name, department, salary, hire_date
FROM Employees_Dirty_Data;