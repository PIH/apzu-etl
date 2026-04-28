CREATE TABLE mw_sickle_cell_disease_history_of_hospitalization (
  sickle_cell_disease_history_of_hospitalization int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  length_of_stay			int NOT NULL,
  reason_for_admission			varchar(255) DEFAULT NULL,
  discharge_diagnosis			varchar(255) DEFAULT NULL,
  discharge_medications			varchar(255) DEFAULT NULL,
  PRIMARY KEY (sickle_cell_disease_history_of_hospitalization));
