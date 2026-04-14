-- Derivation script for mw_sickle_cell_disease_history_of_hospitalization
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-history-of-hospitalization.ktr

DROP TABLE IF EXISTS mw_sickle_cell_disease_history_of_hospitalization;
CREATE TABLE mw_sickle_cell_disease_history_of_hospitalization (
  sickle_cell_disease_history_of_hospitalization int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  length_of_stay			int NOT NULL,
  reason_for_admission			varchar(255) DEFAULT NULL,
  discharge_diagnosis			varchar(255) DEFAULT NULL,
  discharge_medications			varchar(255) DEFAULT NULL,
  PRIMARY KEY (sickle_cell_disease_history_of_hospitalization));

INSERT INTO mw_sickle_cell_disease_history_of_hospitalization
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