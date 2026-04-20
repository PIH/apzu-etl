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

drop temporary table if exists temp_referred_out;
create temporary table temp_referred_out as select encounter_id, value_coded from omrs_obs where concept = 'Referred out';
alter table temp_referred_out add index temp_referred_out_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

drop temporary table if exists temp_test_result;
create temporary table temp_test_result as select encounter_id, value_coded from omrs_obs where concept = 'Test Result';
alter table temp_test_result add index temp_test_result_encounter_idx (encounter_id);

insert into mw_pdc_vision_test
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(referred_out.value_coded) as referred_out,
    max(other_non_coded_text.value_text) as referred_out_specify,
    max(test_result.value_coded) as test_results
from omrs_encounter e
left join temp_referred_out referred_out on e.encounter_id = referred_out.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_test_result test_result on e.encounter_id = test_result.encounter_id
where e.encounter_type in ('VISION_TEST')
group by e.patient_id, e.encounter_date, e.location;