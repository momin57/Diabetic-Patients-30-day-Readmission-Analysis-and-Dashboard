SELECT *
FROM diabetes_readmission..diabetic_readmission_records;

SELECT COUNT(*) AS count
FROM diabetes_readmission..diabetic_readmission_records;

-- overall 30-day readmission rate

SELECT ROUND(COUNT(CASE WHEN readmitted_flag = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS readmission_rate_percent
FROM diabetes_readmission..diabetic_readmission_records;

-- Count of patients were readmitted within 30 days

SELECT COUNT(*) as count_of_readmitted_patients
FROM diabetes_readmission..diabetic_readmission_records
WHERE readmitted_flag = 1;

-- Average number of inpatient visits for readmitted vs. non-readmitted patients

SELECT (CASE WHEN readmitted_flag = 1 THEN 'readmitted' ELSE 'not readmitted' END) as readmission_status, ROUND(AVG(number_inpatient), 2) as avg_inpatients
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY readmitted_flag;

-- Average number of diagnoses per group

SELECT (CASE WHEN readmitted_flag = 1 THEN 'readmitted' ELSE 'not readmitted' END) as readmission_status, AVG(number_diagnoses) AS avg_diagnoses
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY readmitted_flag;

-- Average length of hospital stay (time_in_hospital) for readmitted vs. non-readmitted

SELECT (CASE WHEN readmitted_flag = 1 THEN 'readmitted' ELSE 'not readmitted' END) as readmission_status, 
AVG(time_in_hospital) AS avg_days_in_hospital
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY readmitted_flag;

-- How does the number of medications differ between readmitted and non-readmitted groups

SELECT (CASE WHEN readmitted_flag = 1 THEN 'readmitted' ELSE 'not readmitted' END) as readmission_status, COUNT(*) AS total_patients,
MIN(num_medications) AS min_medications, AVG(num_medications) AS avg_medications, MAX(num_medications) AS max_medications
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY readmitted_flag;

-- Top 10 patients with the highest inpatient visit count who were readmitted within 30 days

SELECT TOP 10 patient_nbr, number_inpatient, time_in_hospital, number_diagnoses
FROM diabetes_readmission..diabetic_readmission_records
WHERE readmitted_flag = 1
ORDER BY number_inpatient DESC;

-- Which medical specialties have the highest and lowest 30-day readmission rates

SELECT medical_specialty, COUNT(*) AS total_patients, SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS total_patients_readmitted,
ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate
FROM diabetes_readmission..diabetic_readmission_records
WHERE medical_specialty != 'Other Specialty'
GROUP BY medical_specialty
HAVING COUNT(*) > 50
ORDER BY readmission_rate DESC;

-- 30-day readmission rate by age group

SELECT age_group, ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY age_group
ORDER BY readmission_rate DESC;

-- readmission rate by insulin usage (No, Steady, Up, Down)

SELECT insulin, ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY insulin
ORDER BY readmission_rate DESC;

-- How does readmission rate vary for patients on metformin or with changes in medications

SELECT metformin, change, ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY metformin, change
ORDER BY metformin;

-- readmission rate by diabetes medication usage (diabetesMed)

SELECT diabetesMed, ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate
FROM diabetes_readmission..diabetic_readmission_records
GROUP BY diabetesMed
ORDER BY readmission_rate DESC;

-- How many patients fall into high-risk groups based on number of inpatient visits ≥ 2 and diagnoses ≥ 9?

SELECT COUNT(CASE WHEN readmitted_flag = 0 THEN 1 END) AS total_non_readmitted_high_risk_patients, 
COUNT(CASE WHEN readmitted_flag = 1 THEN 1 END) AS total_readmitted_high_risk_patients
FROM diabetes_readmission..diabetic_readmission_records
WHERE number_inpatient >= 2 AND number_diagnoses >= 9;

-- Which combination of risk factors (e.g., high meds + long stay) leads to the highest readmission rate?

--    Risk Factor     |      Threshold
-- `num_medications`  | ≥ 20 (polypharmacy)
-- `time_in_hospital` | ≥ 7 days (long stay)
-- `number_inpatient` | ≥ 2 (frequent visits)
-- `number_diagnoses` | ≥ 9 (multi-morbidity)

With RiskFlags AS
(
    SELECT *,
        CASE WHEN num_medications >= 20 THEN 'HighMeds' ELSE 'LowMeds' END AS meds_flag,
        CASE WHEN time_in_hospital >= 7 THEN 'LongStay' ELSE 'ShortStay' END AS stay_flag,
        CASE WHEN number_inpatient >= 2 THEN 'HighInpt' ELSE 'LowInpt' END AS inpatient_flag,
        CASE WHEN number_diagnoses >= 9 THEN 'HighDiag' ELSE 'LowDiag' END AS diag_flag
        FROM diabetes_readmission..diabetic_readmission_records
)

SELECT meds_flag, stay_flag, inpatient_flag, diag_flag,
COUNT(*) AS total_patients, SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS total_readmitted_patients,
ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate   
FROM RiskFlags
GROUP BY meds_flag, stay_flag, inpatient_flag, diag_flag
ORDER BY readmission_rate DESC;

-- Top 5 profiles with the highest risk of readmission (based on combinations of categorical + numerical)

-- profile based on the combination of categorical and numerical: num_medications, insulin, age_group, number_inpatient
-- Using the same threshold as the above query.

With HighRiskProfile AS
(
    SELECT readmitted_flag, age_group, insulin,
    CASE WHEN num_medications >= 20 THEN 'HighMeds' ELSE 'LowMeds' END AS meds_flag,
    CASE WHEN number_inpatient >= 2 THEN 'HighInpt' ELSE 'LowInpt' END AS inpatient_flag
    FROM diabetes_readmission..diabetic_readmission_records
)

SELECT age_group, insulin, meds_flag, inpatient_flag,
COUNT(*) AS total_patients,
SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS total_readmitted_patients,
ROUND(CAST(SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100/ COUNT(*), 2) AS readmission_rate  
FROM HighRiskProfile
GROUP BY age_group, insulin, meds_flag, inpatient_flag
HAVING COUNT(*) > 30
ORDER BY readmission_rate DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

