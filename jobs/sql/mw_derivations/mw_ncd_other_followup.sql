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

insert into mw_ncd_other_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'History of alcohol use' then o.value_coded end) as alcohol,
    max(case when o.concept = 'Diastolic blood pressure' then o.value_numeric end) as bp_diastolic,
    max(case when o.concept = 'Systolic blood pressure' then o.value_numeric end) as bp_systolic,
    max(case when o.concept = 'General comment' then o.value_text end) as comments,
    max(case when o.concept = 'Days per week of moderate exercise' then o.value_numeric end) as days_per_week_exercise,
    max(case when o.concept = 'Number of servings of fruits and vegetables consumed per day' then o.value_numeric end) as fruit_and_vegetable_portions,
    max(case when o.concept = 'Pulse' then o.value_numeric end) as heart_rate,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Patient hospitalized since last visit' then o.value_coded end) as hospitalized_since_last_visit_for_ncd,
    max(case when o.concept = 'Medications dispensed' then o.value_text end) as medications,
    max(case when o.concept = 'Has the treatment changed at this visit?' then o.value_coded end) as medications_changed,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Next appointment location' then o.value_coded end) as next_appointment_location,
    max(case when o.concept = 'Blood oxygen saturation' then o.value_numeric end) as spo2,
    max(case when o.concept = 'Smoking history' then o.value_coded end) as tobacco,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight,
    max(case when o.concept = 'Weight change' then o.value_text end) as weight_change
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('NCD_OTHER_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;