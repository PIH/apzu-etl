-- Derivation script for mw_diabetes_hypertension_annual_lab_tests
-- Generated from Pentaho transform: import-into-mw-diabetes-hypertension-annual-lab-tests.ktr

DROP TABLE IF EXISTS mw_diabetes_hypertension_annual_lab_tests;
CREATE TABLE mw_diabetes_hypertension_annual_lab_tests (
  diabetes_hypertension_annual_lab_tests_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  ecg					varchar(255) DEFAULT NULL,
  creatinine				varchar(255) DEFAULT NULL,
  lipid_profile			varchar(255) DEFAULT NULL,
  fundoscopy				varchar(255) DEFAULT NULL,
  PRIMARY KEY (diabetes_hypertension_annual_lab_tests_id)
);

INSERT INTO mw_diabetes_hypertension_annual_lab_tests
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Creatinine' THEN o.value_numeric END) as creatinine,
    MAX(CASE WHEN o.concept = 'Fundoscopy' THEN o.value_text END) as fundoscopy,
    MAX(CASE WHEN o.concept = 'Electrocardiogram' THEN o.value_text END) as ecg,
    MAX(CASE WHEN o.concept = 'Lipid profile' THEN o.value_coded END) as lipid_profile
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('ANNUAL DIABETES HYPERTENSION LAB TESTS')
GROUP BY e.patient_id, e.encounter_date, e.location;