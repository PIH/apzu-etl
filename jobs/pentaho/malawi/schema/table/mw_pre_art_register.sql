
CREATE TABLE mw_pre_art_register (
  enrollment_id  INT NOT NULL,
  patient_id     INT NOT NULL,
  location       VARCHAR(255),
  pre_art_number VARCHAR(50),
  start_date     DATE,
  end_date       DATE,
  outcome        VARCHAR(100)
);