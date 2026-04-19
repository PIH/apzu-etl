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

insert into mw_pdc_hearing_test
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Left Ear' then o.value_coded end) as left_ear,
    max(case when o.concept = 'Right Ear' then o.value_coded end) as right_ear
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('HEARING_TEST')
group by e.patient_id, e.encounter_date, e.location;