# 📊 Diabetic Patients 30-Day Readmission Analysis & Dashboard

This project investigates the clinical and systemic factors contributing to **30-day hospital readmission** among diabetic patients using the **UCI Diabetes 130-US Hospitals dataset**.

---

## 🎯 Objective

To identify patterns and risk factors that influence why diabetic patients are readmitted within 30 days, and to visualize those insights for stakeholders using Power BI, Python, and SQL.

---

## 📁 Dataset

- Source: [UCI Machine Learning Repository – Diabetes 130-US Hospitals](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008)
- 100,000+ de-identified hospital encounters between 1999–2008 for diabetic patients

---

## 🛠 Tools Used

| Stage        | Tool(s) Used                                   |
|--------------|------------------------------------------------|
| Data Cleaning/EDA | Python (Pandas, Seaborn, Matplotlib)   |
| Storage & Analysis | SQL Server Management Studio (SSMS)     |
| Visualization | Power BI                                     |
| Deployment | GitHub Portfolio                                |

---

## 🔄 Workflow

1. Cleaned messy Excel data in **Python** (handled missing values, grouped diagnosis codes, created age groups, etc.)
2. Performed **Exploratory Data Analysis (EDA)** and statistical tests (Chi-Square & t-tests)
3. Stored processed dataset into **SQL Server** and wrote advanced SQL queries to answer KPIs
4. Developed an **interactive Power BI dashboard** using custom DAX measures and visuals

---

## 📌 Key Project Steps

- Cleaned and pre-processed 100,000+ hospital records using Pandas
- Created flags based on thresholds for:
  - `num_medications` (polypharmacy)
  - `time_in_hospital` (long stay)
  - `number_inpatient` (frequent admissions)
  - `number_diagnoses` (multimorbidity)
- Conducted:
  - Chi-square tests on categorical variables
  - T-tests on numerical variables
  - Correlation analysis and boxplots
- Answered 15+ KPI questions using SQL (full list in repo)
- Built a detailed Power BI dashboard with DAX logic and slicers
- Converted diagnosis codes into ICD-9 clinical categories using `diag_1`, `diag_2`, `diag_3`

---

## 🔍 Detailed Findings

### 1. 🧓 Age-Related Patterns
- The **Senior age group (60–70 years)** accounts for the highest number of readmissions.
- Combined with **Middle Aged and Elderly**, older patients dominate the readmitted population.

💡 **Insight**: Age-related complications or comorbidities likely increase readmission risk.

### 2. 💊 Medication Behavior & Changes
- A large group of patients (4,020) had **no medication change** but were on **metformin**.
- Patients with changes in medication (`Up` or `Down`) may indicate **clinical instability**.

💡 **Insight**: Medication adjustment behavior, especially involving **metformin**, is a strong risk signal.

### 3. 💉 Insulin Usage
- Most patients were under **'Steady'** or **'No insulin'** groups.
- However, a significant portion of readmissions came from those with insulin marked **'Up' or 'Down'**.

💡 **Insight**: Insulin titration or lack of stabilization could reflect poor glucose control and risk of readmission.

### 4. 🏥 Medical Specialty Impact
- **Internal Medicine** had the highest readmission count (1,646), followed by **General Practice** and **Emergency/Trauma** specialties.

💡 **Insight**: Certain specialties handle more complex or chronic conditions, increasing risk post-discharge.

### 5. 🚫 Diabetes Medication Status
- Around **80% of readmitted patients were not on diabetes-specific medications** at the time of visit.

💡 **Insight**: Lack of active diabetes management may correlate with poorer clinical outcomes.

### 6. 🧾 Diagnosis-Based Findings (diag_1, diag_2, diag_3)

#### 🔹 Circulatory System Disorders Dominate
- Most common diagnosis group across all levels:
  - `diag_1`: 3,474 cases
  - `diag_2`: 3,462 cases
  - `diag_3`: 3,203 cases

📌 **Insight**: Cardiovascular issues (e.g., hypertension, heart failure) are the strongest clinical co-conditions for readmission.

#### 🔹 Endocrine & Metabolic Disorders Are Consistently 2nd
- High frequency in all diagnosis fields:
  - `diag_1`: 1,456
  - `diag_2`: 2,275
  - `diag_3`: 2,749

📌 **Insight**: Poor chronic diabetes control appears across primary and secondary diagnoses.

#### 🔹 Respiratory and Digestive System Conditions
- Appear mostly in `diag_2` and `diag_3` (e.g., pneumonia, GERD).

📌 **Insight**: These systems may be indirectly impacted by diabetes and contribute to complex readmission cases.

#### 🔹 Symptoms & Ill-Defined Conditions
- Common in `diag_2` and `diag_3`.

📌 **Insight**: Many readmitted patients present with vague, unstable conditions — indicating **diagnostic or follow-up gaps**.

#### 🔹 Genitourinary & Skin Disorders
- Consistently present in secondary diagnoses.

📌 **Insight**: Likely linked to common diabetes complications like **UTIs or ulcers**.

### 7. ⚠️ Risk Profile Combination Analysis

Using matrix analysis from:
``meds_flag + inpt_flag + diag_flag``

- The group **LowMeds + HighInpt + LowDiag** accounts for the **largest share of readmissions** (**50.81%**).
- `HighInpt` = frequent past hospitalizations  
- `LowDiag` = possibly under-diagnosed or under-documented patients

💡 **Insight**: Patients with frequent hospitalizations, even without high diagnosis counts, are at **critical risk**.

---

### ✅ Final Clinical Recommendation

> Focus post-discharge care on:
> - **Senior and elderly patients**
> - Those with **recent insulin or medication changes**
> - Patients with **circulatory or endocrine diagnoses**
> - Those flagged as **HighInpt** even with low diagnosis counts

🧠 **Summary**:  
Most diabetic patients readmitted within 30 days suffer from **multisystem instability**, with dominant diagnoses in the **circulatory** and **endocrine/metabolic** categories, often accompanied by **ill-defined symptoms** or **secondary complications** in respiratory, digestive, or genitourinary systems.

➡️ **Actionable strategies** include risk stratification, better discharge planning, and targeted follow-ups.


---

## 🧮 DAX Measures Used (Power BI)

- `Readmitted Patient Count`
- `Readmission Rate (%)`
- `Readmitted Patient Share (%)`
- Custom columns like `meds_flag`, `inpt_flag`, `stay_flag`, `diag_flag`
- ICD-9 based `diag_1_category`, `diag_2_category`, `diag_3_category`

📂 Refer to `README_dax_section.md` or Power BI `.pbix` for full logic.

---

## 📷 Dashboard Preview

![Dashboard](Dashboard.png)

---

## ❓ KPI Questions

> We explored over **15+ targeted questions** such as:
- Readmission rate by age, diagnosis, medications, insulin usage
- High-risk profile identification
- Diagnosis categories most linked with readmissions

📁 For full list of KPIs, see `Diabetes KPI Questions.pdf` in this repo.

---

## 🧠 Conclusion

This analysis shows that **diabetic readmissions within 30 days** are driven by:
- Unstable chronic conditions (like circulatory & endocrine issues)
- Polypharmacy and inpatient history
- Lack of proper medication adjustments
- Gaps in diagnosis or follow-up (as seen in vague symptoms)

📊 The final dashboard visualizes these findings using slicers, KPIs, matrix views, and diagnosis-based charts.

---

## 📜 License

This project is open-source and available under the MIT License.

---
