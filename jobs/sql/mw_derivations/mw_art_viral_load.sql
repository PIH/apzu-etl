-- Derivation script for mw_art_viral_load
-- Generated from Pentaho transform: import-into-mw-art-viral-load.ktr

DROP TABLE IF EXISTS mw_art_viral_load;
CREATE TABLE mw_art_viral_load (
  viral_load_visit_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 			int NOT NULL,
  visit_date 			date DEFAULT NULL,
  location 			varchar(255) DEFAULT NULL,
  reason_for_test		varchar(255) DEFAULT NULL,
  lab_location 		varchar(255) DEFAULT NULL,
  bled 			varchar(255) DEFAULT NULL,
  sample_id 			varchar(255) DEFAULT NULL,
  viral_load_result 		int DEFAULT NULL,
  less_than_limit 		int DEFAULT NULL,
  ldl 				varchar(255) DEFAULT NULL,
  other_results 		varchar(255) DEFAULT NULL,
  PRIMARY KEY (viral_load_visit_id)
);

INSERT INTO mw_art_viral_load
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Lower than Detection Limit' THEN o.value_coded END) as ldl,
    MAX(CASE WHEN o.concept = 'Sample taken for Viral Load' THEN o.value_coded END) as bled,
    MAX(CASE WHEN o.concept = 'Location of laboratory' THEN o.value_coded END) as lab_location,
    MAX(CASE WHEN o.concept = 'Less than limit' THEN o.value_numeric END) as less_than_limit,
    MAX(CASE WHEN o.concept = 'Reason for no result' THEN o.value_coded END) as other_results,
    MAX(CASE WHEN o.concept = 'Reason for testing (coded)' THEN o.value_coded END) as reason_for_test,
    MAX(CASE WHEN o.concept = 'Viral Load Sample ID' THEN o.value_text END) as sample_id,
    MAX(CASE WHEN o.concept = 'HIV viral load' THEN o.value_numeric END) as viral_load_result
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Viral Load Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;