-- Derivation script for mw_eid_initial
-- Generated from Pentaho transform: import-into-mw-eid-initial.ktr

drop table if exists mw_eid_initial;
create table mw_eid_initial (
  eid_initial_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  mother_hiv_status varchar(255) default null,
  mother_art_reg_no varchar(255) default null,
  mother_art_start_date date default null,
  age int default null,
  age_when_starting_nvp int default null,
  duration_type_when_starting_nvp varchar(255) default null,
  nvp_duration int default null,
  nvp_duration_type varchar(255) default null,
  birth_weight decimal(10,2) default null,
  primary key (eid_initial_visit_id)
);

insert into mw_eid_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Age' then o.value_numeric end) as age,
    max(case when o.concept = 'Patient age when result to guardian' then o.value_numeric end) as age_when_starting_nvp,
    max(case when o.concept = 'Birth weight' then o.value_numeric end) as birth_weight,
    max(case when o.concept = 'Units of age of child' then o.value_coded end) as duration_type_when_starting_nvp,
    max(case when o.concept = 'Mother ART registration number' then o.value_text end) as mother_art_reg_no,
    max(case when o.concept = 'Mother art start date' then o.value_date end) as mother_art_start_date,
    max(case when o.concept = 'Mother HIV Status' then o.value_coded end) as mother_hiv_status,
    max(case when o.concept = 'Medication duration' then o.value_numeric end) as nvp_duration,
    max(case when o.concept = 'Time units' then o.value_coded end) as nvp_duration_type
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_INITIAL')
group by e.patient_id, e.encounter_date, e.location;