create table mw_art_viral_load (
  viral_load_visit_id 		int not null auto_increment,
  patient_id 			int not null,
  visit_date 			date default null,
  location 			varchar(255) default null,
  reason_for_test		varchar(255) default null,
  lab_location 		varchar(255) default null,
  bled 			varchar(255) default null,
  sample_id 			varchar(255) default null,
  viral_load_result 		int default null,
  less_than_limit 		int default null,
  ldl 				varchar(255) default null,
  other_results 		varchar(255) default null,
  primary key (viral_load_visit_id)
);
