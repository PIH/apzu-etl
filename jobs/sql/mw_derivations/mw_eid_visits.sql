-- Derivation script for mw_eid_visits
-- Generated from Pentaho transform: import-into-mw-eid-visits.ktr

drop table if exists mw_eid_visits;
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

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_breastfeeding;
create temporary table temp_breastfeeding as select encounter_id, value_coded from omrs_obs where concept = 'Breast feeding';
alter table temp_breastfeeding add index temp_breastfeeding_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_hiv_status;
create temporary table temp_mother_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'Mother HIV Status';
alter table temp_mother_hiv_status add index temp_mother_hiv_status_encounter_idx (encounter_id);

insert into mw_eid_visits (patient_id, visit_date, location, breastfeeding_status, mother_status, next_appointment_date)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(breastfeeding.value_coded) as breastfeeding_status,
    max(mother_hiv_status.value_coded) as mother_status,
    max(appointment_date.value_date) as next_appointment_date
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_breastfeeding breastfeeding on e.encounter_id = breastfeeding.encounter_id
left join temp_mother_hiv_status mother_hiv_status on e.encounter_id = mother_hiv_status.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_INITIAL', 'EXPOSED_CHILD_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;