-- Derivation script for mw_ncd_other_initial
-- Generated from Pentaho transform: import-into-mw-ncd-other-initial.ktr

DROP TABLE IF EXISTS mw_ncd_other_initial;
CREATE TABLE mw_ncd_other_initial (
  ncd_other_initial_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  diagnosis_rheumatoid_arthritis varchar(255) DEFAULT NULL,
  diagnosis_date_rheumatoid_arthritis date DEFAULT NULL,
  diagnosis_cirrhosis varchar(255) DEFAULT NULL,
  diagnosis_date_cirrhosis date DEFAULT NULL,
  diagnosis_dvt_or_pe varchar(255) DEFAULT NULL,
  diagnosis_date_dvt_or_pe date DEFAULT NULL,
  diagnosis_sickle_cell_disease varchar(255) DEFAULT NULL,
  diagnosis_other varchar(255) DEFAULT NULL,
  diagnosis_date_other date DEFAULT NULL,
  hiv_status varchar(255) DEFAULT NULL,
  hiv_test_date date DEFAULT NULL,
  art_start_date date DEFAULT NULL,
  tb_status varchar(255) DEFAULT NULL,
  tb_start_date date DEFAULT NULL,
  comorbidities_hypertension varchar(255) DEFAULT NULL,
  comorbidities_diabetes varchar(255) DEFAULT NULL,
  comorbidities_chronic_kidney_disease varchar(255) DEFAULT NULL,
  comorbidities_other varchar(255) DEFAULT NULL,
  echo_test_result varchar(255) DEFAULT NULL,
  echo_test_date date DEFAULT NULL,
  ecg_test_result varchar(255) DEFAULT NULL,
  ecg_test_date date DEFAULT NULL,
  PRIMARY KEY (ncd_other_initial_visit_id)
);

INSERT INTO mw_ncd_other_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date antiretrovirals started' THEN o.value_date END) as art_start_date,
    MAX(CASE WHEN o.concept = 'Current opportunistic infection or comorbidity, confirmed or presumed' AND o.value_coded = 'Chronic kidney disease' THEN o.value_coded END) as comorbidities_chronic_kidney_disease,
    MAX(CASE WHEN o.concept = 'Current opportunistic infection or comorbidity, confirmed or presumed' AND o.value_coded = 'Diabetes' THEN o.value_coded END) as comorbidities_diabetes,
    MAX(CASE WHEN o.concept = 'Current opportunistic infection or comorbidity, confirmed or presumed' AND o.value_coded = 'Hypertension' THEN o.value_coded END) as comorbidities_hypertension,
    MAX(CASE WHEN o.concept = 'Other diagnosis' THEN o.value_text END) as comorbidities_other,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Restrictive cardiomyopathy' THEN o.value_coded END) as diagnosis_cirrhosis,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_other,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_cirrhosis,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_dvt_or_pe,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_rheumatoid_arthritis,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_sickle_cell_disease,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Deep vein thrombosis' THEN o.value_coded END) as diagnosis_dvt_or_pe,
    MAX(CASE WHEN o.concept = 'Other diagnosis' THEN o.value_text END) as diagnosis_other,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Rheumatoid arthritis' THEN o.value_coded END) as diagnosis_rheumatoid_arthritis,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Sickle cell disease' THEN o.value_coded END) as diagnosis_sickle_cell_disease,
    MAX(CASE WHEN o.concept = 'Date of general test' THEN o.value_date END) as ecg_test_date,
    MAX(CASE WHEN o.concept = 'Electrocardiogram diagnosis' THEN o.value_coded END) as ecg_test_result,
    MAX(CASE WHEN o.concept = 'Date of general test' THEN o.value_date END) as echo_test_date,
    MAX(CASE WHEN o.concept = 'ECHO imaging result' THEN o.value_text END) as echo_test_result,
    MAX(CASE WHEN o.concept = 'HIV status' THEN o.value_coded END) as hiv_status,
    MAX(CASE WHEN o.concept = 'HIV test date' THEN o.value_date END) as hiv_test_date,
    MAX(CASE WHEN o.concept = 'Tuberculosis diagnosis date' THEN o.value_date END) as tb_start_date,
    MAX(CASE WHEN o.concept = 'TB status' THEN o.value_coded END) as tb_status
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NCD_OTHER_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;