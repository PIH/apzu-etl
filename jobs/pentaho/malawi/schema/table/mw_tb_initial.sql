CREATE TABLE mw_tb_initial (
  tb_initial_visit_id 			INT NOT NULL AUTO_INCREMENT,
  patient_id    				INT NOT NULL,
  visit_date            		DATE,
  location              		VARCHAR(255),
  disease_classification 		VARCHAR(255),
  patient_category 				VARCHAR(255),
  diagnosis						VARCHAR(255),
  arv_start_date 				DATE,
  ctx_start_date 				DATE,
  hiv_test_history  			VARCHAR(255),
  regimen_rhze					INT,
  dot_option  					VARCHAR(255),
  source_of_referral  			VARCHAR(255),
  dst_result  					VARCHAR(255),
  ptld_date_registered          DATE,
  date_started_prp              DATE,
     PRIMARY KEY (tb_initial_visit_id)
);
