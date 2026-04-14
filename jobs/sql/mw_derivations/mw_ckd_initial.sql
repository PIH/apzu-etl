-- Derivation script for mw_ckd_initial
-- Generated from Pentaho transform: import-into-mw-ckd-initial.ktr

DROP TABLE IF EXISTS mw_ckd_initial;
CREATE TABLE mw_ckd_initial (
  ckd_initial_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  presumed_etiology_hypertension varchar(255) DEFAULT NULL,
  presumed_etiology_diabetes varchar(255) DEFAULT NULL,
  presumed_etiology_hiv varchar(255) DEFAULT NULL,
  presumed_etiology_nephrotic varchar(255) DEFAULT NULL,
  presumed_etiology_drugs varchar(255) DEFAULT NULL,
  presumed_etiology_other varchar(255) DEFAULT NULL,
  presumed_etiology_other_2 varchar(255) DEFAULT NULL,
  presumed_etiology_unknown varchar(255) DEFAULT NULL,
  presumed_etiology_diagnosis_date date DEFAULT NULL,
  diagnosis_chf varchar(255) DEFAULT NULL,
  diagnosis_date_chf date DEFAULT NULL,
  diagnosis_hypertension varchar(255) DEFAULT NULL,
  diagnosis_date_hypertension date DEFAULT NULL,
  diagnosis_diabetes varchar(255) DEFAULT NULL,
  diagnosis_date_diabetes date DEFAULT NULL,
  diagnosis_other varchar(255) DEFAULT NULL,
  diagnosis_date_other date DEFAULT NULL,
  hiv_status varchar(255) DEFAULT NULL,
  hiv_test_date date DEFAULT NULL,
  art_start_date date DEFAULT NULL,
  tb_status varchar(255) DEFAULT NULL,
  tb_date date DEFAULT NULL,
  history_of_dialysis varchar(255) DEFAULT NULL,
  date_of_dialysis date DEFAULT NULL,
  PRIMARY KEY (ckd_initial_visit_id)
);

INSERT INTO mw_ckd_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date antiretrovirals started' THEN o.value_date END) as art_start_date,
    MAX(CASE WHEN o.concept = 'Date of dialysis' THEN o.value_date END) as date_of_dialysis,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Diabetes' THEN o.value_coded END) as diagnosis_diabetes,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Hypertension' THEN o.value_coded END) as diagnosis_hypertension,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Other non-coded' THEN o.value_coded END) as diagnosis_other,
    MAX(CASE WHEN o.concept = 'Chronic care diagnosis' AND o.value_coded = 'Heart failure' THEN o.value_coded END) as diagnosis_chf,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_chf,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_diabetes,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_hypertension,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date_other,
    MAX(CASE WHEN o.concept = 'History of dialysis' THEN o.value_text END) as history_of_dialysis,
    MAX(CASE WHEN o.concept = 'HIV status' THEN o.value_coded END) as hiv_status,
    MAX(CASE WHEN o.concept = 'HIV test date' THEN o.value_date END) as hiv_test_date,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' AND o.value_coded = 'Diabetes' THEN o.value_coded END) as presumed_etiology_diabetes,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as presumed_etiology_diagnosis_date,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' THEN o.value_coded END) as presumed_etiology_drugs,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' AND o.value_coded = 'Human immunodeficiency virus' THEN o.value_coded END) as presumed_etiology_hiv,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' AND o.value_coded = 'Hypertension' THEN o.value_coded END) as presumed_etiology_hypertension,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' AND o.value_coded = 'Nephropathy' THEN o.value_coded END) as presumed_etiology_nephrotic,
    MAX(CASE WHEN o.concept = 'drugs' THEN o.value_text END) as presumed_etiology_other,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' AND o.value_coded = 'Other' THEN o.value_coded END) as presumed_etiology_other_2,
    MAX(CASE WHEN o.concept = 'Presumed chronic kidney disease etiology' AND o.value_coded = 'Unknown cause' THEN o.value_coded END) as presumed_etiology_unknown,
    MAX(CASE WHEN o.concept = 'Tuberculosis diagnosis date' THEN o.value_date END) as tb_date,
    MAX(CASE WHEN o.concept = 'TB status' THEN o.value_coded END) as tb_status
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('CKD_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;