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

insert into mw_eid_visits
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Breast feeding' then o.value_coded end) as breastfeeding_status,
    max(case when o.concept = 'Mother HIV Status' then o.value_coded end) as mother_status
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_INITIAL', 'EXPOSED_CHILD_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;