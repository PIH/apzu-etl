-- Derivation script for mw_eid_followup
-- Generated from Pentaho transform: import-into-mw-eid-followup.ktr

DROP TABLE IF EXISTS mw_eid_followup;
CREATE TABLE mw_eid_followup (
  eid_followup_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  height INT default null,
  weight INT default null,
  muac decimal(16,4) DEFAULT NULL,
  wasting_or_malnutrition varchar(255) DEFAULT NULL,
  breast_feeding varchar(255) DEFAULT NULL,
  mother_status varchar(255) DEFAULT NULL,
  clinical_monitoring varchar(255) DEFAULT NULL,
  hiv_infection varchar(255) DEFAULT NULL,
  cpt int DEFAULT NULL,
  next_appointment_date date DEFAULT NULL,
  PRIMARY KEY (eid_followup_visit_id)
);

INSERT INTO mw_eid_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Breast feeding' THEN o.value_coded END) as breast_feeding,
    MAX(CASE WHEN o.concept = 'Clinical Monitoring Exposed Child' THEN o.value_coded END) as clinical_monitoring,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Mother HIV Status' THEN o.value_coded END) as mother_status,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Wasting/malnutrition' THEN o.value_coded END) as wasting_or_malnutrition,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight,
    MAX(CASE WHEN o.concept = 'Number of CPT tablets dispensed' THEN o.value_numeric END) as cpt,
    MAX(CASE WHEN o.concept = 'Childs current HIV status' THEN o.value_coded END) as hiv_infection,
    MAX(CASE WHEN o.concept = 'Middle upper arm circumference (cm)' THEN o.value_numeric END) as muac
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('EXPOSED_CHILD_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;