-- Derivation script for mw_eid_initial
-- Generated from Pentaho transform: import-into-mw-eid-initial.ktr

DROP TABLE IF EXISTS mw_eid_initial;
CREATE TABLE mw_eid_initial (
  eid_initial_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  mother_hiv_status varchar(255) DEFAULT NULL,
  mother_art_reg_no varchar(255) DEFAULT NULL,
  mother_art_start_date date DEFAULT NULL,
  age int DEFAULT NULL,
  age_when_starting_nvp int DEFAULT NULL,
  duration_type_when_starting_nvp varchar(255) DEFAULT NULL,
  nvp_duration int DEFAULT NULL,
  nvp_duration_type varchar(255) DEFAULT NULL,
  birth_weight decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (eid_initial_visit_id)
);

INSERT INTO mw_eid_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Age' THEN o.value_numeric END) as age,
    MAX(CASE WHEN o.concept = 'Patient age when result to guardian' THEN o.value_numeric END) as age_when_starting_nvp,
    MAX(CASE WHEN o.concept = 'Birth weight' THEN o.value_numeric END) as birth_weight,
    MAX(CASE WHEN o.concept = 'Units of age of child' THEN o.value_coded END) as duration_type_when_starting_nvp,
    MAX(CASE WHEN o.concept = 'Mother ART registration number' THEN o.value_text END) as mother_art_reg_no,
    MAX(CASE WHEN o.concept = 'Mother art start date' THEN o.value_date END) as mother_art_start_date,
    MAX(CASE WHEN o.concept = 'Mother HIV Status' THEN o.value_coded END) as mother_hiv_status,
    MAX(CASE WHEN o.concept = 'Medication duration' THEN o.value_numeric END) as nvp_duration,
    MAX(CASE WHEN o.concept = 'Time units' THEN o.value_coded END) as nvp_duration_type
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('EXPOSED_CHILD_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;