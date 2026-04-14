-- Derivation script for mw_art_visits
-- Generated from Pentaho transform: import-into-mw-art-visits.ktr

DROP TABLE IF EXISTS mw_art_visits;
CREATE TABLE mw_art_visits (
  art_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  art_drug_regimen      VARCHAR(255),
  next_appointment_date DATE
);
alter table mw_art_visits add index mw_art_visit_patient_idx (patient_id);
alter table mw_art_visits add index mw_art_visit_patient_location_idx (patient_id, location);

INSERT INTO mw_art_visits
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Malawi Antiretroviral drugs received' THEN o.value_coded END) as art_drugs_rcd
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('ART_INITIAL', 'ART_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;