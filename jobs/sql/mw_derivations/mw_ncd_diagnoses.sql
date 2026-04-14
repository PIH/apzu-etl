-- Derivation script for mw_ncd_diagnoses
-- Generated from Pentaho transform: import-into-mw-ncd-diagnoses.ktr

DROP TABLE IF EXISTS mw_ncd_diagnoses;
create table mw_ncd_diagnoses (
  patient_id     	INT          NOT NULL,
  diagnosis      	VARCHAR(100) NOT NULL,
  diagnosis_date 	DATE         NOT NULL,
  encounter_type       VARCHAR(255),
  location       	VARCHAR(255)
);
alter table mw_ncd_diagnoses add index mw_ncd_diagnoses_patient_idx (patient_id);

-- One row per NCD diagnosis, joined with its diagnosis date via obs_group_id
INSERT INTO mw_ncd_diagnoses (patient_id, diagnosis, diagnosis_date, encounter_type, location)
SELECT
    diag.patient_id,
    diag.value_coded AS diagnosis,
    ddate.value_date AS diagnosis_date,
    diag.encounter_type,
    diag.location
FROM omrs_obs diag
LEFT JOIN omrs_obs ddate ON ddate.obs_group_id = diag.obs_group_id
    AND ddate.concept = 'Diagnosis date'
WHERE diag.concept = 'Chronic care diagnosis'
AND diag.encounter_type IN (
    'DIABETES HYPERTENSION INITIAL VISIT',
    'CHRONIC_CARE_INITIAL',
    'MENTAL_HEALTH_INITIAL',
    'EPILEPSY_INITIAL',
    'CKD_INITIAL',
    'CHF_INITIAL',
    'NCD_OTHER_INITIAL',
    'ASTHMA_INITIAL',
    'SICKLE_CELL_DISEASE_INITIAL'
);
