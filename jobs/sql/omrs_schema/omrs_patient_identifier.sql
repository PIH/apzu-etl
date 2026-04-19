create table omrs_patient_identifier (
  patient_identifier_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  type varchar(50) not null,
  identifier varchar(50) not null,
  location varchar(255),
  date_created date
);