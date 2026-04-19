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

insert into mw_poc_eid
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Age' then o.value_numeric end) as age,
    max(case when o.concept = 'Date of blood sample' then o.value_date end) as date_of_blood_sample,
    max(case when o.concept = 'Date of returned result' then o.value_date end) as date_of_returned_result,
    max(case when o.concept = 'Date result to guardian' then o.value_date end) as date_result_to_guardian,
    max(case when o.concept = 'HIV test time period' then o.value_coded end) as hiv_test_time_period,
    max(case when o.concept = 'HIV test type' then o.value_coded end) as hiv_test_type,
    max(case when o.concept = 'Lab test serial number' then o.value_text end) as lab_test_serial_number,
    max(case when o.concept = 'Reason for no sample' then o.value_coded end) as reason_for_no_sample_eid,
    max(case when o.concept = 'Reason for testing (coded)' then o.value_coded end) as reason_for_testing_coded,
    max(case when o.concept = 'Result of HIV test' then o.value_coded end) as result_of_hiv_test,
    max(case when o.concept = 'Units of age of child' then o.value_coded end) as units_of_age_of_child
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('EID Screening')
group by e.patient_id, e.encounter_date, e.location;