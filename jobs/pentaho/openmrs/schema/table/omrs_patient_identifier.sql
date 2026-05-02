CREATE TABLE omrs_patient_identifier (
  patient_identifier_id INT not null,
  uuid CHAR(38) not null,
  patient_id INT not null,
  type VARCHAR(50) not null,
  identifier VARCHAR(50) not null,
  location VARCHAR(255),
  date_created DATE
);
