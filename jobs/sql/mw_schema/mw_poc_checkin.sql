create table mw_poc_checkin (
  poc_checkin_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  creator varchar(255) default null,
  primary key (poc_checkin_visit_id)
);
