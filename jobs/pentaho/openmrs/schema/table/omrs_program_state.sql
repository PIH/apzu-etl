CREATE TABLE omrs_program_state (
  program_state_id INT not null,
  uuid CHAR(38) not null,
  program_enrollment_id INT not null,
  patient_id INT not null,
  program VARCHAR(100) not null,
  workflow VARCHAR(100) not null,
  state VARCHAR(100) not null,
  start_date date not null,
  age_years_at_start int,
  age_months_at_start int,
  end_date date,
  age_years_at_end int,
  age_months_at_end int,
  location VARCHAR(255)
);
