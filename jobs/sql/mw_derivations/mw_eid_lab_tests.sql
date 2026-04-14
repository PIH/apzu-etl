-- Derivation script for mw_eid_lab_tests
-- Generated from Pentaho transform: import-into-mw-eid-lab-tests.ktr

DROP TABLE IF EXISTS mw_eid_lab_tests;
CREATE TABLE mw_eid_lab_tests (
  eid_result_tests_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  reasons_for_testing			varchar(255) DEFAULT NULL,
  lab_laboratory			varchar(255) DEFAULT NULL,
  test_type				varchar(255) DEFAULT NULL,
  sample_id				varchar(255) DEFAULT NULL,
  hiv_result				varchar(255) DEFAULT NULL,
  result_date		 		date DEFAULT NULL,
  PRIMARY KEY (eid_result_tests_id )
);

INSERT INTO mw_eid_lab_tests
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date of returned result' THEN o.value_date END) as result_date,
    MAX(CASE WHEN o.concept = 'HIV test type' THEN o.value_coded END) as test_type,
    MAX(CASE WHEN o.concept = 'Location of laboratory' THEN o.value_coded END) as lab_laboratory,
    MAX(CASE WHEN o.concept = 'Reason for testing (coded)' THEN o.value_coded END) as reasons_for_testing,
    MAX(CASE WHEN o.concept = 'Result of HIV test' THEN o.value_coded END) as hiv_result,
    MAX(CASE WHEN o.concept = 'Lab test serial number' THEN o.value_text END) as sample_id
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('EID Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;