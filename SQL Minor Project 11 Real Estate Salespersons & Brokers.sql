use real_stat;


create database real_stat;
select * from  real_stat;



-- 1. Retrieve basic information about the dataset.
SELECT * FROM real_stat
LIMIT 10;

SELECT COUNT(*) AS total_records
FROM real_stat;


-- 2. Get an overview of license types and their counts.
SELECT `License Type`, COUNT(*) AS total_licenses
FROM real_stat
GROUP BY `License Type`;

-- 3. License Holder Analysis - Identify the top license holders by license count.
SELECT `License Holder Name`, COUNT(*) AS total_licenses
FROM real_stat
GROUP BY `License Holder Name`
ORDER BY total_licenses DESC
LIMIT 10;


-- 4. Geographic Analysis - Explore the distribution of businesses across states.
SELECT `Business State`, COUNT(*) AS total_businesses
FROM real_stat
GROUP BY `Business State`;


-- 5. Determine the top cities with the most licenses.
SELECT `Business City`, COUNT(*) AS total_licenses
FROM real_stat
GROUP BY `Business City`
ORDER BY total_licenses DESC
LIMIT 10;

-- 6. License Expiration Analysis.
SELECT YEAR(`License Expiration Date`) AS expiration_year, COUNT(*) AS total_licenses
FROM real_stat
GROUP BY expiration_year
ORDER BY expiration_year;


-- 7. Analyze licenses expiring in the next 60 days.
SELECT *
FROM real_stat
WHERE `License Expiration Date` BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 60 DAY);


-- 8. Detailed License Holder Analysis - Examine licenses held by a specific license holder.
-- (Replace 'AUER JANET' with the name you want to check)
SELECT *
FROM real_stat
WHERE `License Holder Name` = 'AUER JANET';


-- 9. Compare license counts for multiple license holders.
-- (Replace the names inside IN(...) with the ones you want to compare)
SELECT `License Holder Name`, COUNT(*) AS total_licenses
FROM real_stat
WHERE `License Holder Name` IN ('AUER JANET', 'AVANT YVONNE D')
GROUP BY `License Holder Name`;


-- 10. Additional Insights - Identify license holders with licenses across multiple businesses.
SELECT `License Holder Name`, COUNT(DISTINCT `Business Name`) AS total_businesses
FROM real_stat
GROUP BY `License Holder Name`
HAVING COUNT(DISTINCT `Business Name`) > 1;


-- 11. Ranking of License Holders by License Expiration Date within each business.
SELECT
    `Business Name`,
    `License Holder Name`,
    `License Expiration Date`,
    RANK() OVER (
        PARTITION BY `Business Name`
        ORDER BY `License Expiration Date`
    ) AS expiration_rank
FROM real_stat;


-- 12. Get businesses with the maximum number of license holders.
SELECT `Business Name`, COUNT(*) AS total_license_holders
FROM real_stat
GROUP BY `Business Name`
ORDER BY total_license_holders DESC
LIMIT 1;

-- 13. Rank businesses based on the number of licenses they hold.
SELECT `Business Name`, COUNT(*) AS total_licenses
FROM real_stat
GROUP BY `Business Name`
ORDER BY total_licenses DESC;


-- 14. Calculate the running total of licenses issued for each business.
SELECT
    `Business Name`,
    `License Expiration Date`,
    COUNT(*) OVER (
        PARTITION BY `Business Name`
        ORDER BY `License Expiration Date`
    ) AS running_total_licenses
FROM real_stat
ORDER BY `Business Name`, `License Expiration Date`;