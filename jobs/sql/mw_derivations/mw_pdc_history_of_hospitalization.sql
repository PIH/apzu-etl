-- Derivation script for mw_pdc_history_of_hospitalization
-- Generated from Pentaho transform: import-into-mw-pdc-history-of-hospitalization.ktr

DROP TABLE IF EXISTS mw_pdc_history_of_hospitalization;
CREATE TABLE mw_pdc_history_of_hospitalization (
  pdc_history_of_hospitalization_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  discharge_date			date DEFAULT NULL,
  reason_for_admission			varchar(255) DEFAULT NULL,
  discharge_diagnosis			varchar(255) DEFAULT NULL,
  discharge_medications			varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_history_of_hospitalization_id)
) ;

INSERT INTO mw_pdc_history_of_hospitalization
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Hospitalization discharge date' THEN o.value_date END) as discharge_date,
    MAX(CASE WHEN o.concept = 'Discharge medications (text)' THEN o.value_text END) as discharge_medications,
    MAX(CASE WHEN o.concept = 'Discharge diagnosis (text)' THEN o.value_text END) as discharge_diagnosis,
    MAX(CASE WHEN o.concept = 'Reason for admission (text)' THEN o.value_text END) as reason_for_admission
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('PDC_HOSPITALIZATION_HISTORY')
GROUP BY e.patient_id, e.encounter_date, e.location;