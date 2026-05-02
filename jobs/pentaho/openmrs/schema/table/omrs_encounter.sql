CREATE TABLE omrs_encounter (
  encounter_id INT not null,
  uuid CHAR(38) not null,
  patient_id INT not null,
  encounter_type VARCHAR(255) not null,
  form VARCHAR(255),
  location VARCHAR(255),
  encounter_date date,
  encounter_time time,
  provider VARCHAR(255),
  provider_role VARCHAR(255),
  visit_id INT,
  age_years_at_encounter INT,
  age_months_at_encounter INT,
  date_created DATE,
  created_by VARCHAR(100)
);
