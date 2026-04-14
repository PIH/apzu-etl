CREATE TABLE mw_diabetes_hypertension_annual_lab_tests (
  diabetes_hypertension_annual_lab_tests_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  ecg					varchar(255) DEFAULT NULL,
  creatinine				varchar(255) DEFAULT NULL,
  lipid_profile			varchar(255) DEFAULT NULL,
  fundoscopy				varchar(255) DEFAULT NULL,
  PRIMARY KEY (diabetes_hypertension_annual_lab_tests_id)
);
