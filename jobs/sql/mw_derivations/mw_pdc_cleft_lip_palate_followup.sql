-- Derivation script for mw_pdc_cleft_lip_palate_followup
-- Generated from Pentaho transform: import-into-mw-pdc-cleft-lip-palate-followup.ktr

DROP TABLE IF EXISTS mw_pdc_cleft_lip_palate_followup;
CREATE TABLE mw_pdc_cleft_lip_palate_followup (
  pdc_cleft_lip_palate_visit_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  weight 				int DEFAULT NULL,
  height				int DEFAULT NULL,
  muac 				int DEFAULT NULL,
  weight_for_age			int DEFAULT NULL,
  height_for_age			int DEFAULT NULL,
  malnutrition				varchar(255) DEFAULT NULL,
  feeding_problems			varchar(255) DEFAULT NULL,
  difficult_breathing			varchar(255) DEFAULT NULL,
  heart_murmur				varchar(255) DEFAULT NULL,
  ear_pain				varchar(255) DEFAULT NULL,
  ear_discharge			varchar(255) DEFAULT NULL,
  other			        varchar(255) DEFAULT NULL,
  surgery_scheduled			varchar(255) DEFAULT NULL,
  surgery_date				date DEFAULT NULL,
  continue_followup			varchar(255) DEFAULT NULL,
  group_therapy			varchar(255) DEFAULT NULL,
  food_supplement			varchar(255) DEFAULT NULL,
  individual_counselling		varchar(255) DEFAULT NULL,
  feeding_counseling			varchar(255) DEFAULT NULL,
  mdat					varchar(255) DEFAULT NULL,
  poser				varchar(255) DEFAULT NULL,
  referred_out				varchar(255) DEFAULT NULL,
  referred_out_specify			varchar(255) DEFAULT NULL,
  if_referred_out			varchar(255) DEFAULT NULL,
  if_referred_out_specify		varchar(255) DEFAULT NULL,
  clinical_plan			varchar(255) DEFAULT NULL,
  next_appointment_date		date DEFAULT NULL,
  PRIMARY KEY (pdc_cleft_lip_palate_visit_id)
) ;

INSERT INTO mw_pdc_cleft_lip_palate_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Continue followup' THEN o.value_coded END) as continue_followup,
    MAX(CASE WHEN o.concept = 'Difficult breathing' THEN o.value_coded END) as difficult_breathing,
    MAX(CASE WHEN o.concept = 'Discharge' THEN o.value_coded END) as ear_discharge,
    MAX(CASE WHEN o.concept = 'Pain' THEN o.value_coded END) as ear_pain,
    MAX(CASE WHEN o.concept = 'Counseling' THEN o.value_coded END) as feeding_counseling,
    MAX(CASE WHEN o.concept = 'Feeding issues' THEN o.value_coded END) as feeding_problems,
    MAX(CASE WHEN o.concept = 'Food supplement' THEN o.value_coded END) as food_supplement,
    MAX(CASE WHEN o.concept = 'Support group' THEN o.value_coded END) as group_therapy,
    MAX(CASE WHEN o.concept = 'Heart murmur' THEN o.value_coded END) as heart_murmur,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Height for age percent of median' THEN o.value_numeric END) as height_for_age,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as if_referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as if_referred_out_specify,
    MAX(CASE WHEN o.concept = 'Group Counselling' THEN o.value_coded END) as individual_counselling,
    MAX(CASE WHEN o.concept = 'Middle upper arm circumference (cm)' THEN o.value_numeric END) as muac,
    MAX(CASE WHEN o.concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' THEN o.value_coded END) as mdat,
    MAX(CASE WHEN o.concept = 'Wasting/malnutrition' THEN o.value_coded END) as malnutrition,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Other assessments' THEN o.value_coded END) as other,
    MAX(CASE WHEN o.concept = 'Poser Support' THEN o.value_coded END) as poser,
    MAX(CASE WHEN o.concept = 'Clinical impression comments' THEN o.value_text END) as clinical_plan,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as referred_out_specify,
    MAX(CASE WHEN o.concept = 'Date of surgery' THEN o.value_date END) as surgery_date,
    MAX(CASE WHEN o.concept = 'Scheduled' THEN o.value_coded END) as surgery_scheduled,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight,
    MAX(CASE WHEN o.concept = 'Weight for age percent of median' THEN o.value_numeric END) as weight_for_age
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('PDC_CLEFT_CLIP_PALLET_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;