create table mw_pdc_hearing_test (
  pdc_hearing_test_id 			int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  left_ear				varchar(255) default null,
  right_ear				varchar(255) default null,
  primary key (pdc_hearing_test_id)
) ;
