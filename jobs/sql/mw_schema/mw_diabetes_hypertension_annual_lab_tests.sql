create table mw_diabetes_hypertension_annual_lab_tests (
  diabetes_hypertension_annual_lab_tests_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  ecg					varchar(255) default null,
  creatinine				varchar(255) default null,
  lipid_profile			varchar(255) default null,
  fundoscopy				varchar(255) default null,
  primary key (diabetes_hypertension_annual_lab_tests_id)
);
