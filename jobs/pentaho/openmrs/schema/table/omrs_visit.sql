CREATE TABLE omrs_visit (
  visit_id INT not null,
  uuid CHAR(38) not null,
  patient_id INT not null,
  visit_type VARCHAR(255) not null,
  location VARCHAR(255),
  date_started date,
  date_stopped date,
  date_created DATE
);
