CREATE TABLE mw_pdc_radiology (
  pdc_radiology_id 			int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  echo_results				varchar(255) DEFAULT NULL,
  other_results			varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_radiology_id)
) ;
