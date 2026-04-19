
create table mw_lab_tests (
  lab_test_id          int not null auto_increment primary key,
  patient_id           int not null,
  encounter_id		   int,
  date_collected       date,
  test_type            varchar(100),
  date_result_received date,
  date_result_entered  date,
  result_coded         varchar(100),
  result_numeric       decimal(10,2),
  result_exception     varchar(100)
);
alter table mw_lab_tests add index mw_lab_tests_patient_idx (patient_id);
alter table mw_lab_tests add index mw_lab_tests_patient_type_idx (patient_id, test_type);