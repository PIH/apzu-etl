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

drop temporary table if exists temp_quantity_of_medication_prescribed_per_dose;
create temporary table temp_quantity_of_medication_prescribed_per_dose as select encounter_id, value_numeric from omrs_obs where concept = 'Quantity of medication prescribed per dose';
alter table temp_quantity_of_medication_prescribed_per_dose add index temp_quantity_of_medication_prescribed_per_dose_encounter_idx (encounter_id);

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

drop temporary table if exists temp_bibasilar_crackles;
create temporary table temp_bibasilar_crackles as select encounter_id, value_coded from omrs_obs where concept = 'Bibasilar crackles';
alter table temp_bibasilar_crackles add index temp_bibasilar_crackles_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_concern_for_depression_or_anxiety;
create temporary table temp_concern_for_depression_or_anxiety as select encounter_id, value_coded from omrs_obs where concept = 'Concern for depression or anxiety';
alter table temp_concern_for_depression_or_anxiety add index temp_concern_for_depression_or_anxiety_encounter_idx (encounter_id);

drop temporary table if exists temp_low_salt_diet_recommended;
create temporary table temp_low_salt_diet_recommended as select encounter_id, value_coded from omrs_obs where concept = 'Low salt diet recommended';
alter table temp_low_salt_diet_recommended add index temp_low_salt_diet_recommended_encounter_idx (encounter_id);

drop temporary table if exists temp_level_of_dry_cough;
create temporary table temp_level_of_dry_cough as select encounter_id, value_coded from omrs_obs where concept = 'Level of dry cough';
alter table temp_level_of_dry_cough add index temp_level_of_dry_cough_encounter_idx (encounter_id);

drop temporary table if exists temp_dyspnea_on_extertion;
create temporary table temp_dyspnea_on_extertion as select encounter_id, value_coded from omrs_obs where concept = 'Dyspnea on extertion';
alter table temp_dyspnea_on_extertion add index temp_dyspnea_on_extertion_encounter_idx (encounter_id);

drop temporary table if exists temp_level_of_fatigue;
create temporary table temp_level_of_fatigue as select encounter_id, value_coded from omrs_obs where concept = 'Level of fatigue';
alter table temp_level_of_fatigue add index temp_level_of_fatigue_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_hospitalized_for_non_communicable_disease_since_last_visit;
create temporary table temp_hospitalized_for_non_communicable_disease_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Hospitalized for non-communicable disease since last visit';
alter table temp_hospitalized_for_non_communicable_disease_since_last_visit add index temp_hospitalized_for_ncd_since_last_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_jugular_venous_pressure_elevated;
create temporary table temp_jugular_venous_pressure_elevated as select encounter_id, value_coded from omrs_obs where concept = 'Jugular venous pressure elevated';
alter table temp_jugular_venous_pressure_elevated add index temp_jugular_venous_pressure_elevated_encounter_idx (encounter_id);

drop temporary table if exists temp_mental_health_referral;
create temporary table temp_mental_health_referral as select encounter_id, value_coded from omrs_obs where concept = 'Mental health referral';
alter table temp_mental_health_referral add index temp_mental_health_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_nyha_class;
create temporary table temp_nyha_class as select encounter_id, value_coded from omrs_obs where concept = 'Nyha class';
alter table temp_nyha_class add index temp_nyha_class_encounter_idx (encounter_id);

drop temporary table if exists temp_oedema;
create temporary table temp_oedema as select encounter_id, value_coded from omrs_obs where concept = 'Oedema';
alter table temp_oedema add index temp_oedema_encounter_idx (encounter_id);

drop temporary table if exists temp_level_of_orthopnea;
create temporary table temp_level_of_orthopnea as select encounter_id, value_coded from omrs_obs where concept = 'Level of orthopnea';
alter table temp_level_of_orthopnea add index temp_level_of_orthopnea_encounter_idx (encounter_id);

drop temporary table if exists temp_other_chronic_heart_failure_drugs;
create temporary table temp_other_chronic_heart_failure_drugs as select encounter_id, value_text from omrs_obs where concept = 'Other chronic heart failure drugs';
alter table temp_other_chronic_heart_failure_drugs add index temp_other_chronic_heart_failure_drugs_encounter_idx (encounter_id);

drop temporary table if exists temp_palliative_care_referral;
create temporary table temp_palliative_care_referral as select encounter_id, value_coded from omrs_obs where concept = 'Palliative care referral';
alter table temp_palliative_care_referral add index temp_palliative_care_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_follow_up_agreement;
create temporary table temp_follow_up_agreement as select encounter_id, value_coded from omrs_obs where concept = 'Follow up agreement';
alter table temp_follow_up_agreement add index temp_follow_up_agreement_encounter_idx (encounter_id);

drop temporary table if exists temp_salt_or_fluid_restricted;
create temporary table temp_salt_or_fluid_restricted as select encounter_id, value_coded from omrs_obs where concept = 'Salt or fluid restricted';
alter table temp_salt_or_fluid_restricted add index temp_salt_or_fluid_restricted_encounter_idx (encounter_id);

drop temporary table if exists temp_blood_oxygen_saturation;
create temporary table temp_blood_oxygen_saturation as select encounter_id, value_numeric from omrs_obs where concept = 'Blood oxygen saturation';
alter table temp_blood_oxygen_saturation add index temp_blood_oxygen_saturation_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from omrs_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

drop temporary table if exists temp_took_medications_today;
create temporary table temp_took_medications_today as select encounter_id, value_coded from omrs_obs where concept = 'Took medications today';
alter table temp_took_medications_today add index temp_took_medications_today_encounter_idx (encounter_id);

drop temporary table if exists temp_patients_fluid_management;
create temporary table temp_patients_fluid_management as select encounter_id, value_coded from omrs_obs where concept = 'Patients fluid management';
alter table temp_patients_fluid_management add index temp_patients_fluid_management_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_change;
create temporary table temp_weight_change as select encounter_id, value_text from omrs_obs where concept = 'Weight change';
alter table temp_weight_change add index temp_weight_change_encounter_idx (encounter_id);

insert into mw_chf_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as benzathine_dose,
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
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as asprin_asa_dose,
    max(dosing_unit.value_coded) as asprin_asa_dosing_unit,
    max(medication_duration.value_numeric) as asprin_asa_duration,
    max(time_units.value_coded) as asprin_asa_duration_units,
    max(drug_frequency_coded.value_coded) as asprin_asa_frequency,
    max(routes_of_administration_coded.value_coded) as asprin_asa_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as bb_aten_dose,
    max(dosing_unit.value_coded) as bb_aten_dosing_unit,
    max(medication_duration.value_numeric) as bb_aten_duration,
    max(time_units.value_coded) as bb_aten_duration_units,
    max(drug_frequency_coded.value_coded) as bb_aten_frequency,
    max(routes_of_administration_coded.value_coded) as bb_aten_route,
    max(dosing_unit.value_coded) as benzathine_dosing_unit,
    max(medication_duration.value_numeric) as benzathine_duration,
    max(time_units.value_coded) as benzathine_duration_units,
    max(drug_frequency_coded.value_coded) as benzathine_frequency,
    max(routes_of_administration_coded.value_coded) as benzathine_route,
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
left join temp_quantity_of_medication_prescribed_per_dose quantity_of_medication_prescribed_per_dose on e.encounter_id = quantity_of_medication_prescribed_per_dose.encounter_id
left join temp_dosing_unit dosing_unit on e.encounter_id = dosing_unit.encounter_id
left join temp_medication_duration medication_duration on e.encounter_id = medication_duration.encounter_id
left join temp_time_units time_units on e.encounter_id = time_units.encounter_id
left join temp_drug_frequency_coded drug_frequency_coded on e.encounter_id = drug_frequency_coded.encounter_id
left join temp_routes_of_administration_coded routes_of_administration_coded on e.encounter_id = routes_of_administration_coded.encounter_id
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
left join temp_hospitalized_for_non_communicable_disease_since_last_visit hospitalized_for_non_communicable_disease_since_last_visit on e.encounter_id = hospitalized_for_non_communicable_disease_since_last_visit.encounter_id
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