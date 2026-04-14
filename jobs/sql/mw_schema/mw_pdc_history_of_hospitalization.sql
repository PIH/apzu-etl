CREATE TABLE mw_pdc_history_of_hospitalization (
  pdc_history_of_hospitalization_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  discharge_date			date DEFAULT NULL,
  reason_for_admission			varchar(255) DEFAULT NULL,
  discharge_diagnosis			varchar(255) DEFAULT NULL,
  discharge_medications			varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_history_of_hospitalization_id)
) ;
