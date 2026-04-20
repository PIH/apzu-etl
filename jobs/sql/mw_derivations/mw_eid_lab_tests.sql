-- Derivation script for mw_eid_lab_tests
-- Generated from Pentaho transform: import-into-mw-eid-lab-tests.ktr

drop table if exists mw_eid_lab_tests;
create table mw_eid_lab_tests (
  eid_result_tests_id 			int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  reasons_for_testing			varchar(255) default null,
  lab_laboratory			varchar(255) default null,
  test_type				varchar(255) default null,
  sample_id				varchar(255) default null,
  hiv_result				varchar(255) default null,
  result_date		 		date default null,
  primary key (eid_result_tests_id )
);

drop temporary table if exists temp_date_of_returned_result;
create temporary table temp_date_of_returned_result as select encounter_id, value_date from omrs_obs where concept = 'Date of returned result';
alter table temp_date_of_returned_result add index temp_date_of_returned_result_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_type;
create temporary table temp_hiv_test_type as select encounter_id, value_coded from omrs_obs where concept = 'HIV test type';
alter table temp_hiv_test_type add index temp_hiv_test_type_encounter_idx (encounter_id);

drop temporary table if exists temp_location_of_laboratory;
create temporary table temp_location_of_laboratory as select encounter_id, value_coded from omrs_obs where concept = 'Location of laboratory';
alter table temp_location_of_laboratory add index temp_location_of_laboratory_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_testing_coded;
create temporary table temp_reason_for_testing_coded as select encounter_id, value_coded from omrs_obs where concept = 'Reason for testing (coded)';
alter table temp_reason_for_testing_coded add index temp_reason_for_testing_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_result_of_hiv_test;
create temporary table temp_result_of_hiv_test as select encounter_id, value_coded from omrs_obs where concept = 'Result of HIV test';
alter table temp_result_of_hiv_test add index temp_result_of_hiv_test_encounter_idx (encounter_id);

drop temporary table if exists temp_lab_test_serial_number;
create temporary table temp_lab_test_serial_number as select encounter_id, value_text from omrs_obs where concept = 'Lab test serial number';
alter table temp_lab_test_serial_number add index temp_lab_test_serial_number_encounter_idx (encounter_id);

insert into mw_eid_lab_tests
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_of_returned_result.value_date) as result_date,
    max(hiv_test_type.value_coded) as test_type,
    max(location_of_laboratory.value_coded) as lab_laboratory,
    max(reason_for_testing_coded.value_coded) as reasons_for_testing,
    max(result_of_hiv_test.value_coded) as hiv_result,
    max(lab_test_serial_number.value_text) as sample_id
from omrs_encounter e
left join temp_date_of_returned_result date_of_returned_result on e.encounter_id = date_of_returned_result.encounter_id
left join temp_hiv_test_type hiv_test_type on e.encounter_id = hiv_test_type.encounter_id
left join temp_location_of_laboratory location_of_laboratory on e.encounter_id = location_of_laboratory.encounter_id
left join temp_reason_for_testing_coded reason_for_testing_coded on e.encounter_id = reason_for_testing_coded.encounter_id
left join temp_result_of_hiv_test result_of_hiv_test on e.encounter_id = result_of_hiv_test.encounter_id
left join temp_lab_test_serial_number lab_test_serial_number on e.encounter_id = lab_test_serial_number.encounter_id
where e.encounter_type in ('EID Screening')
group by e.patient_id, e.encounter_date, e.location;