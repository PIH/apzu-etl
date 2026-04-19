
create table mw_art_visits (
  art_visit_id          int not null auto_increment primary key,
  patient_id            int not null,
  visit_date            date,
  location              varchar(255),
  art_drug_regimen      varchar(255),
  next_appointment_date date
);
alter table mw_art_visits add index mw_art_visit_patient_idx (patient_id);
alter table mw_art_visits add index mw_art_visit_patient_location_idx (patient_id, location);