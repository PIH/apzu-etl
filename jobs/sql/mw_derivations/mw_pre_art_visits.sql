-- Derivation script for mw_pre_art_visits
-- Generated from Pentaho transform: import-into-mw-pre-art-visits.ktr

drop table if exists mw_pre_art_visits;
create table mw_pre_art_visits (
  pre_art_visit_id          int not null auto_increment primary key,
  patient_id            int not null,
  visit_date            date,
  location              varchar(255),
  next_appointment_date date
);
alter table mw_pre_art_visits add index mw_pre_art_visit_patient_idx (patient_id);
alter table mw_pre_art_visits add index mw_pre_art_visit_patient_location_idx (patient_id, location);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

insert into mw_pre_art_visits
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(appointment_date.value_date) as next_appointment_date
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
where e.encounter_type in ('PART_INITIAL', 'PART_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;