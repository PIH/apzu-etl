create table mw_pdc_history_of_hospitalization (
  pdc_history_of_hospitalization_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  discharge_date			date default null,
  reason_for_admission			varchar(255) default null,
  discharge_diagnosis			varchar(255) default null,
  discharge_medications			varchar(255) default null,
  primary key (pdc_history_of_hospitalization_id)
) ;
