create database minor1;
use minor1;

-- Q1.Create USERS table with appropriate data types and constraints.

CREATE TABLE USERS (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    role VARCHAR(50),
    created_date DATE,
    status VARCHAR(20)
);

drop table users;

INSERT INTO USERS VALUES
(1, 'Amit Sharma', 'amit@gmail.com', 'Developer', '2024-01-10', 'Active'),
(2, 'Neha Verma', 'neha@gmail.com', 'Analyst', '2024-02-15', 'Active'),
(3, 'Ravi Kumar', 'ravi@gmail.com', 'Manager', '2023-12-01', 'Active'),
(4, 'Sneha Patil', 'sneha@gmail.com', 'Developer', '2024-03-20', 'Inactive'),
(5, 'Karan Mehta', 'karan@gmail.com', 'Tester', '2024-04-05', 'Active'),
(6, 'Pooja Desai', 'pooja@gmail.com', 'Analyst', '2024-01-25', 'Active'),
(7, 'Arjun Singh', 'arjun@gmail.com', 'Developer', '2024-02-10', 'Active'),
(8, 'Meera Iyer', 'meera@gmail.com', 'Designer', '2024-03-12', 'Active'),
(9, 'Vikram Joshi', 'vikram@gmail.com', 'Manager', '2023-11-18', 'Inactive'),
(10, 'Ananya Rao', 'ananya@gmail.com', 'Tester', '2024-05-01', 'Active'),
(11, 'Suresh Patel', 'suresh@gmail.com', 'Developer', '2024-02-28', 'Active'),
(12, 'Kavita Sharma', 'kavita@gmail.com', 'HR', '2024-01-05', 'Active'),
(13, 'Rahul Verma', 'rahul@gmail.com', 'Developer', '2024-03-30', 'Active'),
(14, 'Simran Kaur', 'simran@gmail.com', 'Analyst', '2024-04-18', 'Inactive'),
(15, 'Mohit Jain', 'mohit@gmail.com', 'Tester', '2024-06-01', 'Active');

SELECT * from users;


-- Q2.Create CLIENTS table and set client_id as PRIMARY KEY.

CREATE TABLE CLIENTS (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    industry VARCHAR(100),
    country VARCHAR(50),
    status VARCHAR(20)
);

INSERT INTO CLIENTS VALUES
(1, 'Tata Technologies', 'IT Services', 'India', 'Active'),
(2, 'Infosys Ltd', 'IT Services', 'India', 'Active'),
(3, 'Walmart Inc', 'Retail', 'USA', 'Active'),
(4, 'Amazon', 'E-commerce', 'USA', 'Active'),
(5, 'Reliance Retail', 'Retail', 'India', 'Active'),
(6, 'Google LLC', 'Technology', 'USA', 'Active'),
(7, 'Samsung', 'Electronics', 'South Korea', 'Active'),
(8, 'Capgemini', 'Consulting', 'France', 'Inactive');

SELECT * FROM clients;


-- Q3. Create PROJECTS table with FOREIGN KEY reference to CLIENTS.

CREATE TABLE PROJECTS (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(150),
    client_id INT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
);

INSERT INTO PROJECTS VALUES
(1, 'Website Development', 1, '2024-01-01', '2024-06-01', 500000),
(2, 'Mobile App Development', 2, '2024-02-01', '2024-08-01', 750000),
(3, 'E-commerce Platform', 4, '2024-03-15', '2024-09-15', 900000),
(4, 'Data Analytics Dashboard', 3, '2024-04-01', '2024-10-01', 300000),
(5, 'Cloud Migration Project', 6, '2024-01-20', '2024-07-20', 650000),
(6, 'Retail Inventory System', 5, '2024-02-10', '2024-08-10', 400000),
(7, 'AI Chatbot Development', 6, '2024-03-01', '2024-09-01', 850000),
(8, 'ERP Implementation', 1, '2024-05-01', '2024-11-01', 1200000),
(9, 'Smart Device Integration', 7, '2024-06-01', '2024-12-01', 700000),
(10, 'IT Consulting Project', 8, '2024-01-10', '2024-06-30', 250000);

SELECT * FROM PROJECTS;

-- Q4. Create TASKS table with FOREIGN KEY reference to PROJECTS and USERS.

CREATE TABLE TASKS (
    task_id INT PRIMARY KEY,
    project_id INT,
    assigned_to INT,
    task_status VARCHAR(50),
    hours_spent INT,
    FOREIGN KEY (project_id) REFERENCES PROJECTS(project_id),
    FOREIGN KEY (assigned_to) REFERENCES USERS(user_id)
);

INSERT INTO TASKS VALUES
(1, 1, 1, 'Completed', 10),
(2, 1, 2, 'In Progress', 12),
(3, 1, 6, 'Completed', 8),
(4, 1, 7, 'Pending', 5),
(5, 2, 3, 'Completed', 15),
(6, 2, 7, 'In Progress', 18),
(7, 2, 11, 'Completed', 10),
(8, 2, 13, 'Pending', 6),
(9, 3, 2, 'Completed', 20),
(10, 3, 6, 'In Progress', 14),
(11, 3, 14, 'Pending', 9),
(12, 3, 5, 'Completed', 11),
(13, 4, 1, 'In Progress', 13),
(14, 4, 8, 'Completed', 16),
(15, 4, 10, 'Pending', 7),
(16, 4, 2, 'Completed', 9),
(17, 5, 6, 'Completed', 22),
(18, 5, 11, 'In Progress', 18),
(19, 5, 13, 'Pending', 10),
(20, 5, 7, 'Completed', 12),
(21, 6, 5, 'Completed', 14),
(22, 6, 10, 'In Progress', 16),
(23, 6, 14, 'Pending', 8),
(24, 6, 2, 'Completed', 11),
(25, 7, 6, 'Completed', 25),
(26, 7, 7, 'In Progress', 20),
(27, 7, 1, 'Pending', 10),
(28, 7, 11, 'Completed', 13),
(29, 8, 3, 'Completed', 30),
(30, 8, 8, 'In Progress', 22),
(31, 8, 13, 'Pending', 15),
(32, 8, 5, 'Completed', 18),
(33, 9, 7, 'Completed', 19),
(34, 9, 10, 'In Progress', 17),
(35, 9, 6, 'Pending', 9),
(36, 9, 2, 'Completed', 14),
(37, 10, 8, 'Completed', 12),
(38, 10, 14, 'In Progress', 10),
(39, 10, 1, 'Pending', 6),
(40, 10, 5, 'Completed', 11);

SELECT * FROM TASKS;

-- INVOICES TABLE

CREATE TABLE INVOICES (
    invoice_id INT PRIMARY KEY,
    project_id INT,
    invoice_date DATE,
    amount DECIMAL(12,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (project_id) REFERENCES PROJECTS(project_id)
);

INSERT INTO INVOICES VALUES
(1, 1, '2024-02-01', 200000, 'Paid'),
(2, 1, '2024-04-01', 300000, 'Pending'),
(3, 2, '2024-03-10', 250000, 'Paid'),
(4, 2, '2024-06-10', 500000, 'Pending'),
(5, 3, '2024-05-01', 400000, 'Paid'),
(6, 3, '2024-08-01', 500000, 'Pending'),
(7, 4, '2024-06-01', 150000, 'Paid'),
(8, 4, '2024-09-01', 150000, 'Pending'),
(9, 5, '2024-02-20', 300000, 'Paid'),
(10, 5, '2024-05-20', 350000, 'Pending'),
(11, 6, '2024-03-15', 200000, 'Paid'),
(12, 6, '2024-06-15', 200000, 'Pending'),
(13, 7, '2024-04-01', 400000, 'Paid'),
(14, 7, '2024-07-01', 450000, 'Pending'),
(15, 8, '2024-06-10', 600000, 'Paid'),
(16, 8, '2024-09-10', 600000, 'Pending'),
(17, 9, '2024-07-01', 350000, 'Paid'),
(18, 10, '2024-05-30', 250000, 'Pending');

-- Q5. Insert minimum 10 records into USERS table.

INSERT INTO USERS VALUES (16, 'Simran Kaur', 'simran@gmail.com', 'Analyst', '2024-06-10', 'Active');
INSERT INTO USERS VALUES (17, 'Mohit Jain', 'mohit@gmail.com', 'Tester', '2024-06-12', 'Active');
INSERT INTO USERS VALUES (18, 'Ritika Sharma', 'ritika@gmail.com', 'Developer', '2024-06-15', 'Active');
INSERT INTO USERS VALUES (19, 'Aditya Singh', 'aditya@gmail.com', 'Manager', '2024-06-18', 'Inactive');
INSERT INTO USERS VALUES (20, 'Kavya Mehta', 'kavya@gmail.com', 'Designer', '2024-06-20', 'Active');
INSERT INTO USERS VALUES (21, 'Yash Patil', 'yash@gmail.com', 'Developer', '2024-06-22', 'Active');
INSERT INTO USERS VALUES (22, 'Isha Verma', 'isha@gmail.com', 'Analyst', '2024-06-24', 'Active');
INSERT INTO USERS VALUES (23, 'Nikhil Sharma', 'nikhil@gmail.com', 'Tester', '2024-06-25', 'Active');
INSERT INTO USERS VALUES (24, 'Priya Desai', 'priya@gmail.com', 'HR', '2024-06-26', 'Active');
INSERT INTO USERS VALUES (25, 'Rahul Mehta', 'rahul@gmail.com', 'Developer', '2024-06-28', 'Active');

SELECT * FROM USERS;

-- Q6. Insert at least 8 clients and 10 projects.
-- for client table
INSERT INTO CLIENTS VALUES (9, 'Adobe', 'Software', 'USA', 'Active');
INSERT INTO CLIENTS VALUES (10, 'Oracle', 'Database', 'USA', 'Active');
INSERT INTO CLIENTS VALUES (11, 'IBM', 'IT Services', 'USA', 'Active');
INSERT INTO CLIENTS VALUES (12, 'HCL Technologies', 'IT Services', 'India', 'Active');
INSERT INTO CLIENTS VALUES (13, 'Dell', 'Hardware', 'USA', 'Active');
INSERT INTO CLIENTS VALUES (14, 'Lenovo', 'Electronics', 'China', 'Active');
INSERT INTO CLIENTS VALUES (15, 'Flipkart', 'E-commerce', 'India', 'Active');
INSERT INTO CLIENTS VALUES (16, 'Paytm', 'Fintech', 'India', 'Active');
INSERT INTO CLIENTS VALUES (17, 'Twitter (X)', 'Social Media', 'USA', 'Inactive');
INSERT INTO CLIENTS VALUES (18, 'Meta', 'Social Media', 'USA', 'Active');

SELECT * FROM CLIENTS;

-- FOR PROJECT TABLE
INSERT INTO PROJECTS VALUES (11, 'Cloud ERP System', 9, '2024-07-01', '2024-12-01', 950000);
INSERT INTO PROJECTS VALUES (12, 'Database Optimization', 10, '2024-06-15', '2024-11-15', 600000);
INSERT INTO PROJECTS VALUES (13, 'AI Analytics Platform', 11, '2024-05-01', '2024-10-01', 1200000);
INSERT INTO PROJECTS VALUES (14, 'Mobile Banking App', 16, '2024-06-01', '2024-12-31', 800000);
INSERT INTO PROJECTS VALUES (15, 'E-commerce Upgrade', 15, '2024-07-10', '2024-12-10', 700000);
INSERT INTO PROJECTS VALUES (16, 'HR Management System', 12, '2024-05-20', '2024-10-20', 450000);
INSERT INTO PROJECTS VALUES (17, 'Cloud Storage System', 13, '2024-06-05', '2024-11-05', 1000000);
INSERT INTO PROJECTS VALUES (18, 'Smart Device Integration', 14, '2024-07-15', '2024-12-15', 650000);
INSERT INTO PROJECTS VALUES (19, 'Social Media Analytics', 18, '2024-06-25', '2024-12-25', 900000);
INSERT INTO PROJECTS VALUES (20, 'Payment Gateway System', 16, '2024-07-01', '2024-12-01', 750000);

SELECT * FROM PROJECTS;

-- Q7. Display all active users.

SELECT * FROM USERS
WHERE status = 'Active';

-- Q8. Find users created in the last 6 months.

SELECT * FROM USERS
WHERE created_date >= CURRENT_DATE - INTERVAL 6 MONTH;

-- Q9. Display projects that are currently running (end_date IS NULL).

SELECT * FROM PROJECTS 
WHERE end_date IS NULL;

-- Q10. Show total number of projects per client.

SELECT 
    c.client_id,
    c.client_name,
    COUNT(p.project_id) AS total_projects
FROM CLIENTS c
JOIN PROJECTS p
    ON c.client_id = p.client_id
GROUP BY c.client_id, c.client_name;

-- Q11. Display client name and total project budget.

SELECT c.client_name, SUM(p.budget) AS total_budget
FROM CLIENTS c
JOIN PROJECTS p ON c.client_id = p.client_id
GROUP BY c.client_name;

-- Q12. Show projects where budget is greater than average budget.

SELECT *
FROM PROJECTS
WHERE budget > (SELECT AVG(budget) FROM PROJECTS);

-- Q13. List all tasks assigned to a particular user.

SELECT *
FROM TASKS
WHERE assigned_to = 1;

-- Q14. Count total tasks by task_status.

SELECT task_status, COUNT(*) AS total_tasks
FROM TASKS
GROUP BY task_status;

-- Q15. Find projects with no tasks assigned (LEFT JOIN + NULL).

SELECT p.*
FROM PROJECTS p
LEFT JOIN TASKS t ON p.project_id = t.project_id
WHERE t.task_id IS NULL;

-- Q16. Calculate total hours spent per project.

SELECT project_id, SUM(hours_spent) AS total_hours
FROM TASKS
GROUP BY project_id;

-- Q17. Find the user who has worked the maximum hours.

SELECT assigned_to, SUM(hours_spent) AS total_hours
FROM TASKS
GROUP BY assigned_to
ORDER BY total_hours DESC
LIMIT 1;

-- Q18. Display invoices which are unpaid.

SELECT *
FROM INVOICES
WHERE payment_status = 'Pending';

-- Q19. Show total invoice amount per project.

SELECT project_id, SUM(amount) AS total_invoice
FROM INVOICES
GROUP BY project_id;

-- Q20. Find projects for which invoices are not generated.

SELECT p.*
FROM PROJECTS p
LEFT JOIN INVOICES i ON p.project_id = i.project_id
WHERE i.invoice_id IS NULL;

-- Q21. Display client-wise revenue (SUM of invoice amount).

SELECT c.client_name, SUM(i.amount) AS revenue
FROM CLIENTS c
JOIN PROJECTS p ON c.client_id = p.client_id
JOIN INVOICES i ON p.project_id = i.project_id
GROUP BY c.client_name;

-- Q22. Show top 3 highest revenue generating clients.

SELECT c.client_name, SUM(i.amount) AS revenue
FROM CLIENTS c
JOIN PROJECTS p ON c.client_id = p.client_id
JOIN INVOICES i ON p.project_id = i.project_id
GROUP BY c.client_name
ORDER BY revenue DESC
LIMIT 3;

-- Q23. Update project budget by increasing 10% for ongoing projects.

SET SQL_SAFE_UPDATES = 0;

UPDATE PROJECTS
SET budget = budget * 1.10;


-- Q24. Mark invoices as 'PAID' where amount < 50,000.

UPDATE INVOICES
SET payment_status = 'PAID'
WHERE amount < 50000;

-- Q25. Delete users who are inactive for more than 2 years.

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM USERS
WHERE status = 'Inactive'
AND created_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- Q26. Rename column hours_spent to effort_hours in TASKS table.

ALTER TABLE TASKS
RENAME COLUMN hours_spent TO effort_hours;

-- Q27. Add column priority to TASKS table.

ALTER TABLE TASKS
ADD priority VARCHAR(20);

-- Q28. Modify budget column data type to BIGINT.

ALTER TABLE PROJECTS
MODIFY budget BIGINT;

-- Q29. Display users who are not assigned to any task.

SELECT u.*
FROM USERS u
LEFT JOIN TASKS t ON u.user_id = t.assigned_to
WHERE t.task_id IS NULL;

-- Q30. Show projects where total hours spent exceed 500 hours.

SELECT project_id, SUM(effort_hours) AS total_hours
FROM TASKS
GROUP BY project_id
HAVING SUM(effort_hours) > 500;

-- Q31. Identify clients who have more than 2 active projects.

SELECT c.client_name, COUNT(p.project_id) AS total_projects
FROM CLIENTS c
JOIN PROJECTS p ON c.client_id = p.client_id
WHERE p.end_date >= CURDATE()
GROUP BY c.client_name
HAVING COUNT(p.project_id) > 2;

-- Q32. Display month-wise invoice count.

SELECT MONTH(invoice_date) AS month, COUNT(*) AS total_invoices
FROM INVOICES
GROUP BY MONTH(invoice_date);

-- Q33. Find the highest invoice raised for each client.

SELECT c.client_name, MAX(i.amount) AS highest_invoice
FROM CLIENTS c
JOIN PROJECTS p ON c.client_id = p.client_id
JOIN INVOICES i ON p.project_id = i.project_id
GROUP BY c.client_name;

-- Q34. Use UNION to list all user names and client names in one column.

SELECT full_name AS name FROM USERS
UNION
SELECT client_name FROM CLIENTS;

-- Q35. Show project duration in days using date arithmetic.

SELECT project_id,
DATEDIFF(end_date, start_date) AS duration_days
FROM PROJECTS;

-- Q36. Logical: Find users working on multiple projects.

SELECT assigned_to, COUNT(DISTINCT project_id) AS projects_count
FROM TASKS
GROUP BY assigned_to
HAVING COUNT(DISTINCT project_id) > 1;

-- Q37. Logical: Find projects where all tasks are completed.

SELECT project_id
FROM TASKS
GROUP BY project_id
HAVING COUNT(*) = SUM(CASE WHEN task_status = 'Completed' THEN 1 ELSE 0 END);


-- Q38. Logical: Identify clients with projects but no invoices.

SELECT c.client_name
FROM CLIENTS c
JOIN PROJECTS p ON c.client_id = p.client_id
LEFT JOIN INVOICES i ON p.project_id = i.project_id
WHERE i.invoice_id IS NULL;

-- Q39. Advanced: Rank projects based on total invoice amount.

SELECT project_id,
SUM(amount) AS revenue,
RANK() OVER (ORDER BY SUM(amount) DESC) AS rnk
FROM INVOICES
GROUP BY project_id;


-- Q40. Advanced: Find the percentage contribution of each project to total revenue.

SELECT project_id,
SUM(amount) AS revenue,
(SUM(amount) * 100.0 / (SELECT SUM(amount) FROM INVOICES)) AS percentage
FROM INVOICES
GROUP BY project_id;
