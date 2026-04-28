CREATE TABLE mw_tb_followup (
  tb_followup_visit_id 			INT NOT NULL AUTO_INCREMENT,
  patient_id    				INT NOT NULL,
  visit_date            		DATE,
  location              		VARCHAR(255),
  rhze_regimen 					INT,
  rh_regimen 					INT,
  meningitis_regimen			INT,
  next_appointment_date 		DATE,
     PRIMARY KEY (tb_followup_visit_id)
);
