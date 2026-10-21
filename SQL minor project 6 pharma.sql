create database minorpro6;
use minorpro6;

select * from hcp;
select * from Patients;
select * from Prescriptions;

-- 1. Top doctors by prescriptions
SELECT h.hcp_id, h.hcp_name, COUNT(*) AS total_prescriptions
FROM Prescriptions p
JOIN HCP h ON h.hcp_id = p.hcp_id
GROUP BY h.hcp_id, h.hcp_name
ORDER BY total_prescriptions DESC;


-- 2. Patients visiting multiple doctors
SELECT p.patient_id, pa.patient_name, COUNT(DISTINCT p.hcp_id) AS doctors_visited
FROM Prescriptions p
JOIN Patients pa ON pa.patient_id = p.patient_id
GROUP BY p.patient_id, pa.patient_name
HAVING COUNT(DISTINCT p.hcp_id) > 1
ORDER BY doctors_visited DESC;


-- 3. Most used drug per doctor
WITH drug_counts AS (
    SELECT hcp_id, drug_name, COUNT(*) AS cnt,
           RANK() OVER (PARTITION BY hcp_id ORDER BY COUNT(*) DESC) AS rnk
    FROM Prescriptions
    GROUP BY hcp_id, drug_name
)
SELECT hcp_id, drug_name, cnt AS times_prescribed
FROM drug_counts
WHERE rnk = 1;


-- 4. Increasing prescription trend patients (cost rising with every consecutive prescription)
WITH ordered AS (
    SELECT patient_id, prescription_date, cost,
           LAG(cost) OVER (PARTITION BY patient_id ORDER BY prescription_date) AS prev_cost
    FROM Prescriptions
),
flagged AS (
    SELECT patient_id,
           CASE WHEN cost > prev_cost THEN 1 ELSE 0 END AS is_increase,
           CASE WHEN prev_cost IS NULL THEN 1 ELSE 0 END AS is_first
    FROM ordered
)
SELECT patient_id
FROM flagged
GROUP BY patient_id
HAVING SUM(is_increase) = COUNT(*) - SUM(is_first);  -- every non-first row increased


-- 5. Doctors treating multiple diseases
SELECT p.hcp_id, h.hcp_name, COUNT(DISTINCT pa.disease) AS disease_count
FROM Prescriptions p
JOIN Patients pa ON pa.patient_id = p.patient_id
JOIN HCP h ON h.hcp_id = p.hcp_id
GROUP BY p.hcp_id, h.hcp_name
HAVING COUNT(DISTINCT pa.disease) > 1
ORDER BY disease_count DESC;


-- 6. Avg cost per patient
SELECT patient_id, ROUND(AVG(cost), 2) AS avg_cost
FROM Prescriptions
GROUP BY patient_id
ORDER BY avg_cost DESC;


-- 7. Highest revenue doctor
SELECT h.hcp_id, h.hcp_name, SUM(p.cost) AS total_revenue
FROM Prescriptions p
JOIN HCP h ON h.hcp_id = p.hcp_id
GROUP BY h.hcp_id, h.hcp_name
ORDER BY total_revenue DESC
LIMIT 1;


-- 8. Monthly prescription trend
SELECT DATE_FORMAT(prescription_date, '%Y-%m') AS month, COUNT(*) AS total_prescriptions
FROM Prescriptions
GROUP BY DATE_FORMAT(prescription_date, '%Y-%m')
ORDER BY month;


-- 9. Repeated patients (more than one prescription)
SELECT patient_id, COUNT(*) AS prescription_count
FROM Prescriptions
GROUP BY patient_id
HAVING COUNT(*) > 1
ORDER BY prescription_count DESC;


-- 10. Declining doctor activity (last month vs previous month count fell)
WITH monthly AS (
    SELECT hcp_id, DATE_FORMAT(prescription_date, '%Y-%m') AS month, COUNT(*) AS cnt
    FROM Prescriptions
    GROUP BY hcp_id, DATE_FORMAT(prescription_date, '%Y-%m')
),
ranked AS (
    SELECT hcp_id, month, cnt,
           LAG(cnt) OVER (PARTITION BY hcp_id ORDER BY month) AS prev_cnt
    FROM monthly
)
SELECT hcp_id, month, cnt, prev_cnt
FROM ranked
WHERE prev_cnt IS NOT NULL AND cnt < prev_cnt
ORDER BY hcp_id, month;


-- 11. Common disease per city (most frequent disease per city)
WITH disease_counts AS (
    SELECT city, disease, COUNT(*) AS cnt,
           RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS rnk
    FROM Patients
    GROUP BY city, disease
)
SELECT city, disease AS most_common_disease, cnt
FROM disease_counts
WHERE rnk = 1;


-- 12. Drug trend over time
SELECT drug_name, DATE_FORMAT(prescription_date, '%Y-%m') AS month, COUNT(*) AS total
FROM Prescriptions
GROUP BY drug_name, DATE_FORMAT(prescription_date, '%Y-%m')
ORDER BY drug_name, month;


-- 13. Multi specialty patients (patient consulted doctors from 2+ specialties)
SELECT p.patient_id, COUNT(DISTINCT h.specialty) AS specialties_consulted
FROM Prescriptions p
JOIN HCP h ON h.hcp_id = p.hcp_id
GROUP BY p.patient_id
HAVING COUNT(DISTINCT h.specialty) > 1
ORDER BY specialties_consulted DESC;


-- 14. Rank doctors by revenue
SELECT hcp_id, SUM(cost) AS total_revenue,
       RANK() OVER (ORDER BY SUM(cost) DESC) AS revenue_rank
FROM Prescriptions
GROUP BY hcp_id
ORDER BY revenue_rank;


-- 15. Running total per doctor
SELECT hcp_id, prescription_date, cost,
       SUM(cost) OVER (PARTITION BY hcp_id ORDER BY prescription_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Prescriptions
ORDER BY hcp_id, prescription_date;


-- 16. Previous prescription cost (per patient, chronological)
SELECT patient_id, prescription_date, cost,
       LAG(cost) OVER (PARTITION BY patient_id ORDER BY prescription_date) AS previous_cost
FROM Prescriptions
ORDER BY patient_id, prescription_date;


-- 17. Cost difference (vs previous prescription for same patient)
SELECT patient_id, prescription_date, cost,
       cost - LAG(cost) OVER (PARTITION BY patient_id ORDER BY prescription_date) AS cost_difference
FROM Prescriptions
ORDER BY patient_id, prescription_date;


-- 18. High value prescriptions (above overall average cost)
SELECT *
FROM Prescriptions
WHERE cost > (SELECT AVG(cost) FROM Prescriptions)
ORDER BY cost DESC;


-- 19. High cost patients (total spend above overall average patient spend)
WITH patient_totals AS (
    SELECT patient_id, SUM(cost) AS total_spend
    FROM Prescriptions
    GROUP BY patient_id
)
SELECT patient_id, total_spend
FROM patient_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM patient_totals)
ORDER BY total_spend DESC;


-- 20. Drug revenue %
SELECT drug_name,
       SUM(cost) AS drug_revenue,
       ROUND(SUM(cost) * 100.0 / (SELECT SUM(cost) FROM Prescriptions), 2) AS revenue_pct
FROM Prescriptions
GROUP BY drug_name
ORDER BY revenue_pct DESC;


-- 21. Spike detection (cost more than double the drug's average cost)
WITH drug_avg AS (
    SELECT drug_name, AVG(cost) AS avg_cost
    FROM Prescriptions
    GROUP BY drug_name
)
SELECT p.*, d.avg_cost
FROM Prescriptions p
JOIN drug_avg d ON d.drug_name = p.drug_name
WHERE p.cost > 2 * d.avg_cost
ORDER BY p.cost DESC;


-- 22. Long gap patients (gap > 90 days between consecutive prescriptions)
WITH ordered AS (
    SELECT patient_id, prescription_date,
           LAG(prescription_date) OVER (PARTITION BY patient_id ORDER BY prescription_date) AS prev_date
    FROM Prescriptions
)
SELECT patient_id, prev_date, prescription_date,
       DATEDIFF(prescription_date, prev_date) AS gap_days
FROM ordered
WHERE prev_date IS NOT NULL
  AND DATEDIFF(prescription_date, prev_date) > 90
ORDER BY gap_days DESC;


-- 23. Active doctors monthly (distinct doctors who prescribed each month)
SELECT DATE_FORMAT(prescription_date, '%Y-%m') AS month, COUNT(DISTINCT hcp_id) AS active_doctors
FROM Prescriptions
GROUP BY DATE_FORMAT(prescription_date, '%Y-%m')
ORDER BY month;


-- 24. Weekday vs weekend prescriptions
SELECT
    CASE WHEN DAYOFWEEK(prescription_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*) AS total_prescriptions
FROM Prescriptions
GROUP BY day_type;


-- 25. Loyal patients (visited only ONE doctor, across 2+ prescriptions)
SELECT patient_id, COUNT(*) AS visits, COUNT(DISTINCT hcp_id) AS doctors_seen
FROM Prescriptions
GROUP BY patient_id
HAVING COUNT(DISTINCT hcp_id) = 1 AND COUNT(*) > 1
ORDER BY visits DESC;


-- 26. Patient doctor switch (sequence showing when a patient changed doctor)
WITH ordered AS (
    SELECT patient_id, hcp_id, prescription_date,
           LAG(hcp_id) OVER (PARTITION BY patient_id ORDER BY prescription_date) AS prev_hcp_id
    FROM Prescriptions
)
SELECT patient_id, prescription_date, prev_hcp_id, hcp_id AS new_hcp_id
FROM ordered
WHERE prev_hcp_id IS NOT NULL AND prev_hcp_id <> hcp_id
ORDER BY patient_id, prescription_date;


-- 27. Diverse drug doctors (doctors prescribing the most distinct drugs)
SELECT hcp_id, COUNT(DISTINCT drug_name) AS distinct_drugs
FROM Prescriptions
GROUP BY hcp_id
ORDER BY distinct_drugs DESC;


-- 28. Duplicate prescriptions (same patient, doctor, drug, date repeated)
SELECT hcp_id, patient_id, drug_name, prescription_date, COUNT(*) AS occurrences
FROM Prescriptions
GROUP BY hcp_id, patient_id, drug_name, prescription_date
HAVING COUNT(*) > 1;


-- 29. 30 day repeat patients (another prescription within 30 days of the previous one)
WITH ordered AS (
    SELECT patient_id, prescription_date,
           LAG(prescription_date) OVER (PARTITION BY patient_id ORDER BY prescription_date) AS prev_date
    FROM Prescriptions
)
SELECT DISTINCT patient_id
FROM ordered
WHERE prev_date IS NOT NULL
  AND DATEDIFF(prescription_date, prev_date) <= 30;


-- 30. Top specialty revenue
SELECT h.specialty, SUM(p.cost) AS total_revenue
FROM Prescriptions p
JOIN HCP h ON h.hcp_id = p.hcp_id
GROUP BY h.specialty
ORDER BY total_revenue DESC
LIMIT 1;
