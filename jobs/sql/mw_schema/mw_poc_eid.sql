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
