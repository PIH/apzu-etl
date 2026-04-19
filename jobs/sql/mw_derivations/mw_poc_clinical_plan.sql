-- Derivation script for mw_poc_clinical_plan
-- Generated from Pentaho transform: import-into-mw-poc-clinical-plan.ktr

drop table if exists mw_poc_clinical_plan;
create table mw_poc_clinical_plan (
    poc_clinical_plan_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    appointment_date date,
    qualitative_time varchar(255),
    outcome varchar(255),
    clinical_impression_comments varchar(500),
    refer_to_screening_station varchar(255),
    transfer_out_to varchar(255),
    reason_to_stop_care varchar(255),
    primary key (poc_clinical_plan_visit_id)
);

insert into mw_poc_clinical_plan
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Appointment date' then o.value_date end) as appointment_date,
    max(case when o.concept = 'Clinical impression comments' then o.value_text end) as clinical_impression_comments,
    max(case when o.concept = 'Outcome' then o.value_coded end) as outcome,
    max(case when o.concept = 'Qualitative time' then o.value_coded end) as qualitative_time,
    max(case when o.concept = 'Reason to stop care (text)' then o.value_text end) as reason_to_stop_care,
    max(case when o.concept = 'Refer to screening station' then o.value_coded end) as refer_to_screening_station,
    max(case when o.concept = 'Transfer out to' then o.value_text end) as transfer_out_to
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Clinical Plan')
group by e.patient_id, e.encounter_date, e.location;