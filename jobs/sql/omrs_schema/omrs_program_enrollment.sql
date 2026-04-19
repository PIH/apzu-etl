create table omrs_program_enrollment (
  program_enrollment_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  program varchar(100) not null,
  enrollment_date date not null,
  age_years_at_enrollment int,
  age_months_at_enrollment int,
  location varchar(255),
  completion_date date,
  age_years_at_completion int,
  age_months_at_completion int,
  outcome varchar(255)
);