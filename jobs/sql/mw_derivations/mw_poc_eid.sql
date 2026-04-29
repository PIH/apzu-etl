-- Derivation script for mw_poc_eid
-- Generated from Pentaho transform: import-into-mw-poc-eid.ktr

drop table if exists mw_poc_eid;
create table mw_poc_eid (
  poc_eid_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  creator varchar(255) default null,
  date_of_blood_sample date,
  hiv_test_type varchar(255),
  reason_for_no_sample_eid varchar(255),
  result_of_hiv_test varchar(255),
  hiv_test_time_period varchar(255),
  age varchar(13),
  units_of_age_of_child varchar(255),
  lab_test_serial_number varchar(255),
  date_of_returned_result varchar(255),
  date_result_to_guardian date,
  reason_for_testing_coded varchar(255),
  primary key (poc_eid_visit_id)
);

drop temporary table if exists temp_age;
create temporary table temp_age as select encounter_id, value_numeric from omrs_obs where concept = 'Age';
alter table temp_age add index temp_age_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_blood_sample;
create temporary table temp_date_of_blood_sample as select encounter_id, value_date from omrs_obs where concept = 'Date of blood sample';
alter table temp_date_of_blood_sample add index temp_date_of_blood_sample_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_returned_result;
create temporary table temp_date_of_returned_result as select encounter_id, value_date from omrs_obs where concept = 'Date of returned result';
alter table temp_date_of_returned_result add index temp_date_of_returned_result_encounter_idx (encounter_id);

drop temporary table if exists temp_date_result_to_guardian;
create temporary table temp_date_result_to_guardian as select encounter_id, value_date from omrs_obs where concept = 'Date result to guardian';
alter table temp_date_result_to_guardian add index temp_date_result_to_guardian_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_time_period;
create temporary table temp_hiv_test_time_period as select encounter_id, value_coded from omrs_obs where concept = 'HIV test time period';
alter table temp_hiv_test_time_period add index temp_hiv_test_time_period_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_type;
create temporary table temp_hiv_test_type as select encounter_id, value_coded from omrs_obs where concept = 'HIV test type';
alter table temp_hiv_test_type add index temp_hiv_test_type_encounter_idx (encounter_id);

drop temporary table if exists temp_lab_test_serial_number;
create temporary table temp_lab_test_serial_number as select encounter_id, value_text from omrs_obs where concept = 'Lab test serial number';
alter table temp_lab_test_serial_number add index temp_lab_test_serial_number_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_no_sample;
create temporary table temp_reason_for_no_sample as select encounter_id, value_coded from omrs_obs where concept = 'Reason for no sample';
alter table temp_reason_for_no_sample add index temp_reason_for_no_sample_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_testing_coded;
create temporary table temp_reason_for_testing_coded as select encounter_id, value_coded from omrs_obs where concept = 'Reason for testing (coded)';
alter table temp_reason_for_testing_coded add index temp_reason_for_testing_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_result_of_hiv_test;
create temporary table temp_result_of_hiv_test as select encounter_id, value_coded from omrs_obs where concept = 'Result of HIV test';
alter table temp_result_of_hiv_test add index temp_result_of_hiv_test_encounter_idx (encounter_id);

drop temporary table if exists temp_units_of_age_of_child;
create temporary table temp_units_of_age_of_child as select encounter_id, value_coded from omrs_obs where concept = 'Units of age of child';
alter table temp_units_of_age_of_child add index temp_units_of_age_of_child_encounter_idx (encounter_id);

insert into mw_poc_eid (patient_id, visit_date, location, age, date_of_blood_sample, date_of_returned_result, date_result_to_guardian, hiv_test_time_period, hiv_test_type, lab_test_serial_number, reason_for_no_sample_eid, reason_for_testing_coded, result_of_hiv_test, units_of_age_of_child, creator)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(age.value_numeric) as age,
    max(date_of_blood_sample.value_date) as date_of_blood_sample,
    max(date_of_returned_result.value_date) as date_of_returned_result,
    max(date_result_to_guardian.value_date) as date_result_to_guardian,
    max(hiv_test_time_period.value_coded) as hiv_test_time_period,
    max(hiv_test_type.value_coded) as hiv_test_type,
    max(lab_test_serial_number.value_text) as lab_test_serial_number,
    max(reason_for_no_sample.value_coded) as reason_for_no_sample_eid,
    max(reason_for_testing_coded.value_coded) as reason_for_testing_coded,
    max(result_of_hiv_test.value_coded) as result_of_hiv_test,
    max(units_of_age_of_child.value_coded) as units_of_age_of_child,
    max(e.created_by) as creator
from omrs_encounter e
left join temp_age age on e.encounter_id = age.encounter_id
left join temp_date_of_blood_sample date_of_blood_sample on e.encounter_id = date_of_blood_sample.encounter_id
left join temp_date_of_returned_result date_of_returned_result on e.encounter_id = date_of_returned_result.encounter_id
left join temp_date_result_to_guardian date_result_to_guardian on e.encounter_id = date_result_to_guardian.encounter_id
left join temp_hiv_test_time_period hiv_test_time_period on e.encounter_id = hiv_test_time_period.encounter_id
left join temp_hiv_test_type hiv_test_type on e.encounter_id = hiv_test_type.encounter_id
left join temp_lab_test_serial_number lab_test_serial_number on e.encounter_id = lab_test_serial_number.encounter_id
left join temp_reason_for_no_sample reason_for_no_sample on e.encounter_id = reason_for_no_sample.encounter_id
left join temp_reason_for_testing_coded reason_for_testing_coded on e.encounter_id = reason_for_testing_coded.encounter_id
left join temp_result_of_hiv_test result_of_hiv_test on e.encounter_id = result_of_hiv_test.encounter_id
left join temp_units_of_age_of_child units_of_age_of_child on e.encounter_id = units_of_age_of_child.encounter_id
where e.encounter_type in ('EID Screening')
group by e.patient_id, e.encounter_date, e.location;