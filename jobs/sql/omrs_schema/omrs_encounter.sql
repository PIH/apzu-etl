create table omrs_encounter (
  encounter_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  encounter_type varchar(255) not null,
  form varchar(255),
  location varchar(255),
  encounter_date date,
  encounter_time time,
  provider varchar(255),
  provider_role varchar(255),
  visit_id int,
  age_years_at_encounter int,
  age_months_at_encounter int,
  date_created date,
  created_by varchar(100)
);

alter table omrs_encounter add index omrs_encounter_id_idx (encounter_id);
alter table omrs_encounter add index omrs_encounter_patient_idx (patient_id);
alter table omrs_encounter add index omrs_encounter_date_idx (encounter_date);
alter table omrs_encounter add index omrs_encounter_time_idx (encounter_time);
alter table omrs_encounter add index omrs_encounter_type_idx (encounter_type);
alter table omrs_encounter add index omrs_encounter_form_idx (form);
alter table omrs_encounter add index omrs_encounter_location_idx (location);
