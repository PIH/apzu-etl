

create table mw_eid_visits (
  eid_visit_id          int not null auto_increment primary key,
  patient_id            int not null,
  visit_date            date,
  location              varchar(255),
  breastfeeding_status  varchar(100),
  mother_status	        varchar(100),
  next_appointment_date date
);
alter table mw_eid_visits add index mw_eid_visit_patient_idx (patient_id);
alter table mw_eid_visits add index mw_eid_visit_patient_location_idx (patient_id, location);