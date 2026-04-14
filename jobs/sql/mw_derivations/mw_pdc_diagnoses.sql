-- Derivation script for mw_pdc_diagnoses
-- Generated from Pentaho transform: import-into-mw-pdc-diagnoses.ktr

DROP TABLE IF EXISTS mw_pdc_diagnoses;
create table mw_pdc_diagnoses (
  patient_id     	INT          NOT NULL,
  diagnosis    	VARCHAR(255) NOT NULL,
  comments		VARCHAR(255) DEFAULT NULL,
  encounter_type 	VARCHAR(255) NOT NULL,
  location  		VARCHAR(255) NOT NULL,
  visit_date		DATE
);
alter table mw_pdc_diagnoses add index mw_pdc_diagnoses_patient_idx (patient_id);

INSERT INTO mw_pdc_diagnoses (patient_id, visit_date, diagnosis, comments, encounter_type, location)
SELECT
    o.patient_id,
    o.obs_date AS visit_date,
    o.value_coded AS diagnosis,
    o.comments,
    o.encounter_type,
    o.location
FROM omrs_obs o
WHERE o.concept = 'diagnosis'
AND o.encounter_type = 'PDC_INITIAL';
