

CREATE TABLE mw_eid_visits (
  eid_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  breastfeeding_status  VARCHAR(100),
  mother_status	        VARCHAR(100),
  next_appointment_date DATE
);