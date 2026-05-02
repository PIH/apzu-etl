CREATE TABLE omrs_obs_group (
  obs_group_id INT not null,
  uuid CHAR(38) not null,
  patient_id INT not null,
  encounter_id INT,
  obs_group_date date,
  obs_group_time time,
  encounter_type VARCHAR(255),
  location VARCHAR(255),
  concept VARCHAR(255) not null,
  date_created DATE
);
