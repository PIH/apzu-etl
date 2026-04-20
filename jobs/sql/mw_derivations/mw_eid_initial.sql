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

drop temporary table if exists temp_age;
create temporary table temp_age as select encounter_id, value_numeric from omrs_obs where concept = 'Age';
alter table temp_age add index temp_age_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_age_when_result_to_guardian;
create temporary table temp_patient_age_when_result_to_guardian as select encounter_id, value_numeric from omrs_obs where concept = 'Patient age when result to guardian';
alter table temp_patient_age_when_result_to_guardian add index temp_patient_age_result_guardian_encounter_idx (encounter_id);

drop temporary table if exists temp_birth_weight;
create temporary table temp_birth_weight as select encounter_id, value_numeric from omrs_obs where concept = 'Birth weight';
alter table temp_birth_weight add index temp_birth_weight_encounter_idx (encounter_id);

drop temporary table if exists temp_units_of_age_of_child;
create temporary table temp_units_of_age_of_child as select encounter_id, value_coded from omrs_obs where concept = 'Units of age of child';
alter table temp_units_of_age_of_child add index temp_units_of_age_of_child_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_art_registration_number;
create temporary table temp_mother_art_registration_number as select encounter_id, value_text from omrs_obs where concept = 'Mother ART registration number';
alter table temp_mother_art_registration_number add index temp_mother_art_registration_number_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_art_start_date;
create temporary table temp_mother_art_start_date as select encounter_id, value_date from omrs_obs where concept = 'Mother art start date';
alter table temp_mother_art_start_date add index temp_mother_art_start_date_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_hiv_status;
create temporary table temp_mother_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'Mother HIV Status';
alter table temp_mother_hiv_status add index temp_mother_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_duration;
create temporary table temp_medication_duration as select encounter_id, value_numeric from omrs_obs where concept = 'Medication duration';
alter table temp_medication_duration add index temp_medication_duration_encounter_idx (encounter_id);

drop temporary table if exists temp_time_units;
create temporary table temp_time_units as select encounter_id, value_coded from omrs_obs where concept = 'Time units';
alter table temp_time_units add index temp_time_units_encounter_idx (encounter_id);

insert into mw_eid_initial (patient_id, visit_date, location, age, age_when_starting_nvp, birth_weight, duration_type_when_starting_nvp, mother_art_reg_no, mother_art_start_date, mother_hiv_status, nvp_duration, nvp_duration_type)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(age.value_numeric) as age,
    max(patient_age_when_result_to_guardian.value_numeric) as age_when_starting_nvp,
    max(birth_weight.value_numeric) as birth_weight,
    max(units_of_age_of_child.value_coded) as duration_type_when_starting_nvp,
    max(mother_art_registration_number.value_text) as mother_art_reg_no,
    max(mother_art_start_date.value_date) as mother_art_start_date,
    max(mother_hiv_status.value_coded) as mother_hiv_status,
    max(medication_duration.value_numeric) as nvp_duration,
    max(time_units.value_coded) as nvp_duration_type
from omrs_encounter e
left join temp_age age on e.encounter_id = age.encounter_id
left join temp_patient_age_when_result_to_guardian patient_age_when_result_to_guardian on e.encounter_id = patient_age_when_result_to_guardian.encounter_id
left join temp_birth_weight birth_weight on e.encounter_id = birth_weight.encounter_id
left join temp_units_of_age_of_child units_of_age_of_child on e.encounter_id = units_of_age_of_child.encounter_id
left join temp_mother_art_registration_number mother_art_registration_number on e.encounter_id = mother_art_registration_number.encounter_id
left join temp_mother_art_start_date mother_art_start_date on e.encounter_id = mother_art_start_date.encounter_id
left join temp_mother_hiv_status mother_hiv_status on e.encounter_id = mother_hiv_status.encounter_id
left join temp_medication_duration medication_duration on e.encounter_id = medication_duration.encounter_id
left join temp_time_units time_units on e.encounter_id = time_units.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_INITIAL')
group by e.patient_id, e.encounter_date, e.location;