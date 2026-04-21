-- Derivation script for mw_chf_followup
-- Generated from Pentaho transform: import-into-mw-chf-followup.ktr

drop table if exists mw_chf_followup;
create table mw_chf_followup (
  chf_followup_visit_id 			int not null auto_increment,
  patient_id 					int not null,
  visit_date 					date default null,
  location 					varchar(50) default null,
  height 					int default null,	
  weight 					int default null,
  weight_change 				varchar(50) default null,
  bp_systolic 					int default null,
  bp_diastolic 				int default null,
  heart_rate 					int default null,
  spo2 					int default null,
  orthopnea 					varchar(50) default null,
  dyspnea_on_exertion 				varchar(50) default null,
  dry_cough 					varchar(50) default null,
  fatigue			 		varchar(50) default null,
  hospitalized_since_last_visit_for_ncd 	varchar(50) default null,
  oedema 					varchar(50) default null,
  bibasilar_crackles 				varchar(50) default null,
  jvp_elevated 				varchar(50) default null,
  volume_status 				varchar(50) default null,
  nyha_stage 					varchar(50) default null,
  alcohol 					varchar(50) default null,
  tobacco 					varchar(50) default null,
  salt_or_fluid_restricted 			varchar(50) default null,
  concern_for_depression_or_anxiety 		varchar(50) default null,
  aspirin 					varchar(50) default null,
  asprin_asa_dose		int,
  asprin_asa_dosing_unit varchar(50),
  asprin_asa_route		varchar(50),
  asprin_asa_frequency		varchar(50),
  asprin_asa_duration   int,
  asprin_asa_duration_units  varchar(50),
  diuretic_hctz 				varchar(50) default null,
  diuretic_hctz_dose		int,
  diuretic_hctz_dosing_unit varchar(50),
  diuretic_hctz_route		varchar(50),
  diuretic_hctz_frequency		varchar(50),
  diuretic_hctz_duration   int,
  diuretic_hctz_duration_units  varchar(50),
  diuretic_furo 				varchar(50) default null,
  diuretic_furp_dose		int,
  diuretic_furp_dosing_unit varchar(50),
  diuretic_furp_route		varchar(50),
  diuretic_furp_frequency		varchar(50),
  diuretic_furp_duration   int,
  diuretic_furp_duration_units  varchar(50),
  diuretic_spiro			 			varchar(50),
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
  benzathine 					varchar(50) default null,
  benzathine_dose		int,
  benzathine_dosing_unit varchar(50),
  benzathine_route		varchar(50),
  benzathine_frequency		varchar(50),
  benzathine_duration   int,
  benzathine_duration_units  varchar(50),
  other_medications 				varchar(50) default null,
  took_medications_today 			varchar(50) default null,
  diet_salt_or_fluid 				varchar(50) default null,
  mental_health_referral 			varchar(50) default null,
  palliative_referral 				varchar(50) default null,
  request_chw_f_u 				varchar(50) default null,
  next_appointment_date 			date default null,
  primary key (chf_followup_visit_id)
) ;

drop temporary table if exists temp_chf_followup_obs;
create temporary table temp_chf_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'CHF_FOLLOWUP';
alter table temp_chf_followup_obs add index temp_chf_followup_obs_concept_idx (concept);
alter table temp_chf_followup_obs add index temp_chf_followup_obs_encounter_idx (encounter_id);
alter table temp_chf_followup_obs add index temp_chf_followup_obs_group_idx (obs_group_id);

-- Build temp_medications in three steps to avoid a full scan of the ~20M-row omrs_obs table.
-- Step 1: pull only the drug-name obs for this encounter type (~20M rows → small set).
-- Step 2: pull only the detail obs whose obs_group_id appears in step 1 (indexed lookup).
-- Step 3: join the two small tables to produce one row per drug per encounter.
drop temporary table if exists temp_drug_name_obs;
create temporary table temp_drug_name_obs as
select obs_id, encounter_id, obs_group_id, value_coded as drug_name
from temp_chf_followup_obs
where concept = 'Current drugs used';
alter table temp_drug_name_obs add index temp_drug_name_obs_group_idx (obs_group_id);
alter table temp_drug_name_obs add index temp_drug_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_drug_detail_obs;
create temporary table temp_drug_detail_obs as
select obs_group_id, concept, value_coded, value_numeric
from temp_chf_followup_obs
where obs_group_id in (select obs_group_id from temp_drug_name_obs)
  and concept in ('Drug frequency coded', 'Quantity of medication prescribed per dose',
                  'Dosing unit', 'Routes of administration (coded)',
                  'Medication duration', 'Time units');
alter table temp_drug_detail_obs add index temp_drug_detail_obs_group_idx (obs_group_id);

drop temporary table if exists temp_medications;
create temporary table temp_medications as
select
    t.encounter_id,
    t.drug_name,
    max(case when d.concept = 'Drug frequency coded' then d.value_coded end)                         as frequency,
    max(case when d.concept = 'Quantity of medication prescribed per dose' then d.value_numeric end) as dose,
    max(case when d.concept = 'Dosing unit' then d.value_coded end)                                  as dosing_unit,
    max(case when d.concept = 'Routes of administration (coded)' then d.value_coded end)             as route,
    max(case when d.concept = 'Medication duration' then d.value_numeric end)                        as duration,
    max(case when d.concept = 'Time units' then d.value_coded end)                                   as duration_units
from temp_drug_name_obs t
join temp_drug_detail_obs d on d.obs_group_id = t.obs_group_id
group by t.encounter_id, t.obs_group_id, t.drug_name;
alter table temp_medications add index temp_medications_encounter_idx (encounter_id);
alter table temp_medications add index temp_medications_drug_idx (drug_name);

drop temporary table if exists temp_med_aspirin;
create temporary table temp_med_aspirin as select * from temp_medications where drug_name = 'Aspirin';
alter table temp_med_aspirin add index temp_med_aspirin_encounter_idx (encounter_id);

drop temporary table if exists temp_med_hctz;
create temporary table temp_med_hctz as select * from temp_medications where drug_name = 'Hydrochlorothiazide';
alter table temp_med_hctz add index temp_med_hctz_encounter_idx (encounter_id);

drop temporary table if exists temp_med_furosemide;
create temporary table temp_med_furosemide as select * from temp_medications where drug_name = 'Furosemide';
alter table temp_med_furosemide add index temp_med_furosemide_encounter_idx (encounter_id);

drop temporary table if exists temp_med_spironolactone;
create temporary table temp_med_spironolactone as select * from temp_medications where drug_name = 'Spironolactone';
alter table temp_med_spironolactone add index temp_med_spironolactone_encounter_idx (encounter_id);

drop temporary table if exists temp_med_enalapril;
create temporary table temp_med_enalapril as select * from temp_medications where drug_name = 'Enalapril';
alter table temp_med_enalapril add index temp_med_enalapril_encounter_idx (encounter_id);

drop temporary table if exists temp_med_captopril;
create temporary table temp_med_captopril as select * from temp_medications where drug_name = 'Captopril';
alter table temp_med_captopril add index temp_med_captopril_encounter_idx (encounter_id);

drop temporary table if exists temp_med_lisinopril;
create temporary table temp_med_lisinopril as select * from temp_medications where drug_name = 'Lisinopril';
alter table temp_med_lisinopril add index temp_med_lisinopril_encounter_idx (encounter_id);

drop temporary table if exists temp_med_atenolol;
create temporary table temp_med_atenolol as select * from temp_medications where drug_name = 'Atenolol';
alter table temp_med_atenolol add index temp_med_atenolol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_bisoprolol;
create temporary table temp_med_bisoprolol as select * from temp_medications where drug_name = 'Bisoprolol';
alter table temp_med_bisoprolol add index temp_med_bisoprolol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_propranolol;
create temporary table temp_med_propranolol as select * from temp_medications where drug_name = 'Propranolol';
alter table temp_med_propranolol add index temp_med_propranolol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_amlodipine;
create temporary table temp_med_amlodipine as select * from temp_medications where drug_name = 'Amlodipine';
alter table temp_med_amlodipine add index temp_med_amlodipine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_nifedipine;
create temporary table temp_med_nifedipine as select * from temp_medications where drug_name = 'Nifedipine';
alter table temp_med_nifedipine add index temp_med_nifedipine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_benzathine;
create temporary table temp_med_benzathine as select * from temp_medications where drug_name = 'Benzathine penicillin';
alter table temp_med_benzathine add index temp_med_benzathine_encounter_idx (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_bibasilar_crackles;
create temporary table temp_bibasilar_crackles as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Bibasilar crackles';
alter table temp_bibasilar_crackles add index temp_bibasilar_crackles_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from temp_chf_followup_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from temp_chf_followup_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_concern_for_depression_or_anxiety;
create temporary table temp_concern_for_depression_or_anxiety as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Concern for depression or anxiety';
alter table temp_concern_for_depression_or_anxiety add index temp_concern_depression_or_anxiety_encounter_idx (encounter_id);

drop temporary table if exists temp_low_salt_diet_recommended;
create temporary table temp_low_salt_diet_recommended as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Low salt diet recommended';
alter table temp_low_salt_diet_recommended add index temp_low_salt_diet_recommended_encounter_idx (encounter_id);

drop temporary table if exists temp_level_of_dry_cough;
create temporary table temp_level_of_dry_cough as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Level of dry cough';
alter table temp_level_of_dry_cough add index temp_level_of_dry_cough_encounter_idx (encounter_id);

drop temporary table if exists temp_dyspnea_on_extertion;
create temporary table temp_dyspnea_on_extertion as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Dyspnea on extertion';
alter table temp_dyspnea_on_extertion add index temp_dyspnea_on_extertion_encounter_idx (encounter_id);

drop temporary table if exists temp_level_of_fatigue;
create temporary table temp_level_of_fatigue as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Level of fatigue';
alter table temp_level_of_fatigue add index temp_level_of_fatigue_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from temp_chf_followup_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from temp_chf_followup_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_hospitalized_non_communicable_disease_since;
create temporary table temp_hospitalized_non_communicable_disease_since as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Hospitalized for non-communicable disease since last visit';
alter table temp_hospitalized_non_communicable_disease_since add index temp_hospitalized_ncd_since_last_visit_encounter (encounter_id);

drop temporary table if exists temp_jugular_venous_pressure_elevated;
create temporary table temp_jugular_venous_pressure_elevated as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Jugular venous pressure elevated';
alter table temp_jugular_venous_pressure_elevated add index temp_jugular_venous_pressure_elevated_encounter (encounter_id);

drop temporary table if exists temp_mental_health_referral;
create temporary table temp_mental_health_referral as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Mental health referral';
alter table temp_mental_health_referral add index temp_mental_health_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from temp_chf_followup_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_nyha_class;
create temporary table temp_nyha_class as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Nyha class';
alter table temp_nyha_class add index temp_nyha_class_encounter_idx (encounter_id);

drop temporary table if exists temp_oedema;
create temporary table temp_oedema as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Oedema';
alter table temp_oedema add index temp_oedema_encounter_idx (encounter_id);

drop temporary table if exists temp_level_of_orthopnea;
create temporary table temp_level_of_orthopnea as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Level of orthopnea';
alter table temp_level_of_orthopnea add index temp_level_of_orthopnea_encounter_idx (encounter_id);

drop temporary table if exists temp_other_chronic_heart_failure_drugs;
create temporary table temp_other_chronic_heart_failure_drugs as select encounter_id, value_text from temp_chf_followup_obs where concept = 'Other chronic heart failure drugs';
alter table temp_other_chronic_heart_failure_drugs add index temp_other_chronic_heart_failure_drugs_encounter (encounter_id);

drop temporary table if exists temp_palliative_care_referral;
create temporary table temp_palliative_care_referral as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Palliative care referral';
alter table temp_palliative_care_referral add index temp_palliative_care_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_follow_up_agreement;
create temporary table temp_follow_up_agreement as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Follow up agreement';
alter table temp_follow_up_agreement add index temp_follow_up_agreement_encounter_idx (encounter_id);

drop temporary table if exists temp_salt_or_fluid_restricted;
create temporary table temp_salt_or_fluid_restricted as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Salt or fluid restricted';
alter table temp_salt_or_fluid_restricted add index temp_salt_or_fluid_restricted_encounter_idx (encounter_id);

drop temporary table if exists temp_blood_oxygen_saturation;
create temporary table temp_blood_oxygen_saturation as select encounter_id, value_numeric from temp_chf_followup_obs where concept = 'Blood oxygen saturation';
alter table temp_blood_oxygen_saturation add index temp_blood_oxygen_saturation_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

drop temporary table if exists temp_took_medications_today;
create temporary table temp_took_medications_today as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Took medications today';
alter table temp_took_medications_today add index temp_took_medications_today_encounter_idx (encounter_id);

drop temporary table if exists temp_patients_fluid_management;
create temporary table temp_patients_fluid_management as select encounter_id, value_coded from temp_chf_followup_obs where concept = 'Patients fluid management';
alter table temp_patients_fluid_management add index temp_patients_fluid_management_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from temp_chf_followup_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_change;
create temporary table temp_weight_change as select encounter_id, value_text from temp_chf_followup_obs where concept = 'Weight change';
alter table temp_weight_change add index temp_weight_change_encounter_idx (encounter_id);

insert into mw_chf_followup (patient_id, visit_date, location, benzathine_dose, ace_i_enal_dose, diuretic_furp_dose, ccb_nif_dose, diuretic_spiro_dose, ccb_aml_dose, ccb_aml_dosing_unit, ccb_aml_duration, ccb_aml_duration_units, ccb_aml_frequency, ccb_aml_route, asprin_asa_dose, asprin_asa_dosing_unit, asprin_asa_duration, asprin_asa_duration_units, asprin_asa_frequency, asprin_asa_route, bb_aten_dose, bb_aten_dosing_unit, bb_aten_duration, bb_aten_duration_units, bb_aten_frequency, bb_aten_route, benzathine_dosing_unit, benzathine_duration, benzathine_duration_units, benzathine_frequency, benzathine_route, bb_bis_dose, bb_bis_dosing_unit, bb_bis_duration, bb_bis_duration_units, bb_bis_frequency, bb_bis_route, ace_i_capt_dose, ace_i_capt_dosing_unit, ace_i_capt_duration, ace_i_capt_duration_units, ace_i_capt_frequency, ace_i_capt_route, ace_i_enal_dosing_unit, ace_i_enal_duration, ace_i_enal_duration_units, ace_i_enal_frequency, ace_i_enal_route, diuretic_furp_dosing_unit, diuretic_furp_duration, diuretic_furp_duration_units, diuretic_furp_frequency, diuretic_furp_route, diuretic_hctz_dose, diuretic_hctz_dosing_unit, diuretic_hctz_duration, diuretic_hctz_duration_units, diuretic_hctz_frequency, diuretic_hctz_route, ace_i_lisin_dose, ace_i_lisin_dosing_unit, ace_i_lisin_duration, ace_i_lisin_duration_units, ace_i_lisin_frequency, ace_i_lisin_route, ccb_nif_dosing_unit, ccb_nif_duration, ccb_nif_frequency, ccb_nif_route, ccb_nif_duration_units, bb_prop_dose, bb_prop_dosing_unit, bb_prop_duration, bb_prop_duration_units, bb_prop_frequency, bb_prop_route, diuretic_spiro_dosing_unit, diuretic_spiro_duration, diuretic_spiro_duration_units, diuretic_spiro_frequency, diuretic_spiro_route, ace_i_capt, ace_i_enal, ace_i_lisin, alcohol, aspirin, bb_aten, bb_bis, bb_prop, benzathine, bibasilar_crackles, bp_diastolic, bp_systolic, ccb_aml, ccb_nif, concern_for_depression_or_anxiety, diet_salt_or_fluid, diuretic_furo, diuretic_hctz, diuretic_spiro, dry_cough, dyspnea_on_exertion, fatigue, heart_rate, height, hospitalized_since_last_visit_for_ncd, jvp_elevated, mental_health_referral, next_appointment_date, nyha_stage, oedema, orthopnea, other_medications, palliative_referral, request_chw_f_u, salt_or_fluid_restricted, spo2, tobacco, took_medications_today, volume_status, weight, weight_change)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(med_benzathine.dose) as benzathine_dose,
    max(med_enalapril.dose) as ace_i_enal_dose,
    max(med_furosemide.dose) as diuretic_furp_dose,
    max(med_nifedipine.dose) as ccb_nif_dose,
    max(med_spironolactone.dose) as diuretic_spiro_dose,
    max(med_amlodipine.dose) as ccb_aml_dose,
    max(med_amlodipine.dosing_unit) as ccb_aml_dosing_unit,
    max(med_amlodipine.duration) as ccb_aml_duration,
    max(med_amlodipine.duration_units) as ccb_aml_duration_units,
    max(med_amlodipine.frequency) as ccb_aml_frequency,
    max(med_amlodipine.route) as ccb_aml_route,
    max(med_aspirin.dose) as asprin_asa_dose,
    max(med_aspirin.dosing_unit) as asprin_asa_dosing_unit,
    max(med_aspirin.duration) as asprin_asa_duration,
    max(med_aspirin.duration_units) as asprin_asa_duration_units,
    max(med_aspirin.frequency) as asprin_asa_frequency,
    max(med_aspirin.route) as asprin_asa_route,
    max(med_atenolol.dose) as bb_aten_dose,
    max(med_atenolol.dosing_unit) as bb_aten_dosing_unit,
    max(med_atenolol.duration) as bb_aten_duration,
    max(med_atenolol.duration_units) as bb_aten_duration_units,
    max(med_atenolol.frequency) as bb_aten_frequency,
    max(med_atenolol.route) as bb_aten_route,
    max(med_benzathine.dosing_unit) as benzathine_dosing_unit,
    max(med_benzathine.duration) as benzathine_duration,
    max(med_benzathine.duration_units) as benzathine_duration_units,
    max(med_benzathine.frequency) as benzathine_frequency,
    max(med_benzathine.route) as benzathine_route,
    max(med_bisoprolol.dose) as bb_bis_dose,
    max(med_bisoprolol.dosing_unit) as bb_bis_dosing_unit,
    max(med_bisoprolol.duration) as bb_bis_duration,
    max(med_bisoprolol.duration_units) as bb_bis_duration_units,
    max(med_bisoprolol.frequency) as bb_bis_frequency,
    max(med_bisoprolol.route) as bb_bis_route,
    max(med_captopril.dose) as ace_i_capt_dose,
    max(med_captopril.dosing_unit) as ace_i_capt_dosing_unit,
    max(med_captopril.duration) as ace_i_capt_duration,
    max(med_captopril.duration_units) as ace_i_capt_duration_units,
    max(med_captopril.frequency) as ace_i_capt_frequency,
    max(med_captopril.route) as ace_i_capt_route,
    max(med_enalapril.dosing_unit) as ace_i_enal_dosing_unit,
    max(med_enalapril.duration) as ace_i_enal_duration,
    max(med_enalapril.duration_units) as ace_i_enal_duration_units,
    max(med_enalapril.frequency) as ace_i_enal_frequency,
    max(med_enalapril.route) as ace_i_enal_route,
    max(med_furosemide.dosing_unit) as diuretic_furp_dosing_unit,
    max(med_furosemide.duration) as diuretic_furp_duration,
    max(med_furosemide.duration_units) as diuretic_furp_duration_units,
    max(med_furosemide.frequency) as diuretic_furp_frequency,
    max(med_furosemide.route) as diuretic_furp_route,
    max(med_hctz.dose) as diuretic_hctz_dose,
    max(med_hctz.dosing_unit) as diuretic_hctz_dosing_unit,
    max(med_hctz.duration) as diuretic_hctz_duration,
    max(med_hctz.duration_units) as diuretic_hctz_duration_units,
    max(med_hctz.frequency) as diuretic_hctz_frequency,
    max(med_hctz.route) as diuretic_hctz_route,
    max(med_lisinopril.dose) as ace_i_lisin_dose,
    max(med_lisinopril.dosing_unit) as ace_i_lisin_dosing_unit,
    max(med_lisinopril.duration) as ace_i_lisin_duration,
    max(med_lisinopril.duration_units) as ace_i_lisin_duration_units,
    max(med_lisinopril.frequency) as ace_i_lisin_frequency,
    max(med_lisinopril.route) as ace_i_lisin_route,
    max(med_nifedipine.dosing_unit) as ccb_nif_dosing_unit,
    max(med_nifedipine.duration) as ccb_nif_duration,
    max(med_nifedipine.frequency) as ccb_nif_frequency,
    max(med_nifedipine.route) as ccb_nif_route,
    max(med_nifedipine.duration_units) as ccb_nif_duration_units,
    max(med_propranolol.dose) as bb_prop_dose,
    max(med_propranolol.dosing_unit) as bb_prop_dosing_unit,
    max(med_propranolol.duration) as bb_prop_duration,
    max(med_propranolol.duration_units) as bb_prop_duration_units,
    max(med_propranolol.frequency) as bb_prop_frequency,
    max(med_propranolol.route) as bb_prop_route,
    max(med_spironolactone.dosing_unit) as diuretic_spiro_dosing_unit,
    max(med_spironolactone.duration) as diuretic_spiro_duration,
    max(med_spironolactone.duration_units) as diuretic_spiro_duration_units,
    max(med_spironolactone.frequency) as diuretic_spiro_frequency,
    max(med_spironolactone.route) as diuretic_spiro_route,
    max(case when current_drugs_used.value_coded = 'Captopril' then current_drugs_used.value_coded end) as ace_i_capt,
    max(case when current_drugs_used.value_coded = 'Enalapril' then current_drugs_used.value_coded end) as ace_i_enal,
    max(case when current_drugs_used.value_coded = 'Lisinopril' then current_drugs_used.value_coded end) as ace_i_lisin,
    max(history_of_alcohol_use.value_coded) as alcohol,
    max(case when current_drugs_used.value_coded = 'Aspirin' then current_drugs_used.value_coded end) as aspirin,
    max(case when current_drugs_used.value_coded = 'Atenolol' then current_drugs_used.value_coded end) as bb_aten,
    max(case when current_drugs_used.value_coded = 'Bisoprolol' then current_drugs_used.value_coded end) as bb_bis,
    max(case when current_drugs_used.value_coded = 'Propranolol' then current_drugs_used.value_coded end) as bb_prop,
    max(case when current_drugs_used.value_coded = 'Benzathine penicillin' then current_drugs_used.value_coded end) as benzathine,
    max(bibasilar_crackles.value_coded) as bibasilar_crackles,
    max(diastolic_blood_pressure.value_numeric) as bp_diastolic,
    max(systolic_blood_pressure.value_numeric) as bp_systolic,
    max(case when current_drugs_used.value_coded = 'Amlodipine' then current_drugs_used.value_coded end) as ccb_aml,
    max(case when current_drugs_used.value_coded = 'Nifedipine' then current_drugs_used.value_coded end) as ccb_nif,
    max(concern_for_depression_or_anxiety.value_coded) as concern_for_depression_or_anxiety,
    max(low_salt_diet_recommended.value_coded) as diet_salt_or_fluid,
    max(case when current_drugs_used.value_coded = 'Furosemide' then current_drugs_used.value_coded end) as diuretic_furo,
    max(case when current_drugs_used.value_coded = 'Hydrochlorothiazide' then current_drugs_used.value_coded end) as diuretic_hctz,
    max(case when current_drugs_used.value_coded = 'Spironolactone' then current_drugs_used.value_coded end) as diuretic_spiro,
    max(level_of_dry_cough.value_coded) as dry_cough,
    max(dyspnea_on_extertion.value_coded) as dyspnea_on_exertion,
    max(level_of_fatigue.value_coded) as fatigue,
    max(pulse.value_numeric) as heart_rate,
    max(height_cm.value_numeric) as height,
    max(hospitalized_for_non_communicable_disease_since_last_visit.value_coded) as hospitalized_since_last_visit_for_ncd,
    max(jugular_venous_pressure_elevated.value_coded) as jvp_elevated,
    max(mental_health_referral.value_coded) as mental_health_referral,
    max(appointment_date.value_date) as next_appointment_date,
    max(nyha_class.value_coded) as nyha_stage,
    max(oedema.value_coded) as oedema,
    max(level_of_orthopnea.value_coded) as orthopnea,
    max(other_chronic_heart_failure_drugs.value_text) as other_medications,
    max(palliative_care_referral.value_coded) as palliative_referral,
    max(follow_up_agreement.value_coded) as request_chw_f_u,
    max(salt_or_fluid_restricted.value_coded) as salt_or_fluid_restricted,
    max(blood_oxygen_saturation.value_numeric) as spo2,
    max(smoking_history.value_coded) as tobacco,
    max(took_medications_today.value_coded) as took_medications_today,
    max(patients_fluid_management.value_coded) as volume_status,
    max(weight_kg.value_numeric) as weight,
    max(weight_change.value_text) as weight_change
from omrs_encounter e
left join temp_med_aspirin med_aspirin on e.encounter_id = med_aspirin.encounter_id
left join temp_med_hctz med_hctz on e.encounter_id = med_hctz.encounter_id
left join temp_med_furosemide med_furosemide on e.encounter_id = med_furosemide.encounter_id
left join temp_med_spironolactone med_spironolactone on e.encounter_id = med_spironolactone.encounter_id
left join temp_med_enalapril med_enalapril on e.encounter_id = med_enalapril.encounter_id
left join temp_med_captopril med_captopril on e.encounter_id = med_captopril.encounter_id
left join temp_med_lisinopril med_lisinopril on e.encounter_id = med_lisinopril.encounter_id
left join temp_med_atenolol med_atenolol on e.encounter_id = med_atenolol.encounter_id
left join temp_med_bisoprolol med_bisoprolol on e.encounter_id = med_bisoprolol.encounter_id
left join temp_med_propranolol med_propranolol on e.encounter_id = med_propranolol.encounter_id
left join temp_med_amlodipine med_amlodipine on e.encounter_id = med_amlodipine.encounter_id
left join temp_med_nifedipine med_nifedipine on e.encounter_id = med_nifedipine.encounter_id
left join temp_med_benzathine med_benzathine on e.encounter_id = med_benzathine.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_bibasilar_crackles bibasilar_crackles on e.encounter_id = bibasilar_crackles.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_concern_for_depression_or_anxiety concern_for_depression_or_anxiety on e.encounter_id = concern_for_depression_or_anxiety.encounter_id
left join temp_low_salt_diet_recommended low_salt_diet_recommended on e.encounter_id = low_salt_diet_recommended.encounter_id
left join temp_level_of_dry_cough level_of_dry_cough on e.encounter_id = level_of_dry_cough.encounter_id
left join temp_dyspnea_on_extertion dyspnea_on_extertion on e.encounter_id = dyspnea_on_extertion.encounter_id
left join temp_level_of_fatigue level_of_fatigue on e.encounter_id = level_of_fatigue.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_hospitalized_non_communicable_disease_since hospitalized_for_non_communicable_disease_since_last_visit on e.encounter_id = hospitalized_for_non_communicable_disease_since_last_visit.encounter_id
left join temp_jugular_venous_pressure_elevated jugular_venous_pressure_elevated on e.encounter_id = jugular_venous_pressure_elevated.encounter_id
left join temp_mental_health_referral mental_health_referral on e.encounter_id = mental_health_referral.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_nyha_class nyha_class on e.encounter_id = nyha_class.encounter_id
left join temp_oedema oedema on e.encounter_id = oedema.encounter_id
left join temp_level_of_orthopnea level_of_orthopnea on e.encounter_id = level_of_orthopnea.encounter_id
left join temp_other_chronic_heart_failure_drugs other_chronic_heart_failure_drugs on e.encounter_id = other_chronic_heart_failure_drugs.encounter_id
left join temp_palliative_care_referral palliative_care_referral on e.encounter_id = palliative_care_referral.encounter_id
left join temp_follow_up_agreement follow_up_agreement on e.encounter_id = follow_up_agreement.encounter_id
left join temp_salt_or_fluid_restricted salt_or_fluid_restricted on e.encounter_id = salt_or_fluid_restricted.encounter_id
left join temp_blood_oxygen_saturation blood_oxygen_saturation on e.encounter_id = blood_oxygen_saturation.encounter_id
left join temp_smoking_history smoking_history on e.encounter_id = smoking_history.encounter_id
left join temp_took_medications_today took_medications_today on e.encounter_id = took_medications_today.encounter_id
left join temp_patients_fluid_management patients_fluid_management on e.encounter_id = patients_fluid_management.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_weight_change weight_change on e.encounter_id = weight_change.encounter_id
where e.encounter_type in ('CHF_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;