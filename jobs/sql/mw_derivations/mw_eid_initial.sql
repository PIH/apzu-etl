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

-- Pre-filter omrs_obs to just this encounter type so subsequent joins work on a small subset
-- rather than scanning the full ~20M-row obs table for each derived temp table.
drop temporary table if exists temp_eid_initial_obs;
create temporary table temp_eid_initial_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'EXPOSED_CHILD_INITIAL';
alter table temp_eid_initial_obs add index temp_eid_initial_obs_concept_idx (concept);
alter table temp_eid_initial_obs add index temp_eid_initial_obs_encounter_idx (encounter_id);
alter table temp_eid_initial_obs add index temp_eid_initial_obs_group_idx (obs_group_id);

drop temporary table if exists temp_age;
create temporary table temp_age as select encounter_id, value_numeric from temp_eid_initial_obs where concept = 'Age';
alter table temp_age add index temp_age_encounter_idx (encounter_id);

drop temporary table if exists temp_birth_weight;
create temporary table temp_birth_weight as select encounter_id, value_numeric from temp_eid_initial_obs where concept = 'Birth weight';
alter table temp_birth_weight add index temp_birth_weight_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_art_registration_number;
create temporary table temp_mother_art_registration_number as select encounter_id, value_text from temp_eid_initial_obs where concept = 'Mother ART registration number';
alter table temp_mother_art_registration_number add index temp_mother_art_registration_number_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_art_start_date;
create temporary table temp_mother_art_start_date as select encounter_id, value_date from temp_eid_initial_obs where concept = 'Mother art start date';
alter table temp_mother_art_start_date add index temp_mother_art_start_date_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_hiv_status;
create temporary table temp_mother_hiv_status as select encounter_id, value_coded from temp_eid_initial_obs where concept = 'Mother HIV Status';
alter table temp_mother_hiv_status add index temp_mother_hiv_status_encounter_idx (encounter_id);

-- "Patient age when result to guardian" and "Units of age of child" share an obs_group whose
-- parent concept is "Age at start of Neviripine construct".  Pair them by obs_group_id so the
-- numeric age and its units come from the same construct.
-- (Each side is materialized into its own temp table so we don't self-join a temp table,
--  which MySQL 5.6 cannot do.)
drop temporary table if exists temp_age_at_nvp_groups;
create temporary table temp_age_at_nvp_groups as
select obs_group_id from omrs_obs_group
where concept = 'Age at start of Neviripine construct'
  and encounter_type = 'EXPOSED_CHILD_INITIAL';
alter table temp_age_at_nvp_groups add index temp_age_at_nvp_groups_idx (obs_group_id);

drop temporary table if exists temp_age_when_obs;
create temporary table temp_age_when_obs as
select encounter_id, obs_group_id, value_numeric
from temp_eid_initial_obs
where concept = 'Patient age when result to guardian';
alter table temp_age_when_obs add index temp_age_when_obs_group_idx (obs_group_id);

drop temporary table if exists temp_age_units_obs;
create temporary table temp_age_units_obs as
select obs_group_id, value_coded
from temp_eid_initial_obs
where concept = 'Units of age of child';
alter table temp_age_units_obs add index temp_age_units_obs_group_idx (obs_group_id);

drop temporary table if exists temp_age_when_starting_nvp;
create temporary table temp_age_when_starting_nvp as
select a.encounter_id,
       a.value_numeric as age_when_starting_nvp,
       u.value_coded   as duration_type_when_starting_nvp
from temp_age_when_obs a
inner join temp_age_at_nvp_groups g on g.obs_group_id = a.obs_group_id
left join temp_age_units_obs u on u.obs_group_id = a.obs_group_id;
alter table temp_age_when_starting_nvp add index temp_age_when_starting_nvp_encounter_idx (encounter_id);

-- "Medication duration" and "Time units" pair via obs_group_id (NVP duration construct).
drop temporary table if exists temp_medication_duration_obs;
create temporary table temp_medication_duration_obs as
select encounter_id, obs_group_id, value_numeric
from temp_eid_initial_obs
where concept = 'Medication duration';
alter table temp_medication_duration_obs add index temp_medication_duration_obs_group_idx (obs_group_id);

drop temporary table if exists temp_time_units_obs;
create temporary table temp_time_units_obs as
select obs_group_id, value_coded
from temp_eid_initial_obs
where concept = 'Time units';
alter table temp_time_units_obs add index temp_time_units_obs_group_idx (obs_group_id);

drop temporary table if exists temp_nvp_duration;
create temporary table temp_nvp_duration as
select d.encounter_id,
       d.value_numeric as nvp_duration,
       u.value_coded   as nvp_duration_type
from temp_medication_duration_obs d
left join temp_time_units_obs u on u.obs_group_id = d.obs_group_id;
alter table temp_nvp_duration add index temp_nvp_duration_encounter_idx (encounter_id);

insert into mw_eid_initial (patient_id, visit_date, location, age, age_when_starting_nvp, birth_weight, duration_type_when_starting_nvp, mother_art_reg_no, mother_art_start_date, mother_hiv_status, nvp_duration, nvp_duration_type)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(age.value_numeric) as age,
    max(awsn.age_when_starting_nvp) as age_when_starting_nvp,
    max(birth_weight.value_numeric) as birth_weight,
    max(awsn.duration_type_when_starting_nvp) as duration_type_when_starting_nvp,
    max(mother_art_registration_number.value_text) as mother_art_reg_no,
    max(mother_art_start_date.value_date) as mother_art_start_date,
    max(mother_hiv_status.value_coded) as mother_hiv_status,
    max(nvp.nvp_duration) as nvp_duration,
    max(nvp.nvp_duration_type) as nvp_duration_type
from omrs_encounter e
left join temp_age age on e.encounter_id = age.encounter_id
left join temp_age_when_starting_nvp awsn on e.encounter_id = awsn.encounter_id
left join temp_birth_weight birth_weight on e.encounter_id = birth_weight.encounter_id
left join temp_mother_art_registration_number mother_art_registration_number on e.encounter_id = mother_art_registration_number.encounter_id
left join temp_mother_art_start_date mother_art_start_date on e.encounter_id = mother_art_start_date.encounter_id
left join temp_mother_hiv_status mother_hiv_status on e.encounter_id = mother_hiv_status.encounter_id
left join temp_nvp_duration nvp on e.encounter_id = nvp.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_INITIAL')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_eid_initial_obs;
drop temporary table if exists temp_age;
drop temporary table if exists temp_birth_weight;
drop temporary table if exists temp_mother_art_registration_number;
drop temporary table if exists temp_mother_art_start_date;
drop temporary table if exists temp_mother_hiv_status;
drop temporary table if exists temp_age_at_nvp_groups;
drop temporary table if exists temp_age_when_obs;
drop temporary table if exists temp_age_units_obs;
drop temporary table if exists temp_age_when_starting_nvp;
drop temporary table if exists temp_medication_duration_obs;
drop temporary table if exists temp_time_units_obs;
drop temporary table if exists temp_nvp_duration;
