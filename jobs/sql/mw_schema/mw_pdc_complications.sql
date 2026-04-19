create table mw_pdc_complications (
  pdc_complications_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  date_of_complication			date default null,
  self_reported_complication		varchar(255) default null,
  details_of_complications		varchar(255) default null,
  primary key (pdc_complications_id)
) ;
