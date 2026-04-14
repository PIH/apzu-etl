-- Derivation script for mw_eid_visits
-- Generated from Pentaho transform: import-into-mw-eid-visits.ktr

DROP TABLE IF EXISTS mw_eid_visits;
CREATE TABLE mw_eid_visits (
  eid_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  breastfeeding_status  VARCHAR(100),
  mother_status	        VARCHAR(100),
  next_appointment_date DATE
);
alter table mw_eid_visits add index mw_eid_visit_patient_idx (patient_id);
alter table mw_eid_visits add index mw_eid_visit_patient_location_idx (patient_id, location);

INSERT INTO mw_eid_visits
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Breast feeding' THEN o.value_coded END) as breastfeeding_status,
    MAX(CASE WHEN o.concept = 'Mother HIV Status' THEN o.value_coded END) as mother_status
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('EXPOSED_CHILD_INITIAL', 'EXPOSED_CHILD_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;