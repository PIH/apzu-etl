create table omrs_relationship (
  relationship_id int not null,
  uuid char(38) not null,
  patient_id int not null,
  patient_role varchar(50) not null,
  related_person_role varchar(50) not null,
  related_person varchar(255),
  start_date date,
  end_date date,
  date_created date
);