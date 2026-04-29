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

drop temporary table if exists temp_ncd_other_followup_obs;
create temporary table temp_ncd_other_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'NCD_OTHER_FOLLOWUP';
alter table temp_ncd_other_followup_obs add index temp_ncd_other_followup_obs_concept_idx (concept);
alter table temp_ncd_other_followup_obs add index temp_ncd_other_followup_obs_encounter_idx (encounter_id);
alter table temp_ncd_other_followup_obs add index temp_ncd_other_followup_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Appointment date'                                                    then value_date    end) as next_appointment_date,
    max(case when concept = 'Blood oxygen saturation'                                             then value_numeric end) as spo2,
    max(case when concept = 'Days per week of moderate exercise'                                  then value_numeric end) as days_per_week_exercise,
    max(case when concept = 'Diastolic blood pressure'                                            then value_numeric end) as bp_diastolic,
    max(case when concept = 'General comment'                                                     then value_text    end) as comments,
    max(case when concept = 'Has the treatment changed at this visit?'                            then value_coded   end) as medications_changed,
    max(case when concept = 'Height (cm)'                                                         then value_numeric end) as height,
    max(case when concept = 'History of alcohol use'                                              then value_coded   end) as alcohol,
    max(case when concept = 'Medications dispensed'                                               then value_text    end) as medications,
    max(case when concept = 'Next appointment location'                                           then value_coded   end) as next_appointment_location,
    max(case when concept = 'Number of servings of fruits and vegetables consumed per day'        then value_numeric end) as fruit_and_vegetable_portions,
    max(case when concept = 'Patient hospitalized since last visit'                               then value_coded   end) as hospitalized_since_last_visit_for_ncd,
    max(case when concept = 'Pulse'                                                               then value_numeric end) as heart_rate,
    max(case when concept = 'Smoking history'                                                     then value_coded   end) as tobacco,
    max(case when concept = 'Systolic blood pressure'                                             then value_numeric end) as bp_systolic,
    max(case when concept = 'Weight (kg)'                                                         then value_numeric end) as weight,
    max(case when concept = 'Weight change'                                                       then value_text    end) as weight_change
from temp_ncd_other_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_ncd_other_followup (patient_id, visit_date, location, alcohol, bp_diastolic, bp_systolic, comments, days_per_week_exercise, fruit_and_vegetable_portions, heart_rate, height, hospitalized_since_last_visit_for_ncd, medications, medications_changed, next_appointment_date, next_appointment_location, spo2, tobacco, weight, weight_change)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sv.alcohol) as alcohol,
    max(sv.bp_diastolic) as bp_diastolic,
    max(sv.bp_systolic) as bp_systolic,
    max(sv.comments) as comments,
    max(sv.days_per_week_exercise) as days_per_week_exercise,
    max(sv.fruit_and_vegetable_portions) as fruit_and_vegetable_portions,
    max(sv.heart_rate) as heart_rate,
    max(sv.height) as height,
    max(sv.hospitalized_since_last_visit_for_ncd) as hospitalized_since_last_visit_for_ncd,
    max(sv.medications) as medications,
    max(sv.medications_changed) as medications_changed,
    max(sv.next_appointment_date) as next_appointment_date,
    max(sv.next_appointment_location) as next_appointment_location,
    max(sv.spo2) as spo2,
    max(sv.tobacco) as tobacco,
    max(sv.weight) as weight,
    max(sv.weight_change) as weight_change
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('NCD_OTHER_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_ncd_other_followup_obs;
drop temporary table if exists temp_single_values;
