-- Derivation script for mw_poc_checkin
-- Generated from Pentaho transform: import-into-mw-poc-checkin.ktr

drop table if exists mw_poc_checkin;
create table mw_poc_checkin (
  poc_checkin_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  creator varchar(255) default null,
  primary key (poc_checkin_visit_id)
);

insert into mw_poc_checkin (patient_id, visit_date, location)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location
from omrs_encounter e
group by e.patient_id, e.encounter_date, e.location;