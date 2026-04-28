CREATE TABLE mw_sickle_cell_disease_annual_screening (
  sickle_cell_disease_annual_screening_visit_id INT NOT NULL AUTO_INCREMENT,
  patient_id INT(11) NOT NULL,
  visit_date DATE NULL DEFAULT NULL,
  location VARCHAR(255) NULL DEFAULT NULL,
  cr INT NULL DEFAULT NULL,
  alt INT NULL DEFAULT NULL,
  ast INT NULL DEFAULT NULL,
  bil INT NULL,
  dir_bil INT NULL,
  in_bili INT NULL,
  PRIMARY KEY (sickle_cell_disease_annual_screening_visit_id));

