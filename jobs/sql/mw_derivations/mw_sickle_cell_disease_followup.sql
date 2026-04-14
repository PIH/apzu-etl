-- Derivation script for mw_sickle_cell_disease_followup
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-followup.ktr

DROP TABLE IF EXISTS mw_sickle_cell_disease_followup;
CREATE TABLE mw_sickle_cell_disease_followup (
  sickle_cell_disease_followup_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  height 				int DEFAULT NULL,
  weight 				int DEFAULT NULL,
  bmi_muac				int DEFAULT NULL,
  bp_systolic 				int DEFAULT NULL,
  bp_diastolic		 		int DEFAULT NULL,
  hr			 		int DEFAULT NULL,
  hb			 		int DEFAULT NULL,
  spo2				 	int DEFAULT NULL,
  temperature				int DEFAULT NULL,
  hospitalized_since_last_visit		varchar(255) DEFAULT NULL,
  absence_from_school 			varchar(255) DEFAULT NULL,
  pain		 			varchar(255) DEFAULT NULL,
  fever		 			varchar(255) DEFAULT NULL,
  medication_rx				varchar(255) DEFAULT NULL,
  antibiotics_rx			varchar(255) DEFAULT NULL,
  medication_side_effects		varchar(255) DEFAULT NULL,
  Jaundice			 	varchar(255) DEFAULT NULL,
  irregular_conjunctiva 		varchar(255) DEFAULT NULL,
  abnormal_lungs_exam 			varchar(255) DEFAULT NULL,
  ascites	 			varchar(255) DEFAULT NULL,
  enlarged_liver 			varchar(255) DEFAULT NULL,
  enlarged_spleen			varchar(255) DEFAULT NULL,
  next_appointment_date			date,
  PRIMARY KEY (sickle_cell_disease_followup_visit_id));

INSERT INTO mw_sickle_cell_disease_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Lung exam findings' THEN o.value_coded END) as abnormal_lungs_exam,
    MAX(CASE WHEN o.concept = 'Attended school ever' THEN o.value_coded END) as absence_from_school,
    MAX(CASE WHEN o.concept = 'Currently (or in the last week) taking antibiotics' THEN o.value_coded END) as antibiotics_rx,
    MAX(CASE WHEN o.concept = 'Ascites' THEN o.value_coded END) as ascites,
    MAX(CASE WHEN o.concept = 'Body mass index, measured' THEN o.value_numeric END) as bmi_muac,
    MAX(CASE WHEN o.concept = 'Diastolic blood pressure' THEN o.value_numeric END) as bp_diastolic,
    MAX(CASE WHEN o.concept = 'Systolic blood pressure' THEN o.value_numeric END) as bp_systolic,
    MAX(CASE WHEN o.concept = 'Enlarged Liver' THEN o.value_coded END) as enlarged_liver,
    MAX(CASE WHEN o.concept = 'Complications since last visit' THEN o.value_coded END) as enlarged_spleen,
    MAX(CASE WHEN o.concept = 'Patient experiences fevers, chills, night sweats, or productive cough' THEN o.value_coded END) as fever,
    MAX(CASE WHEN o.concept = 'Pulse' THEN o.value_numeric END) as hr,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Patient hospitalized since last visit' THEN o.value_coded END) as hospitalized_since_last_visit,
    MAX(CASE WHEN o.concept = 'Diagnosis resolved' THEN o.value_coded END) as irregular_conjunctiva,
    MAX(CASE WHEN o.concept = 'Extremity exam findings' THEN o.value_coded END) as Jaundice,
    MAX(CASE WHEN o.concept = 'Malaria' THEN o.value_coded END) as medication_rx,
    MAX(CASE WHEN o.concept = 'Medication Side Effects' THEN o.value_coded END) as medication_side_effects,
    MAX(CASE WHEN o.concept = 'Pain' THEN o.value_coded END) as pain,
    MAX(CASE WHEN o.concept = 'Blood oxygen saturation' THEN o.value_numeric END) as spo2,
    MAX(CASE WHEN o.concept = 'Temperature (c)' THEN o.value_numeric END) as temperature,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Haemoglobin' THEN o.value_numeric END) as hb
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('SICKLE_CELL_DISEASE_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;