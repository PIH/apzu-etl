CREATE TABLE omrs_relationship (
  relationship_id INT not null,
  uuid CHAR(38) not null,
  patient_id INT not null,
  patient_role VARCHAR(50) not null,
  related_person_role VARCHAR(50) not null,
  related_person VARCHAR(255),
  start_date DATE,
  end_date DATE,
  date_created DATE
);
