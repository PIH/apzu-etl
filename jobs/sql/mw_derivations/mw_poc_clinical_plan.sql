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

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_outcome;
create temporary table temp_outcome as select encounter_id, value_coded from omrs_obs where concept = 'Outcome';
alter table temp_outcome add index temp_outcome_encounter_idx (encounter_id);

drop temporary table if exists temp_qualitative_time;
create temporary table temp_qualitative_time as select encounter_id, value_coded from omrs_obs where concept = 'Qualitative time';
alter table temp_qualitative_time add index temp_qualitative_time_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_to_stop_care_text;
create temporary table temp_reason_to_stop_care_text as select encounter_id, value_text from omrs_obs where concept = 'Reason to stop care (text)';
alter table temp_reason_to_stop_care_text add index temp_reason_to_stop_care_text_encounter_idx (encounter_id);

drop temporary table if exists temp_refer_to_screening_station;
create temporary table temp_refer_to_screening_station as select encounter_id, value_coded from omrs_obs where concept = 'Refer to screening station';
alter table temp_refer_to_screening_station add index temp_refer_to_screening_station_encounter_idx (encounter_id);

drop temporary table if exists temp_transfer_out_to;
create temporary table temp_transfer_out_to as select encounter_id, value_text from omrs_obs where concept = 'Transfer out to';
alter table temp_transfer_out_to add index temp_transfer_out_to_encounter_idx (encounter_id);

insert into mw_poc_clinical_plan
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(appointment_date.value_date) as appointment_date,
    max(clinical_impression_comments.value_text) as clinical_impression_comments,
    max(outcome.value_coded) as outcome,
    max(qualitative_time.value_coded) as qualitative_time,
    max(reason_to_stop_care_text.value_text) as reason_to_stop_care,
    max(refer_to_screening_station.value_coded) as refer_to_screening_station,
    max(transfer_out_to.value_text) as transfer_out_to
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_outcome outcome on e.encounter_id = outcome.encounter_id
left join temp_qualitative_time qualitative_time on e.encounter_id = qualitative_time.encounter_id
left join temp_reason_to_stop_care_text reason_to_stop_care_text on e.encounter_id = reason_to_stop_care_text.encounter_id
left join temp_refer_to_screening_station refer_to_screening_station on e.encounter_id = refer_to_screening_station.encounter_id
left join temp_transfer_out_to transfer_out_to on e.encounter_id = transfer_out_to.encounter_id
where e.encounter_type in ('Clinical Plan')
group by e.patient_id, e.encounter_date, e.location;