-- Derivation script for mw_epilepsy_followup
-- Generated from Pentaho transform: import-into-mw-epilepsy-followup.ktr

drop table if exists mw_epilepsy_followup;
create table mw_epilepsy_followup (
  epilepsy_followup_visit_id 			int not null auto_increment,
  patient_id 					int not null,
  visit_date 					date not null,
  location 					varchar(255) not null,
  height 					int,
  weight 					int,
  bmi 						varchar(255),
  seizure_since_last_visit 			varchar(255),
  number_of_seizures 				int,
  any_triggers 				varchar(255),
  alcohol_trigger 				varchar(255),
  fever_trigger 				varchar(255),
  sound_light_and_touch_trigger 		varchar(255),
  emotional_stress_anger_boredom_trigger 	varchar(255),
  sleep_deprivation_and_overtired_trigger 	varchar(255),
  missed_medication_trigger 			varchar(255),
  menstruation_trigger 			varchar(255),
  silent_makers 				varchar(255),
  hospitalized_since_last_visit 		varchar(255),
  pregnant 					varchar(255),
  family_planning 				varchar(255),
  med_carbamazepine 				varchar(255),
  med_carbamazepine_dose		int,
  med_carbamazepine_dosing_unit varchar(50),
  med_carbamazepine_route		varchar(50),
  med_carbamazepine_frequency		varchar(50),
  med_carbamazepine_duration   int,
  med_carbamazepine_duration_units  varchar(50),
  med_Phenobarbital 				varchar(255),
  med_Phenobarbital_dose		int,
  med_Phenobarbital_dosing_unit varchar(50),
  med_Phenobarbital_route		varchar(50),
  med_Phenobarbital_frequency		varchar(50),
  med_Phenobarbital_duration   int,
  med_Phenobarbital_duration_units  varchar(50),
  med_Phenytoin 				varchar(255),
  med_Phenytoin_dose		int,
  med_Phenytoin_dosing_unit varchar(50),
  med_Phenytoin_route		varchar(50),
  med_Phenytoin_frequency		varchar(50),
  med_Phenytoin_duration   int,
  med_Phenytoin_duration_units  varchar(50),
  med_Sodium_Valproate 			varchar(255),
  med_Sodium_Valproate_dose		int,
  med_Sodium_Valproate_dosing_unit varchar(50),
  med_Sodium_Valproate_route		varchar(50),
  med_Sodium_Valproate_frequency		varchar(50),
  med_Sodium_Valproate_duration   int,
  med_Sodium_Valproate_duration_units  varchar(50),
  med_other 					varchar(255),
  comments 					varchar(2000) ,
  next_appointment_date 			date,
  primary key (epilepsy_followup_visit_id)
);

drop temporary table if exists temp_drug_frequency_coded;
create temporary table temp_drug_frequency_coded as select encounter_id, value_coded from omrs_obs where concept = 'Drug frequency coded';
alter table temp_drug_frequency_coded add index temp_drug_frequency_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_routes_of_administration_coded;
create temporary table temp_routes_of_administration_coded as select encounter_id, value_coded from omrs_obs where concept = 'Routes of administration (coded)';
alter table temp_routes_of_administration_coded add index temp_routes_of_administration_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_any_seizure_triggers_present;
create temporary table temp_any_seizure_triggers_present as select encounter_id, value_coded from omrs_obs where concept = 'Any seizure triggers present';
alter table temp_any_seizure_triggers_present add index temp_any_seizure_triggers_present_encounter_idx (encounter_id);

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

drop temporary table if exists temp_family_planning;
create temporary table temp_family_planning as select encounter_id, value_coded from omrs_obs where concept = 'Family planning';
alter table temp_family_planning add index temp_family_planning_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_hospitalized_since_last_visit;
create temporary table temp_patient_hospitalized_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Patient hospitalized since last visit';
alter table temp_patient_hospitalized_since_last_visit add index temp_patient_hospitalized_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from omrs_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_seizures;
create temporary table temp_number_of_seizures as select encounter_id, value_numeric from omrs_obs where concept = 'NUMBER OF SEIZURES';
alter table temp_number_of_seizures add index temp_number_of_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_is_patient_pregnant;
create temporary table temp_is_patient_pregnant as select encounter_id, value_coded from omrs_obs where concept = 'Is patient pregnant?';
alter table temp_is_patient_pregnant add index temp_is_patient_pregnant_encounter_idx (encounter_id);

drop temporary table if exists temp_symptoms_during_seizure;
create temporary table temp_symptoms_during_seizure as select encounter_id, value_coded from omrs_obs where concept = 'Symptoms during seizure';
alter table temp_symptoms_during_seizure add index temp_symptoms_during_seizure_encounter_idx (encounter_id);

drop temporary table if exists temp_epilepsy_trigger;
create temporary table temp_epilepsy_trigger as select encounter_id, value_coded from omrs_obs where concept = 'Epilepsy trigger';
alter table temp_epilepsy_trigger add index temp_epilepsy_trigger_encounter_idx (encounter_id);

drop temporary table if exists temp_body_mass_index_coded;
create temporary table temp_body_mass_index_coded as select encounter_id, value_coded from omrs_obs where concept = 'Body Mass Index, coded';
alter table temp_body_mass_index_coded add index temp_body_mass_index_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_any_seizure_occurred_since_last_visit;
create temporary table temp_any_seizure_occurred_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Any seizure occurred since last visit';
alter table temp_any_seizure_occurred_since_last_visit add index temp_seizure_occurred_since_last_visit_encounter (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

insert into mw_epilepsy_followup (patient_id, visit_date, location, med_carbamazepine_frequency, med_phenobarbital_frequency, med_sodium_valproate_frequency, med_sodium_valproate_route, any_triggers, med_carbamazepine_dose, med_carbamazepine_dosing_unit, med_carbamazepine_duration, med_carbamazepine_duration_units, med_carbamazepine_route, family_planning, height, hospitalized_since_last_visit, med_carbamazepine, number_of_seizures, med_phenobarbital_dose, med_phenobarbital_dosing_unit, med_phenobarbital_duration, med_phenobarbital_duration_units, med_phenobarbital_route, med_phenytoin_dose, med_phenytoin_dosing_unit, med_phenytoin_duration, med_phenytoin_duration_units, med_phenytoin_frequency, med_phenytoin_route, pregnant, silent_makers, med_sodium_valproate_dose, med_sodium_valproate_dosing_unit, med_sodium_valproate_duration, med_sodium_valproate_duration_units, alcohol_trigger, bmi, emotional_stress_anger_boredom_trigger, fever_trigger, menstruation_trigger, missed_medication_trigger, seizure_since_last_visit, sleep_deprivation_and_overtired_trigger, sound_light_and_touch_trigger, weight, comments, med_phenobarbital, med_phenytoin, med_sodium_valproate, med_other, next_appointment_date)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(drug_frequency_coded.value_coded) as med_carbamazepine_frequency,
    max(drug_frequency_coded.value_coded) as med_Phenobarbital_frequency,
    max(drug_frequency_coded.value_coded) as med_sodium_valproate_frequency,
    max(routes_of_administration_coded.value_coded) as med_sodium_valproate_route,
    max(any_seizure_triggers_present.value_coded) as any_triggers,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_carbamazepine_dose,
    max(dosing_unit.value_coded) as med_carbamazepine_dosing_unit,
    max(medication_duration.value_numeric) as med_carbamazepine_duration,
    max(time_units.value_coded) as med_carbamazepine_duration_units,
    max(routes_of_administration_coded.value_coded) as med_carbamazepine_route,
    max(family_planning.value_coded) as family_planning,
    max(height_cm.value_numeric) as height,
    max(patient_hospitalized_since_last_visit.value_coded) as hospitalized_since_last_visit,
    max(case when current_drugs_used.value_coded = 'Carbamazepine' then current_drugs_used.value_coded end) as med_carbamazepine,
    max(number_of_seizures.value_numeric) as number_of_seizures,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_Phenobarbital_dose,
    max(dosing_unit.value_coded) as med_Phenobarbital_dosing_unit,
    max(medication_duration.value_numeric) as med_Phenobarbital_duration,
    max(time_units.value_coded) as med_Phenobarbital_duration_units,
    max(routes_of_administration_coded.value_coded) as med_Phenobarbital_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_Phenytoin_dose,
    max(dosing_unit.value_coded) as med_Phenytoin_dosing_unit,
    max(medication_duration.value_numeric) as med_Phenytoin_duration,
    max(time_units.value_coded) as med_Phenytoin_duration_units,
    max(drug_frequency_coded.value_coded) as med_Phenytoin_frequency,
    max(routes_of_administration_coded.value_coded) as med_Phenytoin_route,
    max(is_patient_pregnant.value_coded) as pregnant,
    max(symptoms_during_seizure.value_coded) as silent_makers,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_sodium_valproate_dose,
    max(dosing_unit.value_coded) as med_sodium_valproate_dosing_unit,
    max(medication_duration.value_numeric) as med_sodium_valproate_duration,
    max(time_units.value_coded) as med_sodium_valproate_duration_units,
    max(case when epilepsy_trigger.value_coded = 'Alcohol trigger' then epilepsy_trigger.value_coded end) as alcohol_trigger,
    max(body_mass_index_coded.value_coded) as bmi,
    max(case when epilepsy_trigger.value_coded = 'Emotional stress, anger, boredom' then epilepsy_trigger.value_coded end) as emotional_stress_anger_boredom_trigger,
    max(case when epilepsy_trigger.value_coded = 'Fever trigger' then epilepsy_trigger.value_coded end) as fever_trigger,
    max(case when epilepsy_trigger.value_coded = 'Menstruation trigger' then epilepsy_trigger.value_coded end) as menstruation_trigger,
    max(case when epilepsy_trigger.value_coded = 'Missed medication trigger' then epilepsy_trigger.value_coded end) as missed_medication_trigger,
    max(any_seizure_occurred_since_last_visit.value_coded) as seizure_since_last_visit,
    max(case when epilepsy_trigger.value_coded = 'Sleep deprivation and overtired' then epilepsy_trigger.value_coded end) as sleep_deprivation_and_overtired_trigger,
    max(case when epilepsy_trigger.value_coded = 'Sound, light, and touch' then epilepsy_trigger.value_coded end) as sound_light_and_touch_trigger,
    max(weight_kg.value_numeric) as weight,
    max(clinical_impression_comments.value_text) as comments,
    max(case when current_drugs_used.value_coded = 'Phenobarbital' then current_drugs_used.value_coded end) as med_phenobarbital,
    max(case when current_drugs_used.value_coded = 'Phenytoin' then current_drugs_used.value_coded end) as med_phenytoin,
    max(case when current_drugs_used.value_coded = 'Sodium valproate' then current_drugs_used.value_coded end) as med_sodium_valproate,
    max(case when current_drugs_used.value_coded = 'Other' then current_drugs_used.value_coded end) as med_other,
    max(appointment_date.value_date) as next_appointment_date
from omrs_encounter e
left join temp_drug_frequency_coded drug_frequency_coded on e.encounter_id = drug_frequency_coded.encounter_id
left join temp_routes_of_administration_coded routes_of_administration_coded on e.encounter_id = routes_of_administration_coded.encounter_id
left join temp_any_seizure_triggers_present any_seizure_triggers_present on e.encounter_id = any_seizure_triggers_present.encounter_id
left join temp_quantity_of_medication_prescribed_per_dose quantity_of_medication_prescribed_per_dose on e.encounter_id = quantity_of_medication_prescribed_per_dose.encounter_id
left join temp_dosing_unit dosing_unit on e.encounter_id = dosing_unit.encounter_id
left join temp_medication_duration medication_duration on e.encounter_id = medication_duration.encounter_id
left join temp_time_units time_units on e.encounter_id = time_units.encounter_id
left join temp_family_planning family_planning on e.encounter_id = family_planning.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_patient_hospitalized_since_last_visit patient_hospitalized_since_last_visit on e.encounter_id = patient_hospitalized_since_last_visit.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_number_of_seizures number_of_seizures on e.encounter_id = number_of_seizures.encounter_id
left join temp_is_patient_pregnant is_patient_pregnant on e.encounter_id = is_patient_pregnant.encounter_id
left join temp_symptoms_during_seizure symptoms_during_seizure on e.encounter_id = symptoms_during_seizure.encounter_id
left join temp_epilepsy_trigger epilepsy_trigger on e.encounter_id = epilepsy_trigger.encounter_id
left join temp_body_mass_index_coded body_mass_index_coded on e.encounter_id = body_mass_index_coded.encounter_id
left join temp_any_seizure_occurred_since_last_visit any_seizure_occurred_since_last_visit on e.encounter_id = any_seizure_occurred_since_last_visit.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
where e.encounter_type in ('EPILEPSY_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;