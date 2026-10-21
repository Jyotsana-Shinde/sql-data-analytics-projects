create database mydata;
use mydata;


create	table employee(
emp_id int primary key,
name varchar(50),
department varchar(50),
salary int,
gendar varchar(10));


insert into employee values
(1,"neha","IT",50000,"female"),
(2,"Jagruti","CS",35000,"female"),
(3,"Kajal","Sales",25000,"Female"),
(4,"Jagruti","Admin",45000,"female"),
(5,"Suraj","Sci",50000,"Male"),
(6,"Jyotsana","Math",15000,"female"),
(7,"Yogesh","chem",65000,"Male");

select * from employee;

create table department(
dept_id int primary key,
dept_name varchar(50),
location varchar(50)
);

insert into department values
(201,"CS","Nashik"),
(202,"sale","pune"),
(203,"IT","Satana"),
(204,"HR","Nashik");

select * from department;


create table   product(
product_id int unique,
product_name  varchar(50),
price int,
stock_qty int,
created_by_emp int,
foreign key (created_by_emp) references Employee(emp_id)
);

INSERT INTO Product
(product_id, product_name, price, stock_qty, created_by_emp)
VALUES
(101, 'Laptop', 50000, 10, 1),
(102, 'Mouse', 500, 50, 2),
(103, 'Keyboard', 1200, 25, 3),
(104, 'Monitor', 15000, 8, 4),
(105, 'Printer', 8000, 12, 5),
(106, 'Speaker', 2500, 20, 1),
(107, 'Webcam', 1800, 15, 2),
(108, 'Hard Disk', 4500, 18, 3),
(109, 'Pendrive', 700, 40, 4),
(110, 'Router', 2200, 10, 5);

select * from product;

create table sales(
sales_id int,
product_id int,
quantity_sold int,
sale_amount int,
sale_date date);

INSERT INTO Sales
(sales_id, product_id, quantity_sold, sale_amount, sale_date)
VALUES
(301, 101, 2, 100000, '2026-06-01'),
(302, 102, 5, 2500, '2026-06-02'),
(303, 103, 3, 3600, '2026-06-03'),
(304, 104, 1, 15000, '2026-06-04'),
(305, 105, 2, 16000, '2026-06-05'),
(306, 106, 4, 10000, '2026-06-06'),
(307, 107, 2, 3600, '2026-06-07'),
(308, 108, 3, 13500, '2026-06-08'),
(309, 109, 10, 7000, '2026-06-09'),
(310, 110, 2, 4400, '2026-06-10'),
(311, 101, 1, 50000, '2026-06-11'),
(312, 105, 1, 8000, '2026-06-12');

-- 5 Show all employees whose salary is more than 40,000

select * from employee
where salary > 40000;

-- 6 Show all male employees
select * from employee
where gendar="Male";

-- 7 Display the name and department of all employees
select name department from employee;

-- 8 Sort employee records by salary in descending order
select * from employee
order by salary desc;

-- 9  Show top 3 highest paid employees (use LIMIT)
select * from employee
order by salary desc
LIMIT 3;

--  10 Count total number of employees in each department(GROUP BY)
 select department, count(*) as tot_employee
from employee
group by department;

-- 11  Display departments located in “Mumbai”
select * from department 
where location="Mumbai";

 -- 12 Show products whose price is greater than 500.
select * from product 
where price > 500;

-- 13 Get the product name and price sorted by price in ASC order
SELECT product_name, price
FROM product
ORDER BY price ASC;

--  14 Create PRODUCT table with foreign key referencing employee
--  15 Change column name “stock_qty” to “available_qty”(ALTER)
ALTER TABLE Product
CHANGE stock_qty available_qty INT;

-- 16  Add new column “discount INT” to PRODUCT table
ALTER TABLE Product
ADD discount INT;

-- 17 Update salary of employee with emp_id = 3 by increasing 5,000
UPDATE Employee
SET salary = salary + 5000
WHERE emp_id = 3;

-- Delete product where product_id = 10
DELETE FROM Product
WHERE product_id = 10;

-- 18 Find the total stock (SUM of stock_qty) of all products
ALTER TABLE Product
RENAME COLUMN stock_qty TO available_qty;

ALTER TABLE Product
CHANGE stock_qty available_qty INT;

SELECT SUM(available_qty) AS total_stock
FROM Product;

-- 19 Find the average salary of all employees
SELECT AVG(salary) AS average_salary
FROM Employee;

-- 20 Show total quantity sold for each product (GROUP BY)
SELECT product_id,
       SUM(quantity_sold) AS total_quantity_sold
FROM Sales
GROUP BY product_id;

-- 21 Get total sales amount per product where total > 1000 (HAVING)
SELECT product_id,
       SUM(sale_amount) AS total_sales
FROM Sales
GROUP BY product_id
HAVING SUM(sale_amount) > 1000;

-- 22 Display top 5 sold products (ORDER BY + LIMIT)
SELECT product_id,
       SUM(quantity_sold) AS total_sold
FROM Sales
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 5;

-- 23  Show employee who created the most number of products
SELECT created_by_emp,
       COUNT(*) AS total_products
FROM Product
GROUP BY created_by_emp
ORDER BY total_products DESC
LIMIT 1;

-- 24 Add a NOT NULL constraint to price column in PRODUCT table
ALTER TABLE Product
MODIFY price INT NOT NULL;

-- 25 Modify salary column to BIGINT
ALTER TABLE Employee
MODIFY salary BIGINT;

-- 26  Rename table EMPLOYEE to EMP_MASTER
RENAME TABLE Employee TO Emp_Master;

-- 27 Delete all sales done before 2024
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Sales
WHERE sale_date < '2024-01-01';

SET SQL_SAFE_UPDATES = 1;

-- 28 Show the highest sale amount from SALES table
SELECT MAX(sale_amount) AS highest_sale
FROM Sales;

-- 29 Show price_per_unit (sale_amount / quantity_sold)
SELECT sales_id,
       sale_amount / quantity_sold AS price_per_unit
FROM Sales;
-- 30 Get employees whose salary is between 40,000 and 80,000
SELECT *
FROM Emp_Master
WHERE salary BETWEEN 40000 AND 80000;






