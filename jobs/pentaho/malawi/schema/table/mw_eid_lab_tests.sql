CREATE TABLE mw_eid_lab_tests (
  eid_result_tests_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  reasons_for_testing			varchar(255) DEFAULT NULL,
  lab_laboratory			varchar(255) DEFAULT NULL,
  test_type				varchar(255) DEFAULT NULL,
  sample_id				varchar(255) DEFAULT NULL,
  hiv_result				varchar(255) DEFAULT NULL,
  result_date		 		date DEFAULT NULL,
  PRIMARY KEY (eid_result_tests_id )
);
