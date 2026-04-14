-- Derivation script for mw_poc_eid
-- Generated from Pentaho transform: import-into-mw-poc-eid.ktr

DROP TABLE IF EXISTS mw_poc_eid;
CREATE TABLE mw_poc_eid (
  poc_eid_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  creator varchar(255) DEFAULT NULL,
  date_of_blood_sample DATE,
  hiv_test_type VARCHAR(255),
  reason_for_no_sample_eid VARCHAR(255),
  result_of_hiv_test VARCHAR(255),
  hiv_test_time_period VARCHAR(255),
  age VARCHAR(13),
  units_of_age_of_child VARCHAR(255),
  lab_test_serial_number VARCHAR(255),
  date_of_returned_result VARCHAR(255),
  date_result_to_guardian DATE,
  reason_for_testing_coded VARCHAR(255),
  PRIMARY KEY (poc_eid_visit_id)
);

INSERT INTO mw_poc_eid
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Age' THEN o.value_numeric END) as age,
    MAX(CASE WHEN o.concept = 'Date of blood sample' THEN o.value_date END) as date_of_blood_sample,
    MAX(CASE WHEN o.concept = 'Date of returned result' THEN o.value_date END) as date_of_returned_result,
    MAX(CASE WHEN o.concept = 'Date result to guardian' THEN o.value_date END) as date_result_to_guardian,
    MAX(CASE WHEN o.concept = 'HIV test time period' THEN o.value_coded END) as hiv_test_time_period,
    MAX(CASE WHEN o.concept = 'HIV test type' THEN o.value_coded END) as hiv_test_type,
    MAX(CASE WHEN o.concept = 'Lab test serial number' THEN o.value_text END) as lab_test_serial_number,
    MAX(CASE WHEN o.concept = 'Reason for no sample' THEN o.value_coded END) as reason_for_no_sample_eid,
    MAX(CASE WHEN o.concept = 'Reason for testing (coded)' THEN o.value_coded END) as reason_for_testing_coded,
    MAX(CASE WHEN o.concept = 'Result of HIV test' THEN o.value_coded END) as result_of_hiv_test,
    MAX(CASE WHEN o.concept = 'Units of age of child' THEN o.value_coded END) as units_of_age_of_child
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('EID Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;