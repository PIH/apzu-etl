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

insert into mw_pre_art_visits
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('PART_INITIAL', 'PART_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;