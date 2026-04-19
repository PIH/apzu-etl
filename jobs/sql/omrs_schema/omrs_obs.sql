drop table if exists omrs_obs;

create table omrs_obs (
  obs_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  encounter_id int,
  obs_date date,
  obs_time time,
  age_years_at_obs int,
  age_months_at_obs int,
  encounter_type varchar(255),
  form varchar(255),
  location varchar(255),
  concept varchar(255) not null,
  value_coded varchar(255),
  value_date date default null,
  value_numeric float default null,
  value_text text,
  comments varchar(255),
  obs_group_id int,
  date_created date
);

alter table omrs_obs add index omrs_obs_id_idx (obs_id);
alter table omrs_obs add index omrs_obs_patient_idx (patient_id);
alter table omrs_obs add index omrs_obs_date_idx (obs_date);
alter table omrs_obs add index omrs_obs_time_idx (obs_time);
alter table omrs_obs add index omrs_obs_concept_idx (concept);
alter table omrs_obs add index omrs_obs_encounter_type_idx (encounter_type);
alter table omrs_obs add index omrs_obs_location_idx (location);
