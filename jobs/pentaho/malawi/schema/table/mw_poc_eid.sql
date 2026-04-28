CREATE TABLE mw_poc_eid (
  poc_eid_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  creator varchar(255) DEFAULT NULL,
  date_of_blood_sample DATE,
  hiv_test_type VARCHAR(255),
  reason_for_no_sample_eid VARCHAR(255),
  result_of_hiv_test VARCHAR(255),
  hiv_test_time_period VARCHAR(255),
  age VARCHAR(13),
  units_of_age_of_child VARCHAR(255),
  lab_test_serial_number VARCHAR(255),
  date_of_returned_result VARCHAR(255),
  date_result_to_guardian DATE,
  reason_for_testing_coded VARCHAR(255),
  PRIMARY KEY (poc_eid_visit_id)
);
