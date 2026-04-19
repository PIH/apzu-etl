create table mw_sickle_cell_disease_quarterly_screening (
  sickle_cell_disease_quarterly_screening_visit_id int not null auto_increment,
  patient_id int(11) not null,
  visit_date date null default null,
  location varchar(255) null default null,
  hiv_status varchar(255) null default null,
  fcb varchar(255) null default null,
  primary key (sickle_cell_disease_quarterly_screening_visit_id));

