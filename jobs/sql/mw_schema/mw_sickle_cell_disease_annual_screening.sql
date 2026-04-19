create table mw_sickle_cell_disease_annual_screening (
  sickle_cell_disease_annual_screening_visit_id int not null auto_increment,
  patient_id int(11) not null,
  visit_date date null default null,
  location varchar(255) null default null,
  cr int null default null,
  alt int null default null,
  ast int null default null,
  bil int null,
  dir_bil int null,
  in_bili int null,
  primary key (sickle_cell_disease_annual_screening_visit_id));

