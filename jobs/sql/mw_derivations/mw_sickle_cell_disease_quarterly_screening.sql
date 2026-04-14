-- Derivation script for mw_sickle_cell_disease_quarterly_screening
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-quarterly-screening.ktr

DROP TABLE IF EXISTS mw_sickle_cell_disease_quarterly_screening;
CREATE TABLE mw_sickle_cell_disease_quarterly_screening (
  sickle_cell_disease_quarterly_screening_visit_id INT NOT NULL AUTO_INCREMENT,
  patient_id INT(11) NOT NULL,
  visit_date DATE NULL DEFAULT NULL,
  location VARCHAR(255) NULL DEFAULT NULL,
  hiv_status VARCHAR(255) NULL DEFAULT NULL,
  fcb VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (sickle_cell_disease_quarterly_screening_visit_id));

INSERT INTO mw_sickle_cell_disease_quarterly_screening
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Blood typing' THEN o.value_coded END) as fcb,
    MAX(CASE WHEN o.concept = 'HIV status' THEN o.value_coded END) as hiv_status
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('SICKLE_CELL_QUARTERLY_SCREENING')
GROUP BY e.patient_id, e.encounter_date, e.location;