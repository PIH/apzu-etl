
create table mw_lab_tests_recent_period (
  lab_test_id          int not null auto_increment primary key,
  patient_id           int not null,
  encounter_id		   int,
  date_collected       date,
  test_type            varchar(100),
  date_result_received date,
  date_result_entered  date,
  result_coded         varchar(100),
  result_numeric       decimal(10,2),
  result_exception     varchar(100),
  end_date			   date
);
alter table mw_lab_tests add index mw_lab_tests_recent_idx (patient_id);
