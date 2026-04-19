-- Derivation script for mw_art_visits
-- Generated from Pentaho transform: import-into-mw-art-visits.ktr

drop table if exists mw_art_visits;
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

insert into mw_art_visits
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Malawi Antiretroviral drugs received' then o.value_coded end) as art_drugs_rcd
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('ART_INITIAL', 'ART_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;