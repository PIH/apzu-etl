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
