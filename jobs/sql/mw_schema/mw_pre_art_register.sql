
create table mw_pre_art_register (
  enrollment_id  int not null,
  patient_id     int not null,
  location       varchar(255),
  pre_art_number varchar(50),
  start_date     date,
  end_date       date,
  outcome        varchar(100)
);
alter table mw_pre_art_register add index mw_pre_art_register_patient_idx (patient_id);
alter table mw_pre_art_register add index mw_pre_art_register_patient_location_idx (patient_id, location);