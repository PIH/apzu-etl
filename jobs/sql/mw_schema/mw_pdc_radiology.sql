create table mw_pdc_radiology (
  pdc_radiology_id 			int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  echo_results				varchar(255) default null,
  other_results			varchar(255) default null,
  primary key (pdc_radiology_id)
) ;
