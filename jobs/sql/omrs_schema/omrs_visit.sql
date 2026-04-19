create table omrs_visit (
  visit_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  visit_type varchar(255) not null,
  location varchar(255),
  date_started date,
  date_stopped date,
  date_created date
);