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

-- Build temp_medications in three steps to avoid a full scan of the ~20M-row omrs_obs table.
-- Step 1: pull only the drug-name obs for this encounter type (~20M rows → small set).
-- Step 2: pull only the detail obs whose obs_group_id appears in step 1 (indexed lookup).
-- Step 3: join the two small tables to produce one row per drug per encounter.
drop temporary table if exists temp_drug_name_obs;
create temporary table temp_drug_name_obs as
select obs_id, encounter_id, obs_group_id, value_coded as drug_name
from omrs_obs
where concept = 'Current drugs used'
  and encounter_type = 'EPILEPSY_FOLLOWUP';
alter table temp_drug_name_obs add index temp_drug_name_obs_group_idx (obs_group_id);
alter table temp_drug_name_obs add index temp_drug_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_drug_detail_obs;
create temporary table temp_drug_detail_obs as
select obs_group_id, concept, value_coded, value_numeric
from omrs_obs
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

drop temporary table if exists temp_med_values;
create temporary table temp_med_values as
select
    encounter_id,
    max(case when drug_name = 'Carbamazepine'    then drug_name    end) as med_carbamazepine,
    max(case when drug_name = 'Carbamazepine'    then dose         end) as med_carbamazepine_dose,
    max(case when drug_name = 'Carbamazepine'    then dosing_unit  end) as med_carbamazepine_dosing_unit,
    max(case when drug_name = 'Carbamazepine'    then route        end) as med_carbamazepine_route,
    max(case when drug_name = 'Carbamazepine'    then frequency    end) as med_carbamazepine_frequency,
    max(case when drug_name = 'Carbamazepine'    then duration     end) as med_carbamazepine_duration,
    max(case when drug_name = 'Carbamazepine'    then duration_units end) as med_carbamazepine_duration_units,
    max(case when drug_name = 'Phenobarbital'    then drug_name    end) as med_Phenobarbital,
    max(case when drug_name = 'Phenobarbital'    then dose         end) as med_Phenobarbital_dose,
    max(case when drug_name = 'Phenobarbital'    then dosing_unit  end) as med_Phenobarbital_dosing_unit,
    max(case when drug_name = 'Phenobarbital'    then route        end) as med_Phenobarbital_route,
    max(case when drug_name = 'Phenobarbital'    then frequency    end) as med_Phenobarbital_frequency,
    max(case when drug_name = 'Phenobarbital'    then duration     end) as med_Phenobarbital_duration,
    max(case when drug_name = 'Phenobarbital'    then duration_units end) as med_Phenobarbital_duration_units,
    max(case when drug_name = 'Phenytoin'        then drug_name    end) as med_Phenytoin,
    max(case when drug_name = 'Phenytoin'        then dose         end) as med_Phenytoin_dose,
    max(case when drug_name = 'Phenytoin'        then dosing_unit  end) as med_Phenytoin_dosing_unit,
    max(case when drug_name = 'Phenytoin'        then route        end) as med_Phenytoin_route,
    max(case when drug_name = 'Phenytoin'        then frequency    end) as med_Phenytoin_frequency,
    max(case when drug_name = 'Phenytoin'        then duration     end) as med_Phenytoin_duration,
    max(case when drug_name = 'Phenytoin'        then duration_units end) as med_Phenytoin_duration_units,
    max(case when drug_name = 'Sodium valproate' then drug_name    end) as med_Sodium_Valproate,
    max(case when drug_name = 'Sodium valproate' then dose         end) as med_Sodium_Valproate_dose,
    max(case when drug_name = 'Sodium valproate' then dosing_unit  end) as med_Sodium_Valproate_dosing_unit,
    max(case when drug_name = 'Sodium valproate' then route        end) as med_Sodium_Valproate_route,
    max(case when drug_name = 'Sodium valproate' then frequency    end) as med_Sodium_Valproate_frequency,
    max(case when drug_name = 'Sodium valproate' then duration     end) as med_Sodium_Valproate_duration,
    max(case when drug_name = 'Sodium valproate' then duration_units end) as med_Sodium_Valproate_duration_units
from temp_medications
group by encounter_id;
alter table temp_med_values add index temp_med_values_encounter_idx (encounter_id);

drop temporary table if exists temp_epilepsy_followup_obs;
create temporary table temp_epilepsy_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'EPILEPSY_FOLLOWUP';
alter table temp_epilepsy_followup_obs add index temp_epilepsy_followup_obs_concept_idx (concept);
alter table temp_epilepsy_followup_obs add index temp_epilepsy_followup_obs_encounter_idx (encounter_id);
alter table temp_epilepsy_followup_obs add index temp_epilepsy_followup_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Alcohol trigger'                                                                        then value_coded end) as alcohol_trigger,
    max(case when concept = 'Any seizure occurred since last visit'                                                                                      then value_coded end) as seizure_since_last_visit,
    max(case when concept = 'Any seizure triggers present'                                                                                               then value_coded end) as any_triggers,
    max(case when concept = 'Appointment date'                                                                                                           then value_date  end) as next_appointment_date,
    max(case when concept = 'Body Mass Index, coded'                                                                                                     then value_coded end) as bmi,
    max(case when concept = 'Clinical impression comments'                                                                                               then value_text  end) as comments,
    max(case when concept = 'Current drugs used' and value_coded = 'Other'                                                                               then value_coded end) as med_other,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Emotional stress, anger, boredom'                                                      then value_coded end) as emotional_stress_anger_boredom_trigger,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Fever trigger'                                                                         then value_coded end) as fever_trigger,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Menstruation trigger'                                                                  then value_coded end) as menstruation_trigger,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Missed medication trigger'                                                             then value_coded end) as missed_medication_trigger,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Sleep deprivation and overtired'                                                       then value_coded end) as sleep_deprivation_and_overtired_trigger,
    max(case when concept = 'Epilepsy trigger' and value_coded = 'Sound, light, and touch'                                                               then value_coded end) as sound_light_and_touch_trigger,
    max(case when concept = 'Family planning'                                                                                                            then value_coded end) as family_planning,
    max(case when concept = 'Height (cm)'                                                                                                                then value_numeric end) as height,
    max(case when concept = 'Is patient pregnant?'                                                                                                       then value_coded end) as pregnant,
    max(case when concept = 'NUMBER OF SEIZURES'                                                                                                         then value_numeric end) as number_of_seizures,
    max(case when concept = 'Patient hospitalized since last visit'                                                                                      then value_coded end) as hospitalized_since_last_visit,
    max(case when concept = 'Symptoms during seizure'                                                                                                    then value_coded end) as silent_makers,
    max(case when concept = 'Weight (kg)'                                                                                                                then value_numeric end) as weight
from temp_epilepsy_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_epilepsy_followup (patient_id, visit_date, location, med_carbamazepine_frequency, med_phenobarbital_frequency, med_sodium_valproate_frequency, med_sodium_valproate_route, any_triggers, med_carbamazepine_dose, med_carbamazepine_dosing_unit, med_carbamazepine_duration, med_carbamazepine_duration_units, med_carbamazepine_route, family_planning, height, hospitalized_since_last_visit, med_carbamazepine, number_of_seizures, med_phenobarbital_dose, med_phenobarbital_dosing_unit, med_phenobarbital_duration, med_phenobarbital_duration_units, med_phenobarbital_route, med_phenytoin_dose, med_phenytoin_dosing_unit, med_phenytoin_duration, med_phenytoin_duration_units, med_phenytoin_frequency, med_phenytoin_route, pregnant, silent_makers, med_sodium_valproate_dose, med_sodium_valproate_dosing_unit, med_sodium_valproate_duration, med_sodium_valproate_duration_units, alcohol_trigger, bmi, emotional_stress_anger_boredom_trigger, fever_trigger, menstruation_trigger, missed_medication_trigger, seizure_since_last_visit, sleep_deprivation_and_overtired_trigger, sound_light_and_touch_trigger, weight, comments, med_phenobarbital, med_phenytoin, med_sodium_valproate, med_other, next_appointment_date)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    mv.med_carbamazepine_frequency,
    mv.med_Phenobarbital_frequency,
    mv.med_Sodium_Valproate_frequency,
    mv.med_Sodium_Valproate_route,
    max(sv.any_triggers) as any_triggers,
    mv.med_carbamazepine_dose,
    mv.med_carbamazepine_dosing_unit,
    mv.med_carbamazepine_duration,
    mv.med_carbamazepine_duration_units,
    mv.med_carbamazepine_route,
    max(sv.family_planning) as family_planning,
    max(sv.height) as height,
    max(sv.hospitalized_since_last_visit) as hospitalized_since_last_visit,
    mv.med_carbamazepine,
    max(sv.number_of_seizures) as number_of_seizures,
    mv.med_Phenobarbital_dose,
    mv.med_Phenobarbital_dosing_unit,
    mv.med_Phenobarbital_duration,
    mv.med_Phenobarbital_duration_units,
    mv.med_Phenobarbital_route,
    mv.med_Phenytoin_dose,
    mv.med_Phenytoin_dosing_unit,
    mv.med_Phenytoin_duration,
    mv.med_Phenytoin_duration_units,
    mv.med_Phenytoin_frequency,
    mv.med_Phenytoin_route,
    max(sv.pregnant) as pregnant,
    max(sv.silent_makers) as silent_makers,
    mv.med_Sodium_Valproate_dose,
    mv.med_Sodium_Valproate_dosing_unit,
    mv.med_Sodium_Valproate_duration,
    mv.med_Sodium_Valproate_duration_units,
    max(sv.alcohol_trigger) as alcohol_trigger,
    max(sv.bmi) as bmi,
    max(sv.emotional_stress_anger_boredom_trigger) as emotional_stress_anger_boredom_trigger,
    max(sv.fever_trigger) as fever_trigger,
    max(sv.menstruation_trigger) as menstruation_trigger,
    max(sv.missed_medication_trigger) as missed_medication_trigger,
    max(sv.seizure_since_last_visit) as seizure_since_last_visit,
    max(sv.sleep_deprivation_and_overtired_trigger) as sleep_deprivation_and_overtired_trigger,
    max(sv.sound_light_and_touch_trigger) as sound_light_and_touch_trigger,
    max(sv.weight) as weight,
    max(sv.comments) as comments,
    mv.med_Phenobarbital,
    mv.med_Phenytoin,
    mv.med_Sodium_Valproate,
    max(sv.med_other) as med_other,
    max(sv.next_appointment_date) as next_appointment_date
from omrs_encounter e
left join temp_med_values mv on mv.encounter_id = e.encounter_id
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('EPILEPSY_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_drug_name_obs;
drop temporary table if exists temp_drug_detail_obs;
drop temporary table if exists temp_medications;
drop temporary table if exists temp_med_values;
drop temporary table if exists temp_epilepsy_followup_obs;
drop temporary table if exists temp_single_values;
