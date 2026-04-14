-- Derivation script for mw_ncd_visits
-- Generated from Pentaho transform: import-into-mw-ncd-visits.ktr

DROP TABLE IF EXISTS mw_ncd_visits;
create table mw_ncd_visits (
  ncd_visit_id                      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id                        INT NOT NULL,
  visit_date                        DATE,
  location                          VARCHAR(255),
  visit_types                       VARCHAR(255),
  cc_initial                        BOOLEAN,
  cc_followup                       BOOLEAN,
  diabetes_htn_initial              BOOLEAN,
  diabetes_htn_followup             BOOLEAN,
  asthma_initial                    BOOLEAN,
  asthma_followup                   BOOLEAN,
  epilepsy_initial                  BOOLEAN,
  epilepsy_followup                 BOOLEAN,
  mental_health_initial             BOOLEAN,
  mental_health_followup            BOOLEAN,
  ckd_initial			     BOOLEAN,
  ckd_followup			     BOOLEAN,
  chf_initial			     BOOLEAN,
  chf_followup			     BOOLEAN,
  ncd_other_initial                 BOOLEAN,
  ncd_other_followup                BOOLEAN,
  sickle_cell_initial               BOOLEAN,
  sickle_cell_followup              BOOLEAN,
  next_appointment_date             DATE,
  systolic_bp                       DECIMAL(10,2),
  diastolic_bp                      DECIMAL(10,2),
  on_insulin                        BOOLEAN,
  asthma_classification             VARCHAR(100),
  seizure_activity                  BOOLEAN,
  num_seizures                      DECIMAL(10,2),
  hba1c                             DECIMAL(10,2),
  serum_glucose                     DECIMAL(10,2),
  foot_check                        BOOLEAN,
  suicide_risk                      VARCHAR(255),
  proteinuria                       VARCHAR(255),
  creatinine                        DECIMAL(10,2),
  hiv_result                        VARCHAR(255),
  visual_acuity                     VARCHAR(255),
  cv_risk                           DECIMAL(10,2),
  hospitalized_since_last_visit     VARCHAR(255),
  mental_status_exam                VARCHAR(255),
  mental_health_drugs               VARCHAR(255),
  mental_health_drug_side_effect    VARCHAR(255),
  mental_stable                     VARCHAR(255),
  fundoscopy                        VARCHAR(255)
);
alter table mw_ncd_visits add index mw_ncd_visit_patient_idx (patient_id);
alter table mw_ncd_visits add index mw_ncd_visit_patient_location_idx (patient_id, location);

INSERT INTO mw_ncd_visits
SELECT
    e.patient_id,
    DATE(e.encounter_date) AS visit_date,
    e.location,
    GROUP_CONCAT(DISTINCT e.encounter_type ORDER BY e.encounter_type ASC SEPARATOR ', ') AS visit_types,
    MAX(CASE WHEN e.encounter_type = 'CHRONIC_CARE_INITIAL' THEN TRUE ELSE FALSE END) AS cc_initial,
    MAX(CASE WHEN e.encounter_type = 'CHRONIC_CARE_FOLLOWUP' THEN TRUE ELSE FALSE END) AS cc_followup,
    MAX(CASE WHEN e.encounter_type = 'DIABETES HYPERTENSION INITIAL VISIT' THEN TRUE ELSE FALSE END) AS diabetes_htn_initial,
    MAX(CASE WHEN e.encounter_type = 'DIABETES HYPERTENSION FOLLOWUP' THEN TRUE ELSE FALSE END) AS diabetes_htn_followup,
    MAX(CASE WHEN e.encounter_type = 'ASTHMA_INITIAL' THEN TRUE ELSE FALSE END) AS asthma_initial,
    MAX(CASE WHEN e.encounter_type = 'ASTHMA_FOLLOWUP' THEN TRUE ELSE FALSE END) AS asthma_followup,
    MAX(CASE WHEN e.encounter_type = 'EPILEPSY_INITIAL' THEN TRUE ELSE FALSE END) AS epilepsy_initial,
    MAX(CASE WHEN e.encounter_type = 'EPILEPSY_FOLLOWUP' THEN TRUE ELSE FALSE END) AS epilepsy_followup,
    MAX(CASE WHEN e.encounter_type = 'MENTAL_HEALTH_INITIAL' THEN TRUE ELSE FALSE END) AS mental_health_initial,
    MAX(CASE WHEN e.encounter_type = 'MENTAL_HEALTH_FOLLOWUP' THEN TRUE ELSE FALSE END) AS mental_health_followup,
    MAX(CASE WHEN e.encounter_type = 'CKD_INITIAL' THEN TRUE ELSE FALSE END) AS ckd_initial,
    MAX(CASE WHEN e.encounter_type = 'CKD_FOLLOWUP' THEN TRUE ELSE FALSE END) AS ckd_followup,
    MAX(CASE WHEN e.encounter_type = 'CHF_INITIAL' THEN TRUE ELSE FALSE END) AS chf_initial,
    MAX(CASE WHEN e.encounter_type = 'CHF_FOLLOWUP' THEN TRUE ELSE FALSE END) AS chf_followup,
    MAX(CASE WHEN e.encounter_type = 'NCD_OTHER_INITIAL' THEN TRUE ELSE FALSE END) AS ncd_other_initial,
    MAX(CASE WHEN e.encounter_type = 'NCD_OTHER_FOLLOWUP' THEN TRUE ELSE FALSE END) AS ncd_other_followup,
    MAX(CASE WHEN e.encounter_type = 'SICKLE_CELL_DISEASE_INITIAL' THEN TRUE ELSE FALSE END) AS sickle_cell_initial,
    MAX(CASE WHEN e.encounter_type = 'SICKLE_CELL_DISEASE_FOLLOWUP' THEN TRUE ELSE FALSE END) AS sickle_cell_followup,
    MIN(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) AS next_appointment_date,
    MAX(CASE WHEN o.concept = 'Systolic blood pressure' THEN o.value_numeric END) AS systolic_bp,
    MAX(CASE WHEN o.concept = 'Diastolic blood pressure' THEN o.value_numeric END) AS diastolic_bp,
    MAX(CASE WHEN o.concept = 'Current drugs used' AND o.value_coded = 'Insulin' THEN TRUE ELSE FALSE END) AS on_insulin,
    MAX(CASE WHEN o.concept = 'Asthma classification' THEN o.value_coded END) AS asthma_classification,
    MAX(CASE WHEN o.concept = 'Seizure activity' AND o.value_coded = 'Seizure since last visit' THEN TRUE ELSE FALSE END) AS seizure_activity,
    MAX(CASE WHEN o.concept = 'NUMBER OF SEIZURES' THEN o.value_numeric END) AS num_seizures,
    MAX(CASE WHEN o.concept = 'Glycated hemoglobin' THEN o.value_numeric END) AS hba1c,
    MAX(CASE WHEN o.concept = 'Serum glucose' THEN o.value_numeric END) AS serum_glucose,
    CASE WHEN (
        MAX(CASE WHEN o.concept = 'Neuropathy and Peripheral Vascular Disease' THEN 1 ELSE 0 END) +
        MAX(CASE WHEN o.concept = 'Deformity of foot' THEN 1 ELSE 0 END) +
        MAX(CASE WHEN o.concept = 'Foot ulcer or infection' THEN 1 ELSE 0 END)
    ) = 3 THEN 1 END AS foot_check,
    MAX(CASE WHEN o.concept = 'Suicide risk' THEN o.value_coded END) AS suicide_risk,
    MAX(CASE WHEN o.concept = 'Urine protein' THEN o.value_coded END) AS proteinuria,
    MAX(CASE WHEN o.concept = 'Creatinine' THEN o.value_numeric END) AS creatinine,
    MAX(CASE WHEN o.concept = 'Result of HIV test' THEN o.value_coded END) AS hiv_result,
    MAX(CASE WHEN o.concept = 'Visual acuity (text)' THEN o.value_text END) AS visual_acuity,
    MAX(CASE WHEN o.concept = 'Cardiovascular risk score' THEN o.value_numeric END) AS cv_risk,
    MAX(CASE WHEN o.concept IN ('Patient hospitalized since last visit', 'Hospitalized for mental health since last visit') THEN o.value_coded END) AS hospitalized_since_last_visit,
    MAX(CASE WHEN o.concept = 'Mental health chief complaint absent' THEN o.value_coded END) AS mental_status_exam,
    GROUP_CONCAT(CASE WHEN o.concept = 'Current drugs used' AND e.encounter_type = 'MENTAL_HEALTH_FOLLOWUP' THEN o.value_coded END) AS mental_health_drugs,
    MAX(CASE WHEN o.concept = 'Does patient have adverse effects' THEN o.value_coded END) AS mental_health_drug_side_effect,
    MAX(CASE WHEN o.concept = 'Stable' THEN o.value_coded END) AS mental_stable,
    MAX(CASE WHEN o.concept = 'Fundoscopy' THEN o.value_text END) AS fundoscopy
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN (
    'CHRONIC_CARE_INITIAL', 'CHRONIC_CARE_FOLLOWUP',
    'DIABETES HYPERTENSION INITIAL VISIT', 'DIABETES HYPERTENSION FOLLOWUP',
    'ASTHMA_INITIAL', 'ASTHMA_FOLLOWUP',
    'EPILEPSY_INITIAL', 'EPILEPSY_FOLLOWUP',
    'MENTAL_HEALTH_INITIAL', 'MENTAL_HEALTH_FOLLOWUP',
    'CKD_INITIAL', 'CKD_FOLLOWUP',
    'CHF_INITIAL', 'CHF_FOLLOWUP',
    'NCD_OTHER_INITIAL', 'NCD_OTHER_FOLLOWUP',
    'SICKLE_CELL_DISEASE_INITIAL', 'SICKLE_CELL_DISEASE_FOLLOWUP'
)
GROUP BY e.patient_id, e.encounter_date, e.location;

