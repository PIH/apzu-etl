-- Derivation script for mw_asthma_initial
-- Generated from Pentaho transform: import-into-mw-asthma-initial.ktr

DROP TABLE IF EXISTS mw_asthma_initial;
CREATE TABLE mw_asthma_initial (
  asthma_initial_visit_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  diagnosis_asthma 			varchar(255) DEFAULT NULL,
  diagnosis_date_asthma 		date DEFAULT NULL,
  diagnosis_copd 			varchar(255) DEFAULT NULL,
  diagnosis_date_copd 			date DEFAULT NULL,
  family_history_asthma 		varchar(255) DEFAULT NULL,
  family_history_copd 			varchar(255) DEFAULT NULL,
  hiv_status 				varchar(255) DEFAULT NULL,
  hiv_test_date 			date DEFAULT NULL,
  art_start_date 			date DEFAULT NULL,
  tb_status 				varchar(255) DEFAULT NULL,
  tb_year 				int DEFAULT NULL,
  chronic_dry_cough 			varchar(255) DEFAULT NULL,
  chronic_dry_cough_duration_in_months int DEFAULT NULL,
  chronic_dry_cough_age_at_onset 	int DEFAULT NULL,
  tb_contact 				varchar(255) DEFAULT NULL,
  tb_contact_date 			date DEFAULT NULL,
  cooking_indoor 			varchar(255) DEFAULT NULL,
  smoking_history 			varchar(255) DEFAULT NULL,
  last_smoking_history_date 		date DEFAULT NULL,
  second_hand_smoking 			varchar(255) DEFAULT NULL,
  second_hand_smoking_date 		date DEFAULT NULL,
  occupation 				varchar(255) DEFAULT NULL,
  occupation_exposure 			varchar(255) DEFAULT NULL,
  occupation_exposure_date 		date DEFAULT NULL,
  PRIMARY KEY (asthma_initial_visit_id)
);

INSERT INTO mw_asthma_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date antiretrovirals started' THEN o.value_date END) as art_start_date,
    MAX(CASE WHEN o.concept = 'Symptom present' AND o.value_coded = 'Dry cough' THEN o.value_coded END) as chronic_dry_cough,
    MAX(CASE WHEN o.concept = 'Age at cough onset' THEN o.value_numeric END) as chronic_dry_cough_age_at_onset,
    MAX(CASE WHEN o.concept = 'Duration of symptom in months' THEN o.value_numeric END) as chronic_dry_cough_duration_in_months,
    MAX(CASE WHEN o.concept = 'Location of cooking' AND o.value_coded = 'Indoors' THEN o.value_coded END) as cooking_indoor,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Asthma' THEN o.value_coded END) as diagnosis_asthma,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Chronic obstructive pulmonary disease' THEN o.value_coded END) as diagnosis_copd,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_asthma,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_copd,
    MAX(CASE WHEN o.concept = 'Asthma family history' THEN o.value_coded END) as family_history_asthma,
    MAX(CASE WHEN o.concept = 'COPD family history' THEN o.value_coded END) as family_history_copd,
    MAX(CASE WHEN o.concept = 'HIV status' THEN o.value_coded END) as hiv_status,
    MAX(CASE WHEN o.concept = 'HIV test date' THEN o.value_date END) as hiv_test_date,
    MAX(CASE WHEN o.concept = 'Exposure' AND o.value_coded = 'Contact with a TB+ person' THEN o.value_coded END) as tb_contact,
    MAX(CASE WHEN o.concept = 'Date of exposure' THEN o.value_date END) as tb_contact_date,
    MAX(CASE WHEN o.concept = 'TB status' THEN o.value_coded END) as tb_status,
    MAX(CASE WHEN o.concept = 'Year of Tuberculosis diagnosis' THEN o.value_numeric END) as tb_year,
    MAX(CASE WHEN o.concept = 'Location of cooking' AND o.value_coded = 'Outdoors' THEN o.value_coded END) as cooking_indoor,
    MAX(CASE WHEN o.concept = 'Last time person used tobacco' THEN o.value_date END) as last_smoking_history_date,
    MAX(CASE WHEN o.concept = 'Main activity' THEN o.value_coded END) as occupation,
    MAX(CASE WHEN o.concept = 'Exposure' AND o.value_coded = 'Occupational exposure' THEN o.value_coded END) as occupation_exposure,
    MAX(CASE WHEN o.concept = 'Date of exposure' THEN o.value_date END) as occupation_exposure_date,
    MAX(CASE WHEN o.concept = 'Exposure' AND o.value_coded = 'Exposed to second hand smoke?' THEN o.value_coded END) as second_hand_smoking,
    MAX(CASE WHEN o.concept = 'Date of exposure' THEN o.value_date END) as second_hand_smoking_date,
    MAX(CASE WHEN o.concept = 'Smoking history' AND o.value_coded = 'In the past' THEN o.value_coded END) as smoking_history
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('ASTHMA_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;