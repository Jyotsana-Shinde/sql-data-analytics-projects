create database train;
use train;

select * from train;


-- 1. Calculate the average age of passengers.
SELECT AVG(Age) AS average_age
FROM train;


-- 2. Retrieve passengers who survived.
SELECT *
FROM train
WHERE Survived = 1;


-- 3. Calculate the average fare by passenger class.
SELECT Pclass, AVG(Fare) AS average_fare
FROM train
GROUP BY Pclass;


-- 4. Retrieve passengers who were female and under 18 years old.
SELECT *
FROM train
WHERE Sex = 'female'
AND Age < 18;


-- 5. Count the number of passengers by embarkation port.
SELECT Embarked, COUNT(*) AS total_passengers
FROM train
GROUP BY Embarked;


-- 6. Retrieve passengers with the highest fare.
SELECT *
FROM train
WHERE Fare = (SELECT MAX(Fare) FROM train);

-- 7. Calculate the survival rate for each passenger class.
SELECT Pclass,
       SUM(Survived) AS total_survived,
       COUNT(*) AS total_passengers,
       (SUM(Survived) / COUNT(*)) * 100 AS survival_rate_percent
FROM train
GROUP BY Pclass;


-- 8. Identify the most common age among male passengers.
SELECT Age, COUNT(*) AS total
FROM train
WHERE Sex = 'male'
GROUP BY Age
ORDER BY total DESC
LIMIT 1;

-- 9. Identify the top 5 most common ages among passengers.
SELECT Age, COUNT(*) AS total
FROM train
GROUP BY Age
ORDER BY total DESC
LIMIT 5;

-- 10. Find the passenger(s) with the longest name.
SELECT *
FROM train
WHERE LENGTH(Name) = (SELECT MAX(LENGTH(Name)) FROM train);


-- 11. Calculate the average age of male passengers who survived.
SELECT AVG(Age) AS average_age
FROM train
WHERE Sex = 'male'
AND Survived = 1;


-- 12. Identify passengers who were likely part of a family (same last name).
SELECT SUBSTRING_INDEX(Name, ',', 1) AS last_name, COUNT(*) AS family_members
FROM train
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 13. Calculate the percentage of passengers who survived by embarkation port.
SELECT Embarked,
       SUM(Survived) AS total_survived,
       COUNT(*) AS total_passengers,
       (SUM(Survived) / COUNT(*)) * 100 AS survival_percent
FROM train
GROUP BY Embarked;

-- 14. Calculate the average age of passengers by gender.
SELECT Sex, AVG(Age) AS average_age
FROM train
GROUP BY Sex;

-- 15. Calculate the survival rate for each combination of gender and class.
SELECT Sex, Pclass,
       SUM(Survived) AS total_survived,
       COUNT(*) AS total_passengers,
       (SUM(Survived) / COUNT(*)) * 100 AS survival_rate_percent
FROM train
GROUP BY Sex, Pclass;

-- 16. Find the passengers with the highest fare in each class.
SELECT *
FROM train
WHERE Pclass = 1
AND Fare = (SELECT MAX(Fare) FROM train WHERE Pclass = 1);

SELECT *
FROM train
WHERE Pclass = 2
AND Fare = (SELECT MAX(Fare) FROM train WHERE Pclass = 2);

SELECT *
FROM train
WHERE Pclass = 3
AND Fare = (SELECT MAX(Fare) FROM train WHERE Pclass = 3);


-- 17. Calculate the number of passengers who were traveling alone
--     (no siblings, spouses, parents, or children).
SELECT COUNT(*) AS passengers_traveling_alone
FROM train
WHERE SibSp = 0
AND Parch = 0;


-- 18. Identify passengers who paid a fare higher than the average fare for their class.
SELECT *
FROM train
WHERE Pclass = 1
AND Fare > (SELECT AVG(Fare) FROM train WHERE Pclass = 1);

SELECT *
FROM train
WHERE Pclass = 2
AND Fare > (SELECT AVG(Fare) FROM train WHERE Pclass = 2);

SELECT *
FROM train
WHERE Pclass = 3
AND Fare > (SELECT AVG(Fare) FROM train WHERE Pclass = 3);


-- 19. Calculate the average fare paid by passengers who survived vs. those who did not.
SELECT Survived, AVG(Fare) AS average_fare
FROM train
GROUP BY Survived;

-- 20. Calculate the average age of passengers who had siblings, spouses,
--     parents, or children on board.
SELECT AVG(Age) AS average_age
FROM train
WHERE SibSp > 0
OR Parch > 0;