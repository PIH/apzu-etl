-- Derivation script for mw_ncd_other_followup
-- Generated from Pentaho transform: import-into-mw-ncd-other-followup.ktr

DROP TABLE IF EXISTS mw_ncd_other_followup;
CREATE TABLE mw_ncd_other_followup (
  ncd_other_followup_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  height int DEFAULT NULL,
  weight int DEFAULT NULL,
  weight_change varchar(255) DEFAULT NULL,
  bp_systolic int DEFAULT NULL,
  bp_diastolic int DEFAULT NULL,
  heart_rate int DEFAULT NULL,
  spo2 int DEFAULT NULL,
  alcohol varchar(255) DEFAULT NULL,
  tobacco varchar(255) DEFAULT NULL,
  fruit_and_vegetable_portions int DEFAULT NULL,
  days_per_week_exercise int DEFAULT NULL,
  hospitalized_since_last_visit_for_ncd varchar(255) DEFAULT NULL,
  medications varchar(255) DEFAULT NULL,
  medications_changed varchar(255) DEFAULT NULL,
  comments varchar(2000) DEFAULT NULL,
  next_appointment_date date DEFAULT NULL,
  next_appointment_location varchar(255) DEFAULT NULL,
  PRIMARY KEY (ncd_other_followup_visit_id)
);

INSERT INTO mw_ncd_other_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'History of alcohol use' THEN o.value_coded END) as alcohol,
    MAX(CASE WHEN o.concept = 'Diastolic blood pressure' THEN o.value_numeric END) as bp_diastolic,
    MAX(CASE WHEN o.concept = 'Systolic blood pressure' THEN o.value_numeric END) as bp_systolic,
    MAX(CASE WHEN o.concept = 'General comment' THEN o.value_text END) as comments,
    MAX(CASE WHEN o.concept = 'Days per week of moderate exercise' THEN o.value_numeric END) as days_per_week_exercise,
    MAX(CASE WHEN o.concept = 'Number of servings of fruits and vegetables consumed per day' THEN o.value_numeric END) as fruit_and_vegetable_portions,
    MAX(CASE WHEN o.concept = 'Pulse' THEN o.value_numeric END) as heart_rate,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Patient hospitalized since last visit' THEN o.value_coded END) as hospitalized_since_last_visit_for_ncd,
    MAX(CASE WHEN o.concept = 'Medications dispensed' THEN o.value_text END) as medications,
    MAX(CASE WHEN o.concept = 'Has the treatment changed at this visit?' THEN o.value_coded END) as medications_changed,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Next appointment location' THEN o.value_coded END) as next_appointment_location,
    MAX(CASE WHEN o.concept = 'Blood oxygen saturation' THEN o.value_numeric END) as spo2,
    MAX(CASE WHEN o.concept = 'Smoking history' THEN o.value_coded END) as tobacco,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight,
    MAX(CASE WHEN o.concept = 'Weight change' THEN o.value_text END) as weight_change
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NCD_OTHER_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;