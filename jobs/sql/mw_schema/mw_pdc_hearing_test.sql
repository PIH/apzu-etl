CREATE TABLE mw_pdc_hearing_test (
  pdc_hearing_test_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  left_ear				varchar(255) DEFAULT NULL,
  right_ear				varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_hearing_test_id)
) ;
