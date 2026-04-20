-- Derivation script for mw_ncd_other_followup
-- Generated from Pentaho transform: import-into-mw-ncd-other-followup.ktr

drop table if exists mw_ncd_other_followup;
create table mw_ncd_other_followup (
  ncd_other_followup_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  height int default null,
  weight int default null,
  weight_change varchar(255) default null,
  bp_systolic int default null,
  bp_diastolic int default null,
  heart_rate int default null,
  spo2 int default null,
  alcohol varchar(255) default null,
  tobacco varchar(255) default null,
  fruit_and_vegetable_portions int default null,
  days_per_week_exercise int default null,
  hospitalized_since_last_visit_for_ncd varchar(255) default null,
  medications varchar(255) default null,
  medications_changed varchar(255) default null,
  comments varchar(2000) default null,
  next_appointment_date date default null,
  next_appointment_location varchar(255) default null,
  primary key (ncd_other_followup_visit_id)
);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from omrs_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_general_comment;
create temporary table temp_general_comment as select encounter_id, value_text from omrs_obs where concept = 'General comment';
alter table temp_general_comment add index temp_general_comment_encounter_idx (encounter_id);

drop temporary table if exists temp_days_per_week_of_moderate_exercise;
create temporary table temp_days_per_week_of_moderate_exercise as select encounter_id, value_numeric from omrs_obs where concept = 'Days per week of moderate exercise';
alter table temp_days_per_week_of_moderate_exercise add index temp_days_per_week_of_moderate_exercise_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_servings_of_fruits_and_vegetables_consumed_per_day;
create temporary table temp_number_of_servings_of_fruits_and_vegetables_consumed_per_day as select encounter_id, value_numeric from omrs_obs where concept = 'Number of servings of fruits and vegetables consumed per day';
alter table temp_number_of_servings_of_fruits_and_vegetables_consumed_per_day add index temp_number_of_servings_of_fruits_and_vegetables_consumed_per_day_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_hospitalized_since_last_visit;
create temporary table temp_patient_hospitalized_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Patient hospitalized since last visit';
alter table temp_patient_hospitalized_since_last_visit add index temp_patient_hospitalized_since_last_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_medications_dispensed;
create temporary table temp_medications_dispensed as select encounter_id, value_text from omrs_obs where concept = 'Medications dispensed';
alter table temp_medications_dispensed add index temp_medications_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_has_the_treatment_changed_at_this_visit;
create temporary table temp_has_the_treatment_changed_at_this_visit as select encounter_id, value_coded from omrs_obs where concept = 'Has the treatment changed at this visit?';
alter table temp_has_the_treatment_changed_at_this_visit add index temp_has_the_treatment_changed_at_this_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_next_appointment_location;
create temporary table temp_next_appointment_location as select encounter_id, value_coded from omrs_obs where concept = 'Next appointment location';
alter table temp_next_appointment_location add index temp_next_appointment_location_encounter_idx (encounter_id);

drop temporary table if exists temp_blood_oxygen_saturation;
create temporary table temp_blood_oxygen_saturation as select encounter_id, value_numeric from omrs_obs where concept = 'Blood oxygen saturation';
alter table temp_blood_oxygen_saturation add index temp_blood_oxygen_saturation_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from omrs_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_change;
create temporary table temp_weight_change as select encounter_id, value_text from omrs_obs where concept = 'Weight change';
alter table temp_weight_change add index temp_weight_change_encounter_idx (encounter_id);

insert into mw_ncd_other_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(history_of_alcohol_use.value_coded) as alcohol,
    max(diastolic_blood_pressure.value_numeric) as bp_diastolic,
    max(systolic_blood_pressure.value_numeric) as bp_systolic,
    max(general_comment.value_text) as comments,
    max(days_per_week_of_moderate_exercise.value_numeric) as days_per_week_exercise,
    max(number_of_servings_of_fruits_and_vegetables_consumed_per_day.value_numeric) as fruit_and_vegetable_portions,
    max(pulse.value_numeric) as heart_rate,
    max(height_cm.value_numeric) as height,
    max(patient_hospitalized_since_last_visit.value_coded) as hospitalized_since_last_visit_for_ncd,
    max(medications_dispensed.value_text) as medications,
    max(has_the_treatment_changed_at_this_visit.value_coded) as medications_changed,
    max(appointment_date.value_date) as next_appointment_date,
    max(next_appointment_location.value_coded) as next_appointment_location,
    max(blood_oxygen_saturation.value_numeric) as spo2,
    max(smoking_history.value_coded) as tobacco,
    max(weight_kg.value_numeric) as weight,
    max(weight_change.value_text) as weight_change
from omrs_encounter e
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_general_comment general_comment on e.encounter_id = general_comment.encounter_id
left join temp_days_per_week_of_moderate_exercise days_per_week_of_moderate_exercise on e.encounter_id = days_per_week_of_moderate_exercise.encounter_id
left join temp_number_of_servings_of_fruits_and_vegetables_consumed_per_day number_of_servings_of_fruits_and_vegetables_consumed_per_day on e.encounter_id = number_of_servings_of_fruits_and_vegetables_consumed_per_day.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_patient_hospitalized_since_last_visit patient_hospitalized_since_last_visit on e.encounter_id = patient_hospitalized_since_last_visit.encounter_id
left join temp_medications_dispensed medications_dispensed on e.encounter_id = medications_dispensed.encounter_id
left join temp_has_the_treatment_changed_at_this_visit has_the_treatment_changed_at_this_visit on e.encounter_id = has_the_treatment_changed_at_this_visit.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_next_appointment_location next_appointment_location on e.encounter_id = next_appointment_location.encounter_id
left join temp_blood_oxygen_saturation blood_oxygen_saturation on e.encounter_id = blood_oxygen_saturation.encounter_id
left join temp_smoking_history smoking_history on e.encounter_id = smoking_history.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_weight_change weight_change on e.encounter_id = weight_change.encounter_id
where e.encounter_type in ('NCD_OTHER_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;