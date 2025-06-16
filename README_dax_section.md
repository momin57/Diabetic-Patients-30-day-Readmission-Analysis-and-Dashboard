---

## 🧮 DAX Measures Used in Power BI

This project includes several custom DAX measures to support visualizations and KPI cards in Power BI. Below are key examples:

### 1. **30-Day Readmission Count**
```dax
Readmitted Patients =
CALCULATE(
    COUNTROWS(diabetic_readmission_records),
    diabetic_readmission_records[readmitted_flag] = 1
)
```

### 2. **Total Patients**
```dax
Total Patients = COUNTROWS(diabetic_readmission_records)
```

### 3. **Readmission Rate (%)**
```dax
Readmission Rate (%) =
DIVIDE(
    [Readmitted Patients],
    [Total Patients],
    0
)
```

### 4. **Risk Profile Share of Readmitted Patients**
```dax
Readmitted Patient Share (%) :=
VAR GroupReadmitted =
    CALCULATE(COUNTROWS(diabetic_readmission_records), diabetic_readmission_records[readmitted_flag] = 1)
VAR TotalReadmitted =
    CALCULATE(
        COUNTROWS(diabetic_readmission_records),
        diabetic_readmission_records[readmitted_flag] = 1,
        REMOVEFILTERS(
            diabetic_readmission_records[meds_flag],
            diabetic_readmission_records[inpt_flag],
            diabetic_readmission_records[diag_flag]
        )
    )
RETURN
DIVIDE(GroupReadmitted, TotalReadmitted, 0)
```

### 5. **Calculated Columns (for flag creation)**
```dax
meds_flag = IF(diabetic_readmission_records[num_medications] >= 20, "HighMeds", "LowMeds")
inpt_flag = IF(diabetic_readmission_records[number_inpatient] >= 2, "HighInpt", "LowInpt")
diag_flag = IF(diabetic_readmission_records[number_diagnoses] >= 9, "HighDiag", "LowDiag")
```

### 6. **Diagnosis Grouping Column**
```dax
diag_category = 
VAR diag_val = diabetic_readmission_records[diag_1]
VAR diag_num = IFERROR(VALUE(diag_val), BLANK())
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(diag_val), "Unknown",
        LEFT(diag_val, 1) = "V", "Health Services Factors",
        LEFT(diag_val, 1) = "E", "External Causes of Injury",
        diag_val = "Uncoded", "Uncoded",
        NOT ISBLANK(diag_num) && diag_num >= 1 && diag_num <= 139, "Infectious & Parasitic Diseases",
        diag_num >= 140 && diag_num <= 239, "Neoplasms",
        diag_num >= 240 && diag_num <= 279, "Endocrine & Metabolic",
        diag_num >= 280 && diag_num <= 289, "Blood Diseases",
        diag_num >= 290 && diag_num <= 319, "Mental Disorders",
        diag_num >= 320 && diag_num <= 389, "Nervous System",
        diag_num >= 390 && diag_num <= 459, "Circulatory System",
        diag_num >= 460 && diag_num <= 519, "Respiratory System",
        diag_num >= 520 && diag_num <= 579, "Digestive System",
        diag_num >= 580 && diag_num <= 629, "Genitourinary System",
        diag_num >= 630 && diag_num <= 679, "Pregnancy & Childbirth",
        diag_num >= 680 && diag_num <= 709, "Skin & Subcutaneous",
        diag_num >= 710 && diag_num <= 739, "Musculoskeletal System",
        diag_num >= 740 && diag_num <= 759, "Congenital Anomalies",
        diag_num >= 760 && diag_num <= 779, "Perinatal Conditions",
        diag_num >= 780 && diag_num <= 799, "Symptoms & Ill-defined",
        diag_num >= 800 && diag_num <= 999, "Injury & Poisoning",
        "Other/Unknown"
    )
```

These measures support KPI cards, matrix breakdowns, and field parameter-based visuals within the Power BI dashboard.

---