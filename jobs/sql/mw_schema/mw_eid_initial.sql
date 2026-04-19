create table mw_eid_initial (
  eid_initial_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  mother_hiv_status varchar(255) default null,
  mother_art_reg_no varchar(255) default null,
  mother_art_start_date date default null,
  age int default null,
  age_when_starting_nvp int default null,
  duration_type_when_starting_nvp varchar(255) default null,
  nvp_duration int default null,
  nvp_duration_type varchar(255) default null,
  birth_weight decimal(10,2) default null,
  primary key (eid_initial_visit_id)
);
