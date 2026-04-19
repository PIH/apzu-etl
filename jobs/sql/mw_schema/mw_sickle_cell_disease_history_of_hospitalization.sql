create table mw_sickle_cell_disease_history_of_hospitalization (
  sickle_cell_disease_history_of_hospitalization int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  length_of_stay			int not null,
  reason_for_admission			varchar(255) default null,
  discharge_diagnosis			varchar(255) default null,
  discharge_medications			varchar(255) default null,
  primary key (sickle_cell_disease_history_of_hospitalization));
