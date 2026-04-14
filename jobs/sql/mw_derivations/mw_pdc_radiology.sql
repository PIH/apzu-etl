-- Derivation script for mw_pdc_radiology
-- Generated from Pentaho transform: import-into-mw-pdc-radiology.ktr

DROP TABLE IF EXISTS mw_pdc_radiology;
CREATE TABLE mw_pdc_radiology (
  pdc_radiology_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  echo_results				varchar(255) DEFAULT NULL,
  other_results			varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_radiology_id)
) ;

INSERT INTO mw_pdc_radiology
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'ECHO imaging result' THEN o.value_text END) as echo_results,
    MAX(CASE WHEN o.concept = 'Other lab test result' THEN o.value_text END) as other_results
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('RADIOLOGY_SCREENING')
GROUP BY e.patient_id, e.encounter_date, e.location;