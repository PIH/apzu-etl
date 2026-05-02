
CREATE TABLE mw_pre_art_visits (
  pre_art_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  next_appointment_date DATE
);