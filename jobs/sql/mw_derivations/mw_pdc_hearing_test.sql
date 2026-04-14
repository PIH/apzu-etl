-- Derivation script for mw_pdc_hearing_test
-- Generated from Pentaho transform: import-into-mw-pdc-hearing-test.ktr

DROP TABLE IF EXISTS mw_pdc_hearing_test;
CREATE TABLE mw_pdc_hearing_test (
  pdc_hearing_test_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  left_ear				varchar(255) DEFAULT NULL,
  right_ear				varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_hearing_test_id)
) ;

INSERT INTO mw_pdc_hearing_test
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Left Ear' THEN o.value_coded END) as left_ear,
    MAX(CASE WHEN o.concept = 'Right Ear' THEN o.value_coded END) as right_ear
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('HEARING_TEST')
GROUP BY e.patient_id, e.encounter_date, e.location;