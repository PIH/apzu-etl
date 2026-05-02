
CREATE TABLE mw_art_visits (
  art_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  art_drug_regimen      VARCHAR(255),
  next_appointment_date DATE
);