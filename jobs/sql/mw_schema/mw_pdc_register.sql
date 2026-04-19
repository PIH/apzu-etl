
create table mw_pdc_register (
  enrollment_id int not null,
  patient_id    int not null,
  location      varchar(255),
  pdc_number    varchar(50),
  start_date    date,
  end_date      date,
  outcome       varchar(100)
);
alter table mw_pdc_register add index mw_pdc_register_patient_idx (patient_id);
alter table mw_pdc_register add index mw_pdc_register_patient_location_idx (patient_id, location);