
create table mw_pdc_register (
  enrollment_id INT NOT NULL,
  patient_id    INT NOT NULL,
  location      VARCHAR(255),
  pdc_number    VARCHAR(50),
  start_date    DATE,
  end_date      DATE,
  outcome       VARCHAR(100)
);
alter table mw_pdc_register add index mw_pdc_register_patient_idx (patient_id);
alter table mw_pdc_register add index mw_pdc_register_patient_location_idx (patient_id, location);