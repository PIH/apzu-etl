-- Derivation script for mw_pdc_vision_test
-- Generated from Pentaho transform: import-into-mw-pdc-vision-test.ktr

drop table if exists mw_pdc_vision_test;
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

insert into mw_pdc_vision_test
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Referred out' then o.value_coded end) as referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as referred_out_specify,
    max(case when o.concept = 'Test Result' then o.value_coded end) as test_results
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('VISION_TEST')
group by e.patient_id, e.encounter_date, e.location;