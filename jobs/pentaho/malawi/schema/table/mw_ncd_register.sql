
create table mw_ncd_register (
  enrollment_id INT NOT NULL,
  patient_id    INT NOT NULL,
  location      VARCHAR(255),
  ncd_number    VARCHAR(50),
  start_date    DATE,
  end_date      DATE,
  outcome       VARCHAR(100),
  cv_disease    BOOLEAN
);