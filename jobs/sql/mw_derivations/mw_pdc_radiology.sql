-- Derivation script for mw_pdc_radiology
-- Generated from Pentaho transform: import-into-mw-pdc-radiology.ktr

drop table if exists mw_pdc_radiology;
create table mw_pdc_radiology (
  pdc_radiology_id 			int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  echo_results				varchar(255) default null,
  other_results			varchar(255) default null,
  primary key (pdc_radiology_id)
) ;

drop temporary table if exists temp_echo_imaging_result;
create temporary table temp_echo_imaging_result as select encounter_id, value_text from omrs_obs where concept = 'ECHO imaging result';
alter table temp_echo_imaging_result add index temp_echo_imaging_result_encounter_idx (encounter_id);

drop temporary table if exists temp_other_lab_test_result;
create temporary table temp_other_lab_test_result as select encounter_id, value_text from omrs_obs where concept = 'Other lab test result';
alter table temp_other_lab_test_result add index temp_other_lab_test_result_encounter_idx (encounter_id);

insert into mw_pdc_radiology
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(echo_imaging_result.value_text) as echo_results,
    max(other_lab_test_result.value_text) as other_results
from omrs_encounter e
left join temp_echo_imaging_result echo_imaging_result on e.encounter_id = echo_imaging_result.encounter_id
left join temp_other_lab_test_result other_lab_test_result on e.encounter_id = other_lab_test_result.encounter_id
where e.encounter_type in ('RADIOLOGY_SCREENING')
group by e.patient_id, e.encounter_date, e.location;