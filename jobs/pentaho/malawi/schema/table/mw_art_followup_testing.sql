CREATE TABLE mw_art_followup_testing (
  art_followup_testing_visit_id INT NOT NULL AUTO_INCREMENT,
  patient_id INT(11) NOT NULL,
  visit_date DATE NULL DEFAULT NULL,
  location VARCHAR(255) NULL DEFAULT NULL,
  cd4_count INT NULL DEFAULT NULL,
  cd4_pct INT NULL DEFAULT NULL,
  serum_glucose INT NULL DEFAULT NULL,
  phq_nine_score INT NULL,
  test_type VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (art_followup_testing_visit_id));

