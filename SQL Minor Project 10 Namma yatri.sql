
create database namma_yatri;
use namma_yatri;

select * from assembly;
select * from duration;
select * from payment;
select * from trip_details;
select * from trips;




-- 1. Total Trips
-- Total number of trips recorded in the dataset.
SELECT COUNT(*) AS total_trips
FROM Trips;


-- 2. Duplicate Trips
-- Number of trips with duplicate IDs.
SELECT tripid, COUNT(*) AS times_repeated
FROM Trips
GROUP BY tripid
HAVING COUNT(*) > 1;


-- 3. Total Drivers
-- Total number of distinct drivers.
SELECT COUNT(DISTINCT driverid) AS total_drivers
FROM Trips;


-- 4. Total Earnings
-- Total earnings generated from all trips.
SELECT SUM(fare) AS total_earnings
FROM Trips;

-- 5. Total Completed Trips
-- Total number of completed trips.
SELECT SUM(end_ride) AS total_completed_trips
FROM Trip_details
WHERE end_ride = 1;


-- 6. Total Searches
-- Total searches that took place.
SELECT SUM(searches) AS total_searches
FROM Trip_details;


-- 7. Searches with Estimates
SELECT SUM(searches_got_estimate) AS searches_with_estimates
FROM Trip_details;


-- 8. Searches for Quotes
SELECT SUM(searches_for_quotes) AS searches_for_quotes
FROM Trip_details;

-- 9. Trips Cancelled by Driver
SELECT COUNT(*) AS trips_cancelled_by_driver
FROM Trip_details
WHERE driver_not_cancelled = 0;


-- 10. OTP Entered
SELECT SUM(otp_entered) AS total_otp_entries
FROM Trip_details;


-- 11. End Ride Total
SELECT SUM(end_ride) AS end_ride_total
FROM Trip_details;

-- 12. Average Distance Per Trip
SELECT AVG(distance) AS average_distance
FROM Trips;


-- 13. Average Fare Per Trip
SELECT AVG(fare) AS average_fare
FROM Trips;

-- 14. Total Distance Traveled
SELECT SUM(distance) AS total_distance
FROM Trips;


-- 15. Most Used Payment Method
SELECT p.Method, COUNT(*) AS times_used
FROM Trips t
JOIN Payment p ON t.faremethod = p.ID
GROUP BY p.Method
ORDER BY times_used DESC
LIMIT 1;


-- 16. Highest Payment through an Instrument

SELECT p.Method, SUM(t.fare) AS total_fare
FROM Trips t
JOIN Payment p ON t.faremethod = p.ID
GROUP BY p.Method
ORDER BY total_fare DESC
LIMIT 1;


-- 17. Locations with Most Trips
SELECT a.Assembly, COUNT(*) AS total_trips
FROM Trips t
JOIN Assembly a ON t.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY total_trips DESC
LIMIT 2;


-- 18. Top Earning Drivers
SELECT driverid, SUM(fare) AS total_earnings
FROM Trips
GROUP BY driverid
ORDER BY total_earnings DESC
LIMIT 5;


-- 19. Duration with Most Trips
SELECT d.Duration, COUNT(*) AS total_trips
FROM Trips t
JOIN Duration d ON t.duration = d.ID
GROUP BY d.Duration
ORDER BY total_trips DESC
LIMIT 1;


-- 20. Driver-Customer Pairs with Most Order
SELECT driverid, custid, COUNT(*) AS total_orders
FROM Trips
GROUP BY driverid, custid
ORDER BY total_orders DESC
LIMIT 1;


-- 21. Search to Estimate Rate
SELECT (SUM(searches_got_estimate) / SUM(searches)) * 100 AS estimate_rate_percent
FROM Trip_details;


-- 22. Area with Highest Trip in Each Duration
SELECT d.Duration, a.Assembly, cnt.total_trips
FROM (
    SELECT duration, loc_from, COUNT(*) AS total_trips
    FROM Trips
    GROUP BY duration, loc_from
) AS cnt
JOIN Duration d ON cnt.duration = d.ID
JOIN Assembly a ON cnt.loc_from = a.ID
WHERE cnt.total_trips = (
    SELECT MAX(cnt2.total_trips)
    FROM (
        SELECT duration, loc_from, COUNT(*) AS total_trips
        FROM Trips
        GROUP BY duration, loc_from
    ) AS cnt2
    WHERE cnt2.duration = cnt.duration
);


-- 23. Area-wise Fare, Cancellation, and Trips
-- Area with the highest total fare.
SELECT a.Assembly, SUM(t.fare) AS total_fare
FROM Trips t
JOIN Assembly a ON t.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY total_fare DESC
LIMIT 1;

-- Area with the highest number of driver cancellations.
SELECT a.Assembly, COUNT(*) AS driver_cancellations
FROM Trip_details td
JOIN Assembly a ON td.loc_from = a.ID
WHERE td.driver_not_cancelled = 0
GROUP BY a.Assembly
ORDER BY driver_cancellations DESC
LIMIT 1;

-- Area with the highest total number of trips.
SELECT a.Assembly, COUNT(*) AS total_trips
FROM Trips t
JOIN Assembly a ON t.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY total_trips DESC
LIMIT 1;


-- 24. Duration with Highest Trips and Fare
-- Duration with the highest number of trips.
SELECT d.Duration, COUNT(*) AS total_trips
FROM Trips t
JOIN Duration d ON t.duration = d.ID
GROUP BY d.Duration
ORDER BY total_trips DESC
LIMIT 1;

-- Duration with the highest total fare.
SELECT d.Duration, SUM(t.fare) AS total_fare
FROM Trips t
JOIN Duration d ON t.duration = d.ID
GROUP BY d.Duration
ORDER BY total_fare DESC
LIMIT 1;