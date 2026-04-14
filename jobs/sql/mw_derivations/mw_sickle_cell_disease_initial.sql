-- Derivation script for mw_sickle_cell_disease_initial
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-initial.ktr

DROP TABLE IF EXISTS mw_sickle_cell_disease_initial;
CREATE TABLE mw_sickle_cell_disease_initial (
  sickle_cell_disease__initial_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  diagnosis_date	 		date DEFAULT NULL,
  microscopy				varchar(255) DEFAULT NULL,
  microscopy_test_date 			date DEFAULT NULL,
  rapid_test				varchar(255) DEFAULT NULL,
  rapid_test_date 			date DEFAULT NULL,
  hb_electrophoresis			varchar(255) DEFAULT NULL,
  hb_electrophoresis_test_date 		date DEFAULT NULL,
  hiv_status 				varchar(255) DEFAULT NULL,
  hiv_test_date 			date DEFAULT NULL,
  art_start_date 			date DEFAULT NULL,
  parent 				varchar(255) DEFAULT NULL,
  sibling				varchar(255) DEFAULT NULL,
  referral_history_inpatient 		varchar(255) DEFAULT NULL,
  referral_history_ic3 			varchar(255) DEFAULT NULL,
  referral_history_opd 			varchar(255) DEFAULT NULL,
  referral_history_other 		varchar(255) DEFAULT NULL,
  referral_history_other_specify 	varchar(255) DEFAULT NULL,
  PRIMARY KEY (sickle_cell_disease__initial_visit_id)
);

INSERT INTO mw_sickle_cell_disease_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date antiretrovirals started' THEN o.value_date END) as art_start_date,
    MAX(CASE WHEN o.concept = 'PDC Reasons for referral' AND o.value_coded = 'Patient transfer in' THEN o.value_coded END) as referral_history_inpatient,
    MAX(CASE WHEN o.concept = 'PDC Reasons for referral' AND o.value_coded = 'OPD clinic' THEN o.value_coded END) as referral_history_opd,
    MAX(CASE WHEN o.concept = 'PDC Reasons for referral' AND o.value_coded = 'IC3' THEN o.value_coded END) as referral_history_ic3,
    MAX(CASE WHEN o.concept = 'Diagnosis date' THEN o.value_date END) as diagnosis_date,
    MAX(CASE WHEN o.concept = 'HIV status' THEN o.value_coded END) as hiv_status,
    MAX(CASE WHEN o.concept = 'HIV test date' THEN o.value_date END) as hiv_test_date,
    MAX(CASE WHEN o.concept = 'Parent relationship' THEN o.value_coded END) as parent,
    MAX(CASE WHEN o.concept = 'Sibling relationship' THEN o.value_coded END) as sibling,
    MAX(CASE WHEN o.concept = 'Microscopy' THEN o.value_coded END) as microscopy,
    MAX(CASE WHEN o.concept = 'Microscopy date' THEN o.value_date END) as microscopy_test_date,
    MAX(CASE WHEN o.concept = 'Rapid Testing' THEN o.value_coded END) as rapid_test,
    MAX(CASE WHEN o.concept = 'Rapid testing date' THEN o.value_date END) as rapid_test_date,
    MAX(CASE WHEN o.concept = 'HB electrophoresis' THEN o.value_coded END) as hb_electrophoresis,
    MAX(CASE WHEN o.concept = 'HB electrophoresis date' THEN o.value_date END) as hb_electrophoresis_test_date,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as referral_history_other_specify,
    MAX(CASE WHEN og.concept = 'Reasons for referral set' AND o.concept = 'PDC Reasons for referral' AND o.value_coded = 'Referred out' THEN 'Other' END) as referral_history_other
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
LEFT JOIN omrs_obs_group og ON og.obs_group_id = o.obs_group_id
WHERE e.encounter_type IN ('SICKLE_CELL_DISEASE_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;
