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

drop temporary table if exists temp_sample_taken_for_viral_load;
create temporary table temp_sample_taken_for_viral_load as select encounter_id, value_coded from omrs_obs where concept = 'Sample taken for Viral Load';
alter table temp_sample_taken_for_viral_load add index temp_sample_taken_for_viral_load_encounter_idx (encounter_id);

drop temporary table if exists temp_lab_id;
create temporary table temp_lab_id as select encounter_id, value_text from omrs_obs where concept = 'Lab ID';
alter table temp_lab_id add index temp_lab_id_encounter_idx (encounter_id);

drop temporary table if exists temp_location_of_laboratory;
create temporary table temp_location_of_laboratory as select encounter_id, value_coded from omrs_obs where concept = 'Location of laboratory';
alter table temp_location_of_laboratory add index temp_location_of_laboratory_encounter_idx (encounter_id);

drop temporary table if exists temp_less_than_limit;
create temporary table temp_less_than_limit as select encounter_id, value_numeric from omrs_obs where concept = 'Less than limit';
alter table temp_less_than_limit add index temp_less_than_limit_encounter_idx (encounter_id);

drop temporary table if exists temp_lower_than_detection_limit;
create temporary table temp_lower_than_detection_limit as select encounter_id, value_coded from omrs_obs where concept = 'Lower than Detection limit';
alter table temp_lower_than_detection_limit add index temp_lower_than_detection_limit_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_no_result;
create temporary table temp_reason_for_no_result as select encounter_id, value_coded from omrs_obs where concept = 'Reason for no result';
alter table temp_reason_for_no_result add index temp_reason_for_no_result_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_no_sample;
create temporary table temp_reason_for_no_sample as select encounter_id, value_coded from omrs_obs where concept = 'Reason for no sample';
alter table temp_reason_for_no_sample add index temp_reason_for_no_sample_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_testing_coded;
create temporary table temp_reason_for_testing_coded as select encounter_id, value_coded from omrs_obs where concept = 'Reason for testing (coded)';
alter table temp_reason_for_testing_coded add index temp_reason_for_testing_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_viral_load_sample_id;
create temporary table temp_viral_load_sample_id as select encounter_id, value_text from omrs_obs where concept = 'Viral Load Sample ID';
alter table temp_viral_load_sample_id add index temp_viral_load_sample_id_encounter_idx (encounter_id);

drop temporary table if exists temp_symptom_absent;
create temporary table temp_symptom_absent as select encounter_id, value_coded from omrs_obs where concept = 'Symptom absent';
alter table temp_symptom_absent add index temp_symptom_absent_encounter_idx (encounter_id);

drop temporary table if exists temp_symptom_present;
create temporary table temp_symptom_present as select encounter_id, value_coded from omrs_obs where concept = 'Symptom present';
alter table temp_symptom_present add index temp_symptom_present_encounter_idx (encounter_id);

insert into mw_poc_viral_load_screening (patient_id, visit_date, location, sample_taken_for_viral_load, lab_id, lab_location, less_than_limit, lower_than_detection_limit, reason_for_no_result, reason_for_no_sample, reason_for_testing, viral_load_sample_id, symptom_absent, symptom_present)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sample_taken_for_viral_load.value_coded) as sample_taken_for_viral_Load,
    max(lab_id.value_text) as lab_id,
    max(location_of_laboratory.value_coded) as lab_location,
    max(less_than_limit.value_numeric) as less_than_limit,
    max(lower_than_detection_limit.value_coded) as lower_than_detection_limit,
    max(reason_for_no_result.value_coded) as reason_for_no_result,
    max(reason_for_no_sample.value_coded) as reason_for_no_sample,
    max(reason_for_testing_coded.value_coded) as reason_for_testing,
    max(viral_load_sample_id.value_text) as viral_load_sample_id,
    max(symptom_absent.value_coded) as symptom_absent,
    max(symptom_present.value_coded) as symptom_present
from omrs_encounter e
left join temp_sample_taken_for_viral_load sample_taken_for_viral_load on e.encounter_id = sample_taken_for_viral_load.encounter_id
left join temp_lab_id lab_id on e.encounter_id = lab_id.encounter_id
left join temp_location_of_laboratory location_of_laboratory on e.encounter_id = location_of_laboratory.encounter_id
left join temp_less_than_limit less_than_limit on e.encounter_id = less_than_limit.encounter_id
left join temp_lower_than_detection_limit lower_than_detection_limit on e.encounter_id = lower_than_detection_limit.encounter_id
left join temp_reason_for_no_result reason_for_no_result on e.encounter_id = reason_for_no_result.encounter_id
left join temp_reason_for_no_sample reason_for_no_sample on e.encounter_id = reason_for_no_sample.encounter_id
left join temp_reason_for_testing_coded reason_for_testing_coded on e.encounter_id = reason_for_testing_coded.encounter_id
left join temp_viral_load_sample_id viral_load_sample_id on e.encounter_id = viral_load_sample_id.encounter_id
left join temp_symptom_absent symptom_absent on e.encounter_id = symptom_absent.encounter_id
left join temp_symptom_present symptom_present on e.encounter_id = symptom_present.encounter_id
where e.encounter_type in ('Viral Load Screening')
group by e.patient_id, e.encounter_date, e.location;