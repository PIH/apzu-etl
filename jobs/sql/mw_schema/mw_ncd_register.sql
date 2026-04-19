
create table mw_ncd_register (
  enrollment_id int not null,
  patient_id    int not null,
  location      varchar(255),
  ncd_number    varchar(50),
  start_date    date,
  end_date      date,
  outcome       varchar(100),
  cv_disease    boolean
);
alter table mw_ncd_register add index mw_ncd_register_patient_idx (patient_id);
alter table mw_ncd_register add index mw_ncd_register_patient_location_idx (patient_id, location);