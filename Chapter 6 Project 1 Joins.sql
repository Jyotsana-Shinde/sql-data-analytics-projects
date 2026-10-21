create database joins;
use joins;

CREATE TABLE USERS (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    role VARCHAR(50),
    created_date DATE,
    status VARCHAR(20)
);

INSERT INTO USERS VALUE
(1,'Amit Sharma','amit@gmail.com','Admin','2024-01-10','Active'),
(2,'Priya Singh','priya@gmail.com','Employee','2024-01-12','Active'),
(3,'Rahul Verma','rahul@gmail.com','Employee','2024-01-15','Active'),
(4,'Sneha Patil','sneha@gmail.com','Employee','2024-01-18','Inactive'),
(5,'Rohit Gupta','rohit@gmail.com','Manager','2024-01-20','Active'),
(6,'Neha Joshi','neha@gmail.com','Employee','2024-01-22','Active'),
(7,'Karan Mehta','karan@gmail.com','Employee','2024-01-25','Active'),
(8,'Pooja Shah','pooja@gmail.com','Employee','2024-01-28','Inactive'),
(9,'Vikas Yadav','vikas@gmail.com','Manager','2024-02-01','Active'),
(10,'Anjali Desai','anjali@gmail.com','Employee','2024-02-05','Active'),
(11,'Ramesh Kumar','ramesh@gmail.com','Employee','2024-02-08','Active'),
(12,'Meena Nair','meena@gmail.com','Employee','2024-02-10','Active'),
(13,'Suresh Rao','suresh@gmail.com','Employee','2024-02-15','Inactive'),
(14,'Kavita Singh','kavita@gmail.com','Employee','2024-02-18','Active'),
(15,'Arjun Patel','arjun@gmail.com','Admin','2024-02-20','Active');

select * from users;

CREATE TABLE CLIENTS (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    industry VARCHAR(50),
    country VARCHAR(50),
    status VARCHAR(20)
);

INSERT INTO CLIENTS VALUES
(101,'TCS','IT','India','Active'),
(102,'Infosys','IT','India','Active'),
(103,'Amazon','E-Commerce','USA','Active'),
(104,'Wipro','IT','India','Inactive'),
(105,'Google','Technology','USA','Active'),
(106,'Capgemini','Consulting','France','Active'),
(107,'IBM','Technology','USA','Active'),
(108,'Accenture','Consulting','Ireland','Active');

select * from CLIENTS;

CREATE TABLE PROJECTS (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    client_id INT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
);

INSERT INTO PROJECTS VALUES
(201,'HR Management',101,'2024-01-15','2024-06-30',500000),
(202,'Payroll System',102,'2024-02-01','2024-08-15',700000),
(203,'E-Commerce Website',103,'2024-03-10','2024-10-20',1200000),
(204,'CRM Portal',101,'2024-04-01','2024-09-30',800000),
(205,'Inventory System',105,'2024-05-01','2024-12-31',950000),
(206,'Hospital App',106,'2024-02-10','2024-09-20',650000),
(207,'Banking Software',107,'2024-03-15','2024-11-30',1500000),
(208,'Student Portal',108,'2024-04-10','2024-12-15',550000),
(209,'Hotel Management',104,'2024-05-20','2024-11-20',450000),
(210,'Library System',102,'2024-06-01','2024-12-31',350000);

select * from PROJECTS;


CREATE TABLE TASKS (
    task_id INT PRIMARY KEY,
    project_id INT,
    assigned_to INT,
    task_status VARCHAR(30),
    hours_spent DECIMAL(5,2),
    FOREIGN KEY (project_id) REFERENCES PROJECTS(project_id),
    FOREIGN KEY (assigned_to) REFERENCES USERS(user_id)
);

INSERT INTO TASKS VALUES
(301,201,2,'Completed',20),
(302,201,3,'In Progress',15),
(303,202,4,'Pending',10),
(304,202,5,'Completed',30),
(305,203,6,'Completed',25),
(306,203,7,'In Progress',18),
(307,204,8,'Pending',12),
(308,205,9,'Completed',35),
(309,206,10,'Completed',22),
(310,207,11,'Pending',14),
(311,208,12,'Completed',27),
(312,209,13,'In Progress',19),
(313,210,14,'Completed',21),
(314,201,15,'Completed',16),
(315,202,2,'Pending',8),
(316,203,3,'Completed',24),
(317,204,4,'In Progress',13),
(318,205,5,'Completed',17),
(319,206,6,'Pending',11),
(320,207,7,'Completed',28),
(321,208,8,'Completed',26),
(322,209,9,'In Progress',20),
(323,210,10,'Pending',9),
(324,201,11,'Completed',18),
(325,202,12,'Completed',29),
(326,203,13,'Pending',7),
(327,204,14,'Completed',15),
(328,205,15,'In Progress',23),
(329,206,2,'Completed',19),
(330,207,3,'Pending',10),
(331,208,4,'Completed',22),
(332,209,5,'Completed',24),
(333,210,6,'In Progress',17),
(334,201,7,'Completed',30),
(335,202,8,'Pending',12),
(336,203,9,'Completed',16),
(337,204,10,'Completed',27),
(338,205,11,'In Progress',21),
(339,206,12,'Pending',13),
(340,207,13,'Completed',32);


select * from TASKS;

CREATE TABLE INVOICES (
    invoice_id INT PRIMARY KEY,
    project_id INT,
    invoice_date DATE,
    amount DECIMAL(12,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (project_id) REFERENCES PROJECTS(project_id)
);

INSERT INTO INVOICES VALUES
(401,201,'2024-06-30',500000,'Paid'),
(402,202,'2024-08-15',700000,'Pending'),
(403,203,'2024-10-20',1200000,'Paid'),
(404,204,'2024-09-30',800000,'Pending'),
(405,205,'2024-12-31',950000,'Paid'),
(406,206,'2024-09-20',650000,'Paid'),
(407,207,'2024-11-30',1500000,'Pending'),
(408,208,'2024-12-15',550000,'Paid'),
(409,209,'2024-11-20',450000,'Pending'),
(410,210,'2024-12-31',350000,'Paid'),
(411,201,'2024-07-15',100000,'Paid'),
(412,202,'2024-08-30',150000,'Pending'),
(413,203,'2024-09-25',200000,'Paid'),
(414,204,'2024-10-10',120000,'Pending'),
(415,205,'2024-11-05',180000,'Paid'),
(416,206,'2024-10-01',90000,'Paid'),
(417,207,'2024-12-01',250000,'Pending'),
(418,208,'2024-12-20',110000,'Paid');

select * from INVOICES;

-- 7. Display all active users.
select * 
from users
where status='Active';

-- 8. Find users created in the last 6 months.

SELECT *
FROM USERS
WHERE created_date >= curdate() - interval 6 month;

-- 9. Display projects that are currently running (end_date IS NULL).
SELECT *
FROM PROJECTS
WHERE end_date IS NULL;

--  10. Show total number of projects per client.
SELECT c.client_id,
       c.client_name,
       COUNT(p.project_id) AS total_projects
FROM CLIENTS c
JOIN PROJECTS p
ON c.client_id = p.client_id
GROUP BY c.client_id, c.client_name;

-- 11. Display client name and total project budget.
select
	  c.client_name,
       sum(p.budget) as total_budget
from clients c 
join projects p 
    on c.client_id = p.client_id
group by c.client_name;


-- 12. Show projects where budget is greater than average budget.
select budget
from projects
where budget > ( select avg(budget) from projects);


-- 13. List all tasks assigned to a particular user.

SELECT *
FROM TASKS
WHERE assigned_to = 2;

-- 16. Calculate total hours spent per project.
select task_status,count(*) as tot_tasks
from tasks
group by task_status;

-- 15. Find projects with no tasks assigned (LEFT JOIN + NULL).
SELECT p.*
FROM PROJECTS p
LEFT JOIN TASKS t
ON p.project_id = t.project_id
WHERE t.task_id IS NULL;

-- 16. Calculate total hours spent per project.
select Project_id,sum(hours_spent)
from tasks
group by project_id;

-- 17. Find the user who has worked the maximum hours.
select assigned_to, sum(hours_spent) as max_hours
from tasks
group by assigned_to
order by max_hours desc
limit 1;

-- 18. Display invoices which are unpaid.
select *
from INVOICES
where payment_status='Pending';

-- 19. Show total invoice amount per project.
select project_id,
        sum(amount) as total_amount 
from invoices
group by project_id;

-- 20. Find projects for which invoices are not generated.
select p.*
from projects p
left join invoices i on p.project_id=i.project_id
where i.project_id is null;

--  21. Display client-wise revenue (SUM of invoice amount).
select client_name,
			sum(i.amount) AS revenue
	from clients c
    join projects p on p.client_id=c.client_id
    join invoices i on p.project_id=i.project_id
    group by client_name;
    
-- 22. Show top 3 highest revenue generating clients.
SELECT c.client_name,
       SUM(i.amount) AS revenue
FROM CLIENTS c
JOIN PROJECTS p
ON p.client_id = c.client_id
JOIN INVOICES i
ON i.project_id = p.project_id
GROUP BY c.client_name
ORDER BY revenue DESC
LIMIT 3;
             
             
-- 23. Update project budget by increasing 10% for ongoing projects.
SET SQL_SAFE_UPDATES=0;

UPDATE PROJECTS
SET BUDGET=BUDGET*1.10
WHERE 	end_date is null;

-- 24. Mark invoices as 'PAID' where amount < 50,000.
update invoices 
set payment_status = 'paid'
where amount=50000;

select * from invoices;

-- 25. Delete users who are inactive for more than 2 years.
SET FOREIGN_KEY_CHECKS=0;

DELETE FROM USERS
WHERE STATUS='Inactive'
and created_date  < date_sub(curdate(), interval 2 year);


-- 26. Rename column hours_spent to effort_hours in TASKS table.
alter table tasks
rename column hours_spent to effort_hours;

-- 27. Add column priority to TASKS table.
alter table tasks
add column priority varchar(20);

-- 28. Modify budget column data type to BIGINT.
alter table projects
modify budget bigint;

desc PROJECTS;

-- 29. Display users who are not assigned to any task.
SELECT u.*
from users u
left join tasks t on u.user_id=t.assigned_to
where t.task_id is null;

-- 30. Show projects where total hours spent exceed 500 hours.
select project_id,
            sum(effort_hours) as exceed_hours
from tasks
group by project_id
having exceed_hours > 500;

-- 31. Identify clients who have more than 2 active projects.
select c.client_name, count(p.project_id) as total_project
from  clients c
join projects p on c.client_id=p.client_id
where p.end_date >= curdate()
group by c.client_name
having total_project >2;

-- 32. Display month-wise invoice count.
select month(invoice_date) as months,count(*) as month_count
from invoices
group by month(invoice_date);

-- 33. Find the highest invoice raised for each client.
select c.client_name, max(i.amount)  as high_amount
from client c
join projets p on c.client_id = p. client_id
join invoices i on p.project_id = i.project_id
group by c.client_name;

-- 34. Use UNION to list all user names and client names in one column.
select full_name as name from users
union
select client_name from clients;

-- 35. Show project duration in days using date arithmetic.
select project_id,
	   datediff(end_date,start_date) as duration
from projects;

-- 36. Logical: Find users working on multiple projects.
select  assigned_to, count(project_id) as mult_project
from tasks
group by assigned_to
having count(distinct project_id)>1;

-- 37. Logical: Find projects where all tasks are completed
select project_id
from TASKS
group by project_id
having count(*)=sum( case when   task_status = 'completed' then '1' else '0' end);

-- 38. Logical: Identify clients with projects but no invoices.
SELECT c.client_name
FROM clients c
JOIN projects p
ON p.client_id = c.client_id
LEFT JOIN invoices i
ON p.project_id = i.project_id
WHERE i.invoice_id IS NULL; 

-- 39. Advanced: Rank projects based on total invoice amount.
select project_id, sum(amount) as tot_amount,
rank() over (order by sum(amount)) as rnk
from invoices
group by project_id;

-- 40. Advanced: Find the percentage contribution of each project to total revenue
select project_id, sum(amount) as revenue,
(sum(amount)*100.0/(select sum(amount) from invoices)) as percentage
from invoices
group by project_id;



 


















