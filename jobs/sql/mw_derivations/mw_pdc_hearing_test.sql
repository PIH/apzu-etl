-- Derivation script for mw_pdc_hearing_test
-- Generated from Pentaho transform: import-into-mw-pdc-hearing-test.ktr

drop table if exists mw_pdc_hearing_test;
create table mw_pdc_hearing_test (
  pdc_hearing_test_id 			int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  left_ear				varchar(255) default null,
  right_ear				varchar(255) default null,
  primary key (pdc_hearing_test_id)
) ;

drop temporary table if exists temp_left_ear;
create temporary table temp_left_ear as select encounter_id, value_coded from omrs_obs where concept = 'Left Ear';
alter table temp_left_ear add index temp_left_ear_encounter_idx (encounter_id);

drop temporary table if exists temp_right_ear;
create temporary table temp_right_ear as select encounter_id, value_coded from omrs_obs where concept = 'Right Ear';
alter table temp_right_ear add index temp_right_ear_encounter_idx (encounter_id);

insert into mw_pdc_hearing_test (patient_id, visit_date, location, left_ear, right_ear)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(left_ear.value_coded) as left_ear,
    max(right_ear.value_coded) as right_ear
from omrs_encounter e
left join temp_left_ear left_ear on e.encounter_id = left_ear.encounter_id
left join temp_right_ear right_ear on e.encounter_id = right_ear.encounter_id
where e.encounter_type in ('HEARING_TEST')
group by e.patient_id, e.encounter_date, e.location;