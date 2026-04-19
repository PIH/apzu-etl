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

insert into mw_eid_lab_tests
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date of returned result' then o.value_date end) as result_date,
    max(case when o.concept = 'HIV test type' then o.value_coded end) as test_type,
    max(case when o.concept = 'Location of laboratory' then o.value_coded end) as lab_laboratory,
    max(case when o.concept = 'Reason for testing (coded)' then o.value_coded end) as reasons_for_testing,
    max(case when o.concept = 'Result of HIV test' then o.value_coded end) as hiv_result,
    max(case when o.concept = 'Lab test serial number' then o.value_text end) as sample_id
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('EID Screening')
group by e.patient_id, e.encounter_date, e.location;