CREATE TABLE mw_sickle_cell_disease_quarterly_screening (
  sickle_cell_disease_quarterly_screening_visit_id INT NOT NULL AUTO_INCREMENT,
  patient_id INT(11) NOT NULL,
  visit_date DATE NULL DEFAULT NULL,
  location VARCHAR(255) NULL DEFAULT NULL,
  hiv_status VARCHAR(255) NULL DEFAULT NULL,
  fcb VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (sickle_cell_disease_quarterly_screening_visit_id));

