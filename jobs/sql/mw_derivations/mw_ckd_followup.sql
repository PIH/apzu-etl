-- Derivation script for mw_ckd_followup
-- Generated from Pentaho transform: import-into-mw-ckd-followup.ktr

drop table if exists mw_ckd_followup;
create table mw_ckd_followup (
  ckd_followup_visit_id 	int not null auto_increment,
  patient_id 			int not null,
  visit_date 			date default null,
  location 			varchar(255) default null,
  height 			int default null,
  weight 			int default null,
  bp_systolic 			int default null,
  bp_diastolic 		int default null,
  heart_rate 			int default null,
  creatinine 			int default null,
  gfr 				int default null,
  urine_protein 		varchar(255) default null,
  confusion 			varchar(255) default null,
  fatigue 			varchar(255) default null,
  nausea 			varchar(255) default null,
  anorexia 			varchar(255) default null,
  pruritus 			varchar(255) default null,
  conjunctiva			varchar(255) default null,
  ascites 			varchar(255) default null,
  oedema 			varchar(255) default null,
  other_symptoms 		varchar(255) default null,
  ckd_stage 			varchar(255) default null,
  nsaid_use 			varchar(255) default null,
  alcohol 			varchar(255) default null,
  tobacco 			varchar(255) default null,
  diuretic_hctz 		varchar(255) default null,
  diuretic_hctz_dose		int,
  diuretic_hctz_dosing_unit varchar(50),
  diuretic_hctz_route		varchar(50),
  diuretic_hctz_frequency		varchar(50),
  diuretic_hctz_duration   int,
  diuretic_hctz_duration_units  varchar(50),
  diuretic_furo 		varchar(255) default null,
  diuretic_furp_dose		int,
  diuretic_furp_dosing_unit varchar(50),
  diuretic_furp_route		varchar(50),
  diuretic_furp_frequency		varchar(50),
  diuretic_furp_duration   int,
  diuretic_furp_duration_units  varchar(50),
  diuretic_spiro 		varchar(255) default null,
  diuretic_spiro_dose		int,
  diuretic_spiro_dosing_unit varchar(50),
  diuretic_spiro_route		varchar(50),
  diuretic_spiro_frequency		varchar(50),
  diuretic_spiro_duration   int,
  diuretic_spiro_duration_units  varchar(50),
  ace_i_enal				 			varchar(50),
  ace_i_enal_dose		int,
  ace_i_enal_dosing_unit varchar(50),
  ace_i_enal_route		varchar(50),
  ace_i_enal_frequency		varchar(50),
  ace_i_enal_duration   int,
  ace_i_enal_duration_units  varchar(50),
  ace_i_capt				 			varchar(50),
  ace_i_capt_dose		int,
  ace_i_capt_dosing_unit varchar(50),
  ace_i_capt_route		varchar(50),
  ace_i_capt_frequency		varchar(50),
  ace_i_capt_duration   int,
  ace_i_capt_duration_units  varchar(50),
  ace_i_lisin			 				varchar(50),
  ace_i_lisin_dose		int,
  ace_i_lisin_dosing_unit varchar(50),
  ace_i_lisin_route		varchar(50),
  ace_i_lisin_frequency		varchar(50),
  ace_i_lisin_duration   int,
  ace_i_lisin_duration_units  varchar(50),
  bb_aten				 			varchar(50),
  bb_aten_dose		int,
  bb_aten_dosing_unit varchar(50),
  bb_aten_route		varchar(50),
  bb_aten_frequency		varchar(50),
  bb_aten_duration   int,
  bb_aten_duration_units  varchar(50),
  bb_bis				 			varchar(50),
  bb_bis_dose		int,
  bb_bis_dosing_unit varchar(50),
  bb_bis_route		varchar(50),
  bb_bis_frequency		varchar(50),
  bb_bis_duration   int,
  bb_bis_duration_units  varchar(50),
  bb_prop				 			varchar(50),
  bb_prop_dose		int,
  bb_prop_dosing_unit varchar(50),
  bb_prop_route		varchar(50),
  bb_prop_frequency		varchar(50),
  bb_prop_duration   int,
  bb_prop_duration_units  varchar(50),
  ccb_aml				 			varchar(50),
  ccb_aml_dose		int,
  ccb_aml_dosing_unit varchar(50),
  ccb_aml_route		varchar(50),
  ccb_aml_frequency		varchar(50),
  ccb_aml_duration   int,
  ccb_aml_duration_units  varchar(50),
  ccb_nif				 			varchar(50),
  ccb_nif_dose		int,
  ccb_nif_dosing_unit varchar(50),
  ccb_nif_route		varchar(50),
  ccb_nif_frequency		varchar(50),
  ccb_nif_duration   int,
  ccb_nif_duration_units  varchar(50),
  other_medications 		varchar(255) default null,
  took_medications_today 	varchar(255) default null,
  diet_recommendations 	varchar(255) default null,
  next_appointment_date	date default null,
  primary key (ckd_followup_visit_id)
);

drop temporary table if exists temp_quantity_of_medication_prescribed_per_dose;
create temporary table temp_quantity_of_medication_prescribed_per_dose as select encounter_id, value_numeric from omrs_obs where concept = 'Quantity of medication prescribed per dose';
alter table temp_quantity_of_medication_prescribed_per_dose add index temp_quantity_medication_prescribed_per_dose (encounter_id);

drop temporary table if exists temp_dosing_unit;
create temporary table temp_dosing_unit as select encounter_id, value_coded from omrs_obs where concept = 'Dosing unit';
alter table temp_dosing_unit add index temp_dosing_unit_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_duration;
create temporary table temp_medication_duration as select encounter_id, value_numeric from omrs_obs where concept = 'Medication duration';
alter table temp_medication_duration add index temp_medication_duration_encounter_idx (encounter_id);

drop temporary table if exists temp_time_units;
create temporary table temp_time_units as select encounter_id, value_coded from omrs_obs where concept = 'Time units';
alter table temp_time_units add index temp_time_units_encounter_idx (encounter_id);

drop temporary table if exists temp_drug_frequency_coded;
create temporary table temp_drug_frequency_coded as select encounter_id, value_coded from omrs_obs where concept = 'Drug frequency coded';
alter table temp_drug_frequency_coded add index temp_drug_frequency_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_routes_of_administration_coded;
create temporary table temp_routes_of_administration_coded as select encounter_id, value_coded from omrs_obs where concept = 'Routes of administration (coded)';
alter table temp_routes_of_administration_coded add index temp_routes_of_administration_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from omrs_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from omrs_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_anorexia;
create temporary table temp_patient_has_anorexia as select encounter_id, value_coded from omrs_obs where concept = 'Patient has anorexia';
alter table temp_patient_has_anorexia add index temp_patient_has_anorexia_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_ascites;
create temporary table temp_patient_has_ascites as select encounter_id, value_coded from omrs_obs where concept = 'Patient has ascites';
alter table temp_patient_has_ascites add index temp_patient_has_ascites_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_ckd_stage;
create temporary table temp_ckd_stage as select encounter_id, value_coded from omrs_obs where concept = 'CKD stage';
alter table temp_ckd_stage add index temp_ckd_stage_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_confused_person_or_time;
create temporary table temp_patient_confused_person_or_time as select encounter_id, value_coded from omrs_obs where concept = 'Patient confused (newly disoriented in place, person or time)';
alter table temp_patient_confused_person_or_time add index temp_patient_confused_person_or_time_encounter_idx (encounter_id);

drop temporary table if exists temp_conjunctiva;
create temporary table temp_conjunctiva as select encounter_id, value_coded from omrs_obs where concept = 'Conjunctiva';
alter table temp_conjunctiva add index temp_conjunctiva_encounter_idx (encounter_id);

drop temporary table if exists temp_creatinine;
create temporary table temp_creatinine as select encounter_id, value_numeric from omrs_obs where concept = 'Creatinine';
alter table temp_creatinine add index temp_creatinine_encounter_idx (encounter_id);

drop temporary table if exists temp_diet_recommendations;
create temporary table temp_diet_recommendations as select encounter_id, value_coded from omrs_obs where concept = 'Diet recommendations';
alter table temp_diet_recommendations add index temp_diet_recommendations_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_fatigue;
create temporary table temp_patient_has_fatigue as select encounter_id, value_coded from omrs_obs where concept = 'Patient has fatigue';
alter table temp_patient_has_fatigue add index temp_patient_has_fatigue_encounter_idx (encounter_id);

drop temporary table if exists temp_glomerular_filtration_rate;
create temporary table temp_glomerular_filtration_rate as select encounter_id, value_numeric from omrs_obs where concept = 'Glomerular filtration rate';
alter table temp_glomerular_filtration_rate add index temp_glomerular_filtration_rate_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_nausea;
create temporary table temp_patient_has_nausea as select encounter_id, value_coded from omrs_obs where concept = 'Patient has nausea';
alter table temp_patient_has_nausea add index temp_patient_has_nausea_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_nonsteroidal_anti_inflammatory_drug_use;
create temporary table temp_nonsteroidal_anti_inflammatory_drug_use as select encounter_id, value_coded from omrs_obs where concept = 'Nonsteroidal anti-inflammatory drug use';
alter table temp_nonsteroidal_anti_inflammatory_drug_use add index temp_nonsteroidal_anti_inflammatory_drug_use_2 (encounter_id);

drop temporary table if exists temp_oedema;
create temporary table temp_oedema as select encounter_id, value_coded from omrs_obs where concept = 'Oedema';
alter table temp_oedema add index temp_oedema_encounter_idx (encounter_id);

drop temporary table if exists temp_other_chronic_heart_failure_drugs;
create temporary table temp_other_chronic_heart_failure_drugs as select encounter_id, value_text from omrs_obs where concept = 'Other chronic heart failure drugs';
alter table temp_other_chronic_heart_failure_drugs add index temp_other_chronic_heart_failure_drugs_encounter (encounter_id);

drop temporary table if exists temp_review_of_symptoms_other;
create temporary table temp_review_of_symptoms_other as select encounter_id, value_text from omrs_obs where concept = 'Review of symptoms other';
alter table temp_review_of_symptoms_other add index temp_review_of_symptoms_other_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_pruritus;
create temporary table temp_patient_has_pruritus as select encounter_id, value_coded from omrs_obs where concept = 'Patient has pruritus';
alter table temp_patient_has_pruritus add index temp_patient_has_pruritus_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from omrs_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

drop temporary table if exists temp_took_medications_today;
create temporary table temp_took_medications_today as select encounter_id, value_coded from omrs_obs where concept = 'Took medications today';
alter table temp_took_medications_today add index temp_took_medications_today_encounter_idx (encounter_id);

drop temporary table if exists temp_urine_protein;
create temporary table temp_urine_protein as select encounter_id, value_coded from omrs_obs where concept = 'Urine protein';
alter table temp_urine_protein add index temp_urine_protein_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_change;
create temporary table temp_weight_change as select encounter_id, value_text from omrs_obs where concept = 'Weight change';
alter table temp_weight_change add index temp_weight_change_encounter_idx (encounter_id);

insert into mw_ckd_followup (patient_id, visit_date, location, ace_i_enal_dose, diuretic_furp_dose, ccb_nif_dose, diuretic_spiro_dose, ccb_aml_dose, ccb_aml_dosing_unit, ccb_aml_duration, ccb_aml_duration_units, ccb_aml_frequency, ccb_aml_route, bb_aten_dose, bb_aten_dosing_unit, bb_aten_duration, bb_aten_duration_units, bb_aten_frequency, bb_aten_route, bb_bis_dose, bb_bis_dosing_unit, bb_bis_duration, bb_bis_duration_units, bb_bis_frequency, bb_bis_route, ace_i_capt_dose, ace_i_capt_dosing_unit, ace_i_capt_duration, ace_i_capt_duration_units, ace_i_capt_frequency, ace_i_capt_route, ace_i_enal_dosing_unit, ace_i_enal_duration, ace_i_enal_duration_units, ace_i_enal_frequency, ace_i_enal_route, diuretic_furp_dosing_unit, diuretic_furp_duration, diuretic_furp_duration_units, diuretic_furp_frequency, diuretic_furp_route, diuretic_hctz_dose, diuretic_hctz_dosing_unit, diuretic_hctz_duration, diuretic_hctz_duration_units, diuretic_hctz_frequency, diuretic_hctz_route, ace_i_lisin_dose, ace_i_lisin_dosing_unit, ace_i_lisin_duration, ace_i_lisin_duration_units, ace_i_lisin_frequency, ace_i_lisin_route, ccb_nif_dosing_unit, ccb_nif_duration, ccb_nif_frequency, ccb_nif_route, ccb_nif_duration_units, bb_prop_dose, bb_prop_dosing_unit, bb_prop_duration, bb_prop_duration_units, bb_prop_frequency, bb_prop_route, diuretic_spiro_dosing_unit, diuretic_spiro_duration, diuretic_spiro_duration_units, diuretic_spiro_frequency, diuretic_spiro_route, ace_i_capt, ace_i_enal, ace_i_lisin, alcohol, anorexia, ascites, bb_aten, bb_bis, bb_prop, bp_diastolic, bp_systolic, ccb_aml, ccb_nif, ckd_stage, confusion, conjunctiva, creatinine, diet_recommendations, diuretic_furo, diuretic_hctz, diuretic_spiro, fatigue, gfr, heart_rate, height, nausea, next_appointment_date, nsaid_use, oedema, other_medications, other_symptoms, pruritus, tobacco, took_medications_today, urine_protein, weight, weight_change)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as ace_i_enal_dose,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as diuretic_furp_dose,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as ccb_nif_dose,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as diuretic_spiro_dose,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as ccb_aml_dose,
    max(dosing_unit.value_coded) as ccb_aml_dosing_unit,
    max(medication_duration.value_numeric) as ccb_aml_duration,
    max(time_units.value_coded) as ccb_aml_duration_units,
    max(drug_frequency_coded.value_coded) as ccb_aml_frequency,
    max(routes_of_administration_coded.value_coded) as ccb_aml_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as bb_aten_dose,
    max(dosing_unit.value_coded) as bb_aten_dosing_unit,
    max(medication_duration.value_numeric) as bb_aten_duration,
    max(time_units.value_coded) as bb_aten_duration_units,
    max(drug_frequency_coded.value_coded) as bb_aten_frequency,
    max(routes_of_administration_coded.value_coded) as bb_aten_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as bb_bis_dose,
    max(dosing_unit.value_coded) as bb_bis_dosing_unit,
    max(medication_duration.value_numeric) as bb_bis_duration,
    max(time_units.value_coded) as bb_bis_duration_units,
    max(drug_frequency_coded.value_coded) as bb_bis_frequency,
    max(routes_of_administration_coded.value_coded) as bb_bis_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as ace_i_capt_dose,
    max(dosing_unit.value_coded) as ace_i_capt_dosing_unit,
    max(medication_duration.value_numeric) as ace_i_capt_duration,
    max(time_units.value_coded) as ace_i_capt_duration_units,
    max(drug_frequency_coded.value_coded) as ace_i_capt_frequency,
    max(routes_of_administration_coded.value_coded) as ace_i_capt_route,
    max(dosing_unit.value_coded) as ace_i_enal_dosing_unit,
    max(medication_duration.value_numeric) as ace_i_enal_duration,
    max(time_units.value_coded) as ace_i_enal_duration_units,
    max(drug_frequency_coded.value_coded) as ace_i_enal_frequency,
    max(routes_of_administration_coded.value_coded) as ace_i_enal_route,
    max(dosing_unit.value_coded) as diuretic_furp_dosing_unit,
    max(medication_duration.value_numeric) as diuretic_furp_duration,
    max(time_units.value_coded) as diuretic_furp_duration_units,
    max(drug_frequency_coded.value_coded) as diuretic_furp_frequency,
    max(routes_of_administration_coded.value_coded) as diuretic_furp_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as diuretic_hctz_dose,
    max(dosing_unit.value_coded) as diuretic_hctz_dosing_unit,
    max(medication_duration.value_numeric) as diuretic_hctz_duration,
    max(time_units.value_coded) as diuretic_hctz_duration_units,
    max(drug_frequency_coded.value_coded) as diuretic_hctz_frequency,
    max(routes_of_administration_coded.value_coded) as diuretic_hctz_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as ace_i_lisin_dose,
    max(dosing_unit.value_coded) as ace_i_lisin_dosing_unit,
    max(medication_duration.value_numeric) as ace_i_lisin_duration,
    max(time_units.value_coded) as ace_i_lisin_duration_units,
    max(drug_frequency_coded.value_coded) as ace_i_lisin_frequency,
    max(routes_of_administration_coded.value_coded) as ace_i_lisin_route,
    max(dosing_unit.value_coded) as ccb_nif_dosing_unit,
    max(medication_duration.value_numeric) as ccb_nif_duration,
    max(drug_frequency_coded.value_coded) as ccb_nif_frequency,
    max(routes_of_administration_coded.value_coded) as ccb_nif_route,
    max(time_units.value_coded) as ccb_nif_duration_units,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as bb_prop_dose,
    max(dosing_unit.value_coded) as bb_prop_dosing_unit,
    max(medication_duration.value_numeric) as bb_prop_duration,
    max(time_units.value_coded) as bb_prop_duration_units,
    max(drug_frequency_coded.value_coded) as bb_prop_frequency,
    max(routes_of_administration_coded.value_coded) as bb_prop_route,
    max(dosing_unit.value_coded) as diuretic_spiro_dosing_unit,
    max(medication_duration.value_numeric) as diuretic_spiro_duration,
    max(time_units.value_coded) as diuretic_spiro_duration_units,
    max(drug_frequency_coded.value_coded) as diuretic_spiro_frequency,
    max(routes_of_administration_coded.value_coded) as diuretic_spiro_route,
    max(case when current_drugs_used.value_coded = 'Captopril' then current_drugs_used.value_coded end) as ace_i_capt,
    max(case when current_drugs_used.value_coded = 'Enalapril' then current_drugs_used.value_coded end) as ace_i_enal,
    max(case when current_drugs_used.value_coded = 'Lisinopril' then current_drugs_used.value_coded end) as ace_i_lisin,
    max(history_of_alcohol_use.value_coded) as alcohol,
    max(patient_has_anorexia.value_coded) as anorexia,
    max(patient_has_ascites.value_coded) as ascites,
    max(case when current_drugs_used.value_coded = 'Atenolol' then current_drugs_used.value_coded end) as bb_aten,
    max(case when current_drugs_used.value_coded = 'Bisoprolol' then current_drugs_used.value_coded end) as bb_bis,
    max(case when current_drugs_used.value_coded = 'Propranolol' then current_drugs_used.value_coded end) as bb_prop,
    max(diastolic_blood_pressure.value_numeric) as bp_diastolic,
    max(systolic_blood_pressure.value_numeric) as bp_systolic,
    max(case when current_drugs_used.value_coded = 'Amlodipine' then current_drugs_used.value_coded end) as ccb_aml,
    max(case when current_drugs_used.value_coded = 'Nifedipine' then current_drugs_used.value_coded end) as ccb_nif,
    max(ckd_stage.value_coded) as ckd_stage,
    max(patient_confused_person_or_time.value_coded) as confusion,
    max(conjunctiva.value_coded) as conjunctiva,
    max(creatinine.value_numeric) as creatinine,
    max(diet_recommendations.value_coded) as diet_recommendations,
    max(case when current_drugs_used.value_coded = 'Furosemide' then current_drugs_used.value_coded end) as diuretic_furo,
    max(case when current_drugs_used.value_coded = 'Hydrochlorothiazide' then current_drugs_used.value_coded end) as diuretic_hctz,
    max(case when current_drugs_used.value_coded = 'Spironolactone' then current_drugs_used.value_coded end) as diuretic_spiro,
    max(patient_has_fatigue.value_coded) as fatigue,
    max(glomerular_filtration_rate.value_numeric) as gfr,
    max(pulse.value_numeric) as heart_rate,
    max(height_cm.value_numeric) as height,
    max(patient_has_nausea.value_coded) as nausea,
    max(appointment_date.value_date) as next_appointment_date,
    max(nonsteroidal_anti_inflammatory_drug_use.value_coded) as nsaid_use,
    max(oedema.value_coded) as oedema,
    max(other_chronic_heart_failure_drugs.value_text) as other_medications,
    max(review_of_symptoms_other.value_text) as other_symptoms,
    max(patient_has_pruritus.value_coded) as pruritus,
    max(smoking_history.value_coded) as tobacco,
    max(took_medications_today.value_coded) as took_medications_today,
    max(urine_protein.value_coded) as urine_protein,
    max(weight_kg.value_numeric) as weight,
    max(weight_change.value_text) as weight_change
from omrs_encounter e
left join temp_quantity_of_medication_prescribed_per_dose quantity_of_medication_prescribed_per_dose on e.encounter_id = quantity_of_medication_prescribed_per_dose.encounter_id
left join temp_dosing_unit dosing_unit on e.encounter_id = dosing_unit.encounter_id
left join temp_medication_duration medication_duration on e.encounter_id = medication_duration.encounter_id
left join temp_time_units time_units on e.encounter_id = time_units.encounter_id
left join temp_drug_frequency_coded drug_frequency_coded on e.encounter_id = drug_frequency_coded.encounter_id
left join temp_routes_of_administration_coded routes_of_administration_coded on e.encounter_id = routes_of_administration_coded.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_patient_has_anorexia patient_has_anorexia on e.encounter_id = patient_has_anorexia.encounter_id
left join temp_patient_has_ascites patient_has_ascites on e.encounter_id = patient_has_ascites.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_ckd_stage ckd_stage on e.encounter_id = ckd_stage.encounter_id
left join temp_patient_confused_person_or_time patient_confused_person_or_time on e.encounter_id = patient_confused_person_or_time.encounter_id
left join temp_conjunctiva conjunctiva on e.encounter_id = conjunctiva.encounter_id
left join temp_creatinine creatinine on e.encounter_id = creatinine.encounter_id
left join temp_diet_recommendations diet_recommendations on e.encounter_id = diet_recommendations.encounter_id
left join temp_patient_has_fatigue patient_has_fatigue on e.encounter_id = patient_has_fatigue.encounter_id
left join temp_glomerular_filtration_rate glomerular_filtration_rate on e.encounter_id = glomerular_filtration_rate.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_patient_has_nausea patient_has_nausea on e.encounter_id = patient_has_nausea.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_nonsteroidal_anti_inflammatory_drug_use nonsteroidal_anti_inflammatory_drug_use on e.encounter_id = nonsteroidal_anti_inflammatory_drug_use.encounter_id
left join temp_oedema oedema on e.encounter_id = oedema.encounter_id
left join temp_other_chronic_heart_failure_drugs other_chronic_heart_failure_drugs on e.encounter_id = other_chronic_heart_failure_drugs.encounter_id
left join temp_review_of_symptoms_other review_of_symptoms_other on e.encounter_id = review_of_symptoms_other.encounter_id
left join temp_patient_has_pruritus patient_has_pruritus on e.encounter_id = patient_has_pruritus.encounter_id
left join temp_smoking_history smoking_history on e.encounter_id = smoking_history.encounter_id
left join temp_took_medications_today took_medications_today on e.encounter_id = took_medications_today.encounter_id
left join temp_urine_protein urine_protein on e.encounter_id = urine_protein.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_weight_change weight_change on e.encounter_id = weight_change.encounter_id
where e.encounter_type in ('CKD_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;