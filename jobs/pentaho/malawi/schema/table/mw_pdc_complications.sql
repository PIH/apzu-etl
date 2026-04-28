CREATE TABLE mw_pdc_complications (
  pdc_complications_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  date_of_complication			date DEFAULT NULL,
  self_reported_complication		varchar(255) DEFAULT NULL,
  details_of_complications		varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_complications_id)
) ;
