create table mw_pdc_vision_test(
  pdc_vision_test_id 			int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  test_results				varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  primary key (pdc_vision_test_id)
) ;
