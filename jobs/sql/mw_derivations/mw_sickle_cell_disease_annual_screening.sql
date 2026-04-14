-- Derivation script for mw_sickle_cell_disease_annual_screening
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-annual-screening.ktr

DROP TABLE IF EXISTS mw_sickle_cell_disease_annual_screening;
CREATE TABLE mw_sickle_cell_disease_annual_screening (
  sickle_cell_disease_annual_screening_visit_id INT NOT NULL AUTO_INCREMENT,
  patient_id INT(11) NOT NULL,
  visit_date DATE NULL DEFAULT NULL,
  location VARCHAR(255) NULL DEFAULT NULL,
  cr INT NULL DEFAULT NULL,
  alt INT NULL DEFAULT NULL,
  ast INT NULL DEFAULT NULL,
  bil INT NULL,
  dir_bil INT NULL,
  in_bili INT NULL,
  PRIMARY KEY (sickle_cell_disease_annual_screening_visit_id));

INSERT INTO mw_sickle_cell_disease_annual_screening
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Creatinine' THEN o.value_numeric END) as cr,
    MAX(CASE WHEN o.concept = 'Serum glutamic-pyruvic transaminase' THEN o.value_numeric END) as alt,
    MAX(CASE WHEN o.concept = 'Total bilirubin' THEN o.value_numeric END) as bil,
    MAX(CASE WHEN o.concept = 'Serum glutamic-oxaloacetic transaminase' THEN o.value_numeric END) as ast,
    MAX(CASE WHEN o.concept = 'Direct bilirubin' THEN o.value_numeric END) as dir_bil,
    MAX(CASE WHEN o.concept = 'Indirect bilirubin' THEN o.value_numeric END) as in_bili
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('SICKLE_CELL_ANNUAL_SCREENING')
GROUP BY e.patient_id, e.encounter_date, e.location;