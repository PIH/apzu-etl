-- Derivation script for mw_tb_followup
-- Generated from Pentaho transform: import-into-mw-tb-followup.ktr

DROP TABLE IF EXISTS mw_tb_followup;
CREATE TABLE mw_tb_followup (
  tb_followup_visit_id 			INT NOT NULL AUTO_INCREMENT,
  patient_id    				INT NOT NULL,
  visit_date            		DATE,
  location              		VARCHAR(255),
  rhze_regimen 					INT,
  rh_regimen 					INT,
  meningitis_regimen			INT,
  next_appointment_date 		DATE,
     PRIMARY KEY (tb_followup_visit_id)
);

INSERT INTO mw_tb_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'RH Meningitis Tablets' THEN o.value_numeric END) as meningitis_regimen,
    MAX(CASE WHEN o.concept = 'RH Regimen Tablets' THEN o.value_numeric END) as rh_regimen,
    MAX(CASE WHEN o.concept = 'Number of RHZE Tablets' THEN o.value_numeric END) as rhze_regimen
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('TB_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;