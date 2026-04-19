create table mw_eid_register (
  enrollment_id                    int not null,
  patient_id                       int not null,
  location                         varchar(255),
  eid_number                       varchar(50),
  mother_art_number				   varchar(100),
  start_date                       date,
  end_date                         date,
  outcome                          varchar(100),
  last_eid_visit_id                int
);
alter table mw_eid_register add index mw_eid_register_patient_idx (patient_id);
alter table mw_eid_register add index mw_eid_register_patient_location_idx (patient_id, location);