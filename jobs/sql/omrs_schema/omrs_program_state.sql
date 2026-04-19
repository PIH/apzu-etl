create table omrs_program_state (
  program_state_id int not null,
  uuid char(38) not null,
  program_enrollment_id int not null,
  patient_id int not null,
  program varchar(100) not null,
  workflow varchar(100) not null,
  state varchar(100) not null,
  start_date date not null,
  age_years_at_start int,
  age_months_at_start int,
  end_date date,
  age_years_at_end int,
  age_months_at_end int,
  location varchar(255)
);

alter table omrs_program_state add index omrs_program_state_id_idx (program_state_id);
alter table omrs_program_state add index omrs_program_state_enrollment_id_idx (program_enrollment_id);
