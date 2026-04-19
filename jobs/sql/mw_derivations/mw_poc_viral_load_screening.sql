-- Derivation script for mw_poc_viral_load_screening
-- Generated from Pentaho transform: import-into-mw-poc-viral-load-screening.ktr

drop table if exists mw_poc_viral_load_screening;
create table mw_poc_viral_load_screening (
    poc_viral_load_screening_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    creator varchar(255),
    sample_taken_for_viral_load varchar(255),
    lower_than_detection_limit varchar(255),
    reason_for_testing varchar(255),
    lab_location varchar(255),
    less_than_limit varchar(255),
    reason_for_no_result varchar(255),
    viral_load_sample_id varchar(255),
    reason_for_no_sample varchar(255),
    lab_id varchar(255),
    symptom_present varchar(255),
    symptom_absent varchar(255),
    primary key (poc_viral_load_screening_visit_id)
);

insert into mw_poc_viral_load_screening
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Sample taken for Viral Load' then o.value_coded end) as sample_taken_for_viral_Load,
    max(case when o.concept = 'Lab ID' then o.value_text end) as lab_id,
    max(case when o.concept = 'Location of laboratory' then o.value_coded end) as lab_location,
    max(case when o.concept = 'Less than limit' then o.value_numeric end) as less_than_limit,
    max(case when o.concept = 'Lower than Detection limit' then o.value_coded end) as lower_than_detection_limit,
    max(case when o.concept = 'Reason for no result' then o.value_coded end) as reason_for_no_result,
    max(case when o.concept = 'Reason for no sample' then o.value_coded end) as reason_for_no_sample,
    max(case when o.concept = 'Reason for testing (coded)' then o.value_coded end) as reason_for_testing,
    max(case when o.concept = 'Viral Load Sample ID' then o.value_text end) as viral_load_sample_id,
    max(case when o.concept = 'Symptom absent' then o.value_coded end) as symptom_absent,
    max(case when o.concept = 'Symptom present' then o.value_coded end) as symptom_present
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Viral Load Screening')
group by e.patient_id, e.encounter_date, e.location;