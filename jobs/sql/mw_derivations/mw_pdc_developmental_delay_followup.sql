-- Derivation script for mw_pdc_developmental_delay_followup
-- Generated from Pentaho transform: import-into-mw-pdc-developmental-delay-followup.ktr

DROP TABLE IF EXISTS mw_pdc_developmental_delay_followup;
CREATE TABLE mw_pdc_developmental_delay_followup (
  pdc_developmenta_delay_visit_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  height				int DEFAULT NULL,
  weight 				int DEFAULT NULL,
  muac 					int DEFAULT NULL,
  weight_against_age			int DEFAULT NULL,
  weight_against_height			int DEFAULT NULL,
  malnutrition				varchar(255) DEFAULT NULL,
  mdat					varchar(255) DEFAULT NULL,
  tone_normal				varchar(255) DEFAULT NULL,
  tone_hypo				varchar(255) DEFAULT NULL,
  tone_hyper				varchar(255) DEFAULT NULL,
  feeding_sucking			varchar(255) DEFAULT NULL,
  feeding_cup				varchar(255) DEFAULT NULL,
  feeding_tube				varchar(255) DEFAULT NULL,
  signs_of_cerebral_palsy		varchar(255) DEFAULT NULL,
  under_mental_health_care_program	varchar(255) DEFAULT NULL,
  anticonvulsant			varchar(255) DEFAULT NULL,
  dose_and_drug				varchar(255) DEFAULT NULL,
  dose_adjusted				varchar(255) DEFAULT NULL,
  continue_followup			varchar(255) DEFAULT NULL,
  feeding_counselling			varchar(255) DEFAULT NULL,
  group_counselling_and_play_therapy	varchar(255) DEFAULT NULL,
  referred_to_poser			varchar(255) DEFAULT NULL,
  referred_out				varchar(255) DEFAULT NULL,
  referred_out_specify			varchar(255) DEFAULT NULL,
  if_referred_out			varchar(255) DEFAULT NULL,
  if_referred_out_specify		varchar(255) DEFAULT NULL,
  next_appointment_date 		date DEFAULT NULL,
  PRIMARY KEY (pdc_developmenta_delay_visit_id)
) ;

INSERT INTO mw_pdc_developmental_delay_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Anticonvulsant' THEN o.value_coded END) as anticonvulsant,
    MAX(CASE WHEN o.concept = 'Continue followup' THEN o.value_coded END) as continue_followup,
    MAX(CASE WHEN o.concept = 'Adjust dose' THEN o.value_coded END) as dose_adjusted,
    MAX(CASE WHEN o.concept = 'Medications dispensed' THEN o.value_text END) as dose_and_drug,
    MAX(CASE WHEN o.concept = 'Cup-feeding' THEN o.value_coded END) as feeding_cup,
    MAX(CASE WHEN o.concept = 'Breast feeding' THEN o.value_coded END) as feeding_sucking,
    MAX(CASE WHEN o.concept = 'Orogastric tube' THEN o.value_coded END) as feeding_tube,
    MAX(CASE WHEN o.concept = 'Food supplement' THEN o.value_coded END) as feeding_counselling,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as if_referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as if_referred_out_specify,
    MAX(CASE WHEN o.concept = 'Middle upper arm circumference (cm)' THEN o.value_numeric END) as muac,
    MAX(CASE WHEN o.concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' THEN o.value_coded END) as mdat,
    MAX(CASE WHEN o.concept = 'Wasting/malnutrition' THEN o.value_coded END) as malnutrition,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Play therapy' THEN o.value_coded END) as group_counselling_and_play_therapy,
    MAX(CASE WHEN o.concept = 'Referred out' THEN o.value_coded END) as referred_out,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as referred_out_specify,
    MAX(CASE WHEN o.concept = 'Poor Growth' THEN o.value_coded END) as referred_to_poser,
    MAX(CASE WHEN o.concept = 'Signs of Cerebral Palsy' THEN o.value_coded END) as signs_of_cerebral_palsy,
    MAX(CASE WHEN o.concept = 'Hyper' THEN o.value_coded END) as tone_hyper,
    MAX(CASE WHEN o.concept = 'Hypo' THEN o.value_coded END) as tone_hypo,
    MAX(CASE WHEN o.concept = 'Normal(Generic)' THEN o.value_coded END) as tone_normal,
    MAX(CASE WHEN o.concept = 'Mental health referral' THEN o.value_coded END) as under_mental_health_care_program,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight,
    MAX(CASE WHEN o.concept = 'Numeric value or result' THEN o.value_numeric END) as weight_against_age,
    MAX(CASE WHEN o.concept = 'Numeric value or result' THEN o.value_numeric END) as weight_against_height
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('PDC_DEVELOPMENTAL_DELAY_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;