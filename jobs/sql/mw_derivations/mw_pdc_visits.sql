-- Derivation script for mw_pdc_visits
-- Generated from Pentaho transform: import-into-mw-pdc-visits.ktr

DROP TABLE IF EXISTS mw_pdc_visits;
create table mw_pdc_visits (
  pdc_visit_id                      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id                        INT NOT NULL,
  visit_date                        DATE,
  location                          VARCHAR(255),
  visit_types                       VARCHAR(255),
  pdc_initial          	     BOOLEAN,
  pdc_cleft_clip_palate_initial     BOOLEAN,
  pdc_cleft_clip_palate_followup    BOOLEAN,
  pdc_developmental_delay_initial   BOOLEAN,
  pdc_developmental_delay_followup  BOOLEAN,
  pdc_other_diagnosis_initial       BOOLEAN,
  pdc_other_diagnosis_followup      BOOLEAN,
  pdc_trisomy21_initial      	     BOOLEAN,
  pdc_trisomy21_followup  	     BOOLEAN,
  next_appointment_date             DATE
);
alter table mw_pdc_visits add index mw_pdc_visit_patient_idx (patient_id);
alter table mw_pdc_visits add index mw_pdc_visit_patient_location_idx (patient_id, location);

INSERT INTO mw_pdc_visits
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    GROUP_CONCAT(DISTINCT e.encounter_type ORDER BY e.encounter_type ASC SEPARATOR ', ') as visit_types,
    MAX(CASE WHEN e.encounter_type = 'PDC_INITIAL' THEN TRUE ELSE FALSE END) as pdc_initial,
    MAX(CASE WHEN e.encounter_type = 'PDC_CLEFT_CLIP_PALLET_INITIAL' THEN TRUE ELSE FALSE END) as pdc_cleft_clip_palate_initial,
    MAX(CASE WHEN e.encounter_type = 'PDC_CLEFT_CLIP_PALLET_FOLLOWUP' THEN TRUE ELSE FALSE END) as pdc_cleft_clip_palate_followup,
    MAX(CASE WHEN e.encounter_type = 'PDC_DEVELOPMENTAL_DELAY_INITIAL' THEN TRUE ELSE FALSE END) as pdc_developmental_delay_initial,
    MAX(CASE WHEN e.encounter_type = 'PDC_DEVELOPMENTAL_DELAY_FOLLOWUP' THEN TRUE ELSE FALSE END) as pdc_developmental_delay_followup,
    MAX(CASE WHEN e.encounter_type = 'PDC_OTHER_DIAGNOSIS_INITIAL' THEN TRUE ELSE FALSE END) as pdc_other_diagnosis_initial,
    MAX(CASE WHEN e.encounter_type = 'PDC_OTHER_DIAGNOSIS_FOLLOWUP' THEN TRUE ELSE FALSE END) as pdc_other_diagnosis_followup,
    MAX(CASE WHEN e.encounter_type = 'PDC_TRISOMY21_INITIAL' THEN TRUE ELSE FALSE END) as pdc_trisomy21_initial,
    MAX(CASE WHEN e.encounter_type = 'PDC_TRISOMY21_FOLLOWUP' THEN TRUE ELSE FALSE END) as pdc_trisomy21_followup,
    MIN(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN (
    'PDC_INITIAL',
    'PDC_CLEFT_CLIP_PALLET_INITIAL',
    'PDC_CLEFT_CLIP_PALLET_FOLLOWUP',
    'PDC_DEVELOPMENTAL_DELAY_INITIAL',
    'PDC_DEVELOPMENTAL_DELAY_FOLLOWUP',
    'PDC_OTHER_DIAGNOSIS_INITIAL',
    'PDC_OTHER_DIAGNOSIS_FOLLOWUP',
    'PDC_TRISOMY21_INITIAL',
    'PDC_TRISOMY21_FOLLOWUP'
)
GROUP BY e.patient_id, e.encounter_date, e.location;
