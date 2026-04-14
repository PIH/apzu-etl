-- Derivation script for mw_poc_checkin
-- Generated from Pentaho transform: import-into-mw-poc-checkin.ktr

DROP TABLE IF EXISTS mw_poc_checkin;
CREATE TABLE mw_poc_checkin (
  poc_checkin_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  creator varchar(255) DEFAULT NULL,
  PRIMARY KEY (poc_checkin_visit_id)
);

INSERT INTO mw_poc_checkin
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
GROUP BY e.patient_id, e.encounter_date, e.location;