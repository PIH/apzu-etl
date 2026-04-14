-- Derivation script for mw_pdc_vision_test
-- Generated from Pentaho transform: import-into-mw-pdc-vision-test.ktr

DROP TABLE IF EXISTS mw_pdc_vision_test;
CREATE TABLE mw_pdc_vision_test(
  pdc_vision_test_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  test_results				varchar(255) DEFAULT NULL,
  referred_out				varchar(255) DEFAULT NULL,
  referred_out_specify			varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_vision_test_id)
) ;

INSERT INTO mw_pdc_vision_test
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as referred_out_specify,
    MAX(CASE WHEN o.concept = 'Test Result' THEN o.value_coded END) as test_results
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('VISION_TEST')
GROUP BY e.patient_id, e.encounter_date, e.location;