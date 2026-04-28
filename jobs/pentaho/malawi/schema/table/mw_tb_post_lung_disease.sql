CREATE TABLE mw_tb_post_lung_disease (
  tb_post_lung_disease_visit_id 		INT NOT NULL AUTO_INCREMENT,
  patient_id    				INT NOT NULL,
  visit_date            		DATE,
  location              		VARCHAR(255),
  number_of_weeks 					INT,
  second_visit_date 		DATE,
     PRIMARY KEY (tb_post_lung_disease_visit_id)
);
