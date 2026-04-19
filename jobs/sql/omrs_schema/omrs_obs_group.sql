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