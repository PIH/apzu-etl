create table omrs_obs_group (
  obs_group_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  encounter_id int,
  obs_group_date date,
  obs_group_time time,
  encounter_type varchar(255),
  location varchar(255),
  concept varchar(255) not null,
  date_created date
);

alter table omrs_obs_group add index omrs_bos_group_id_idx (obs_group_id);
alter table omrs_obs_group add index omrs_obs_group_patient_idx (patient_id);
alter table omrs_obs_group add index omrs_obs_group_date_idx (obs_group_date);
alter table omrs_obs_group add index omrs_obs_group_time_idx (obs_group_time);
alter table omrs_obs_group add index omrs_obs_group_concept_idx (concept);
alter table omrs_obs_group add index omrs_obs_group_encounter_type_idx (encounter_type);
alter table omrs_obs_group add index omrs_obs_group_location_idx (location);
