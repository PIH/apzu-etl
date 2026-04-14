-- Derivation script for mw_pdc_trisomy_21_followup
-- Generated from Pentaho transform: import-into-mw-pdc-trisomy-21-followup.ktr

DROP TABLE IF EXISTS mw_pdc_trisomy_21_followup;
CREATE TABLE mw_pdc_trisomy_21_followup (
  pdc_trisomy_21_visit_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  weight 				int DEFAULT NULL,
  height				int DEFAULT NULL,
  muac 					int DEFAULT NULL,
  malnutrition				varchar(255) DEFAULT NULL,
  passage_normal			varchar(255) DEFAULT NULL,
  diarrhea_persistent			varchar(255) DEFAULT NULL,
  vomiting				varchar(255) DEFAULT NULL,
  ear_pain				varchar(255) DEFAULT NULL,
  ear_discharge				varchar(255) DEFAULT NULL,
  sleep_apnea				varchar(255) DEFAULT NULL,
  sleep_chocking			varchar(255) DEFAULT NULL,
  extremities_pain			varchar(255) DEFAULT NULL,
  extremities_weakness			varchar(255) DEFAULT NULL,
  anticonvulsant			varchar(255) DEFAULT NULL,
  drug_and_dose				varchar(255) DEFAULT NULL,
  adjust_dose				varchar(255) DEFAULT NULL,
  individual_counselling		varchar(255) DEFAULT NULL,
  feeding_counselling			varchar(255) DEFAULT NULL,
  continue_followup			varchar(255) DEFAULT NULL,
  physiotherapy				varchar(255) DEFAULT NULL,
  group_counselling_and_play_therapy	varchar(255) DEFAULT NULL,
  mdat					varchar(255) DEFAULT NULL,
  referred_to_poser			varchar(255) DEFAULT NULL,
  referred_out				varchar(255) DEFAULT NULL,
  referred_out_specify			varchar(255) DEFAULT NULL,
  if_referred_out			varchar(255) DEFAULT NULL,
  if_referred_out_specify		varchar(255) DEFAULT NULL,
  next_appointment_date 		date DEFAULT NULL,
  PRIMARY KEY (pdc_trisomy_21_visit_id )
) ;

INSERT INTO mw_pdc_trisomy_21_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Adjust dose' THEN o.value_coded END) as adjust_dose,
    MAX(CASE WHEN o.concept = 'Anticonvulsant' THEN o.value_coded END) as anticonvulsant,
    MAX(CASE WHEN o.concept = 'Continue followup' THEN o.value_coded END) as continue_followup,
    MAX(CASE WHEN o.concept = 'Diarrhea Persistent' THEN o.value_coded END) as diarrhea_persistent,
    MAX(CASE WHEN o.concept = 'Medications dispensed' THEN o.value_text END) as drug_and_dose,
    MAX(CASE WHEN o.concept = 'Discharge' THEN o.value_coded END) as ear_discharge,
    MAX(CASE WHEN o.concept = 'Pain' THEN o.value_coded END) as ear_pain,
    MAX(CASE WHEN o.concept = 'Pain' THEN o.value_coded END) as extremities_pain,
    MAX(CASE WHEN o.concept = 'Weak' THEN o.value_coded END) as extremities_weakness,
    MAX(CASE WHEN o.concept = 'Food supplement' THEN o.value_coded END) as feeding_counselling,
    MAX(CASE WHEN o.concept = 'Play therapy' THEN o.value_coded END) as group_counselling_and_play_therapy,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as if_referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as if_referred_out_specify,
    MAX(CASE WHEN o.concept = 'Counseling' THEN o.value_coded END) as individual_counselling,
    MAX(CASE WHEN o.concept = 'Middle upper arm circumference (cm)' THEN o.value_numeric END) as muac,
    MAX(CASE WHEN o.concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' THEN o.value_coded END) as mdat,
    MAX(CASE WHEN o.concept = 'Wasting/malnutrition' THEN o.value_coded END) as malnutrition,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Normal(Generic)' THEN o.value_coded END) as passage_normal,
    MAX(CASE WHEN o.concept = 'Physiotherapy' THEN o.value_coded END) as physiotherapy,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as referred_out_specify,
    MAX(CASE WHEN o.concept = 'Poor Growth' THEN o.value_coded END) as referred_to_poser,
    MAX(CASE WHEN o.concept = 'Apnea' THEN o.value_coded END) as sleep_apnea,
    MAX(CASE WHEN o.concept = 'Choking' THEN o.value_coded END) as sleep_chocking,
    MAX(CASE WHEN o.concept = 'Patient Vomiting' THEN o.value_coded END) as vomiting,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('PDC_TRISOMY21_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;