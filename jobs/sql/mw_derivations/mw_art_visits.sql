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

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_malawi_antiretroviral_drugs_received;
create temporary table temp_malawi_antiretroviral_drugs_received as select encounter_id, value_coded from omrs_obs where concept = 'Malawi Antiretroviral drugs received';
alter table temp_malawi_antiretroviral_drugs_received add index temp_malawi_antiretroviral_drugs_received_encounter_idx (encounter_id);

insert into mw_art_visits
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(appointment_date.value_date) as next_appointment_date,
    max(malawi_antiretroviral_drugs_received.value_coded) as art_drugs_rcd
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_malawi_antiretroviral_drugs_received malawi_antiretroviral_drugs_received on e.encounter_id = malawi_antiretroviral_drugs_received.encounter_id
where e.encounter_type in ('ART_INITIAL', 'ART_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;