-- Derivation script for mw_eid_followup
-- Generated from Pentaho transform: import-into-mw-eid-followup.ktr

drop table if exists mw_eid_followup;
create table mw_eid_followup (
  eid_followup_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  height int default null,
  weight int default null,
  muac decimal(16,4) default null,
  wasting_or_malnutrition varchar(255) default null,
  breast_feeding varchar(255) default null,
  mother_status varchar(255) default null,
  clinical_monitoring varchar(255) default null,
  hiv_infection varchar(255) default null,
  cpt int default null,
  next_appointment_date date default null,
  primary key (eid_followup_visit_id)
);

insert into mw_eid_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Breast feeding' then o.value_coded end) as breast_feeding,
    max(case when o.concept = 'Clinical Monitoring Exposed Child' then o.value_coded end) as clinical_monitoring,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Mother HIV Status' then o.value_coded end) as mother_status,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Wasting/malnutrition' then o.value_coded end) as wasting_or_malnutrition,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight,
    max(case when o.concept = 'Number of CPT tablets dispensed' then o.value_numeric end) as cpt,
    max(case when o.concept = 'Childs current HIV status' then o.value_coded end) as hiv_infection,
    max(case when o.concept = 'Middle upper arm circumference (cm)' then o.value_numeric end) as muac
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;