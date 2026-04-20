-- Derivation script for mw_art_viral_load
-- Generated from Pentaho transform: import-into-mw-art-viral-load.ktr

drop table if exists mw_art_viral_load;
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

drop temporary table if exists temp_lower_than_detection_limit;
create temporary table temp_lower_than_detection_limit as select encounter_id, value_coded from omrs_obs where concept = 'Lower than Detection Limit';
alter table temp_lower_than_detection_limit add index temp_lower_than_detection_limit_encounter_idx (encounter_id);

drop temporary table if exists temp_sample_taken_for_viral_load;
create temporary table temp_sample_taken_for_viral_load as select encounter_id, value_coded from omrs_obs where concept = 'Sample taken for Viral Load';
alter table temp_sample_taken_for_viral_load add index temp_sample_taken_for_viral_load_encounter_idx (encounter_id);

drop temporary table if exists temp_location_of_laboratory;
create temporary table temp_location_of_laboratory as select encounter_id, value_coded from omrs_obs where concept = 'Location of laboratory';
alter table temp_location_of_laboratory add index temp_location_of_laboratory_encounter_idx (encounter_id);

drop temporary table if exists temp_less_than_limit;
create temporary table temp_less_than_limit as select encounter_id, value_numeric from omrs_obs where concept = 'Less than limit';
alter table temp_less_than_limit add index temp_less_than_limit_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_no_result;
create temporary table temp_reason_for_no_result as select encounter_id, value_coded from omrs_obs where concept = 'Reason for no result';
alter table temp_reason_for_no_result add index temp_reason_for_no_result_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_testing_coded;
create temporary table temp_reason_for_testing_coded as select encounter_id, value_coded from omrs_obs where concept = 'Reason for testing (coded)';
alter table temp_reason_for_testing_coded add index temp_reason_for_testing_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_viral_load_sample_id;
create temporary table temp_viral_load_sample_id as select encounter_id, value_text from omrs_obs where concept = 'Viral Load Sample ID';
alter table temp_viral_load_sample_id add index temp_viral_load_sample_id_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_viral_load;
create temporary table temp_hiv_viral_load as select encounter_id, value_numeric from omrs_obs where concept = 'HIV viral load';
alter table temp_hiv_viral_load add index temp_hiv_viral_load_encounter_idx (encounter_id);

insert into mw_art_viral_load (patient_id, visit_date, location, ldl, bled, lab_location, less_than_limit, other_results, reason_for_test, sample_id, viral_load_result)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(lower_than_detection_limit.value_coded) as ldl,
    max(sample_taken_for_viral_load.value_coded) as bled,
    max(location_of_laboratory.value_coded) as lab_location,
    max(less_than_limit.value_numeric) as less_than_limit,
    max(reason_for_no_result.value_coded) as other_results,
    max(reason_for_testing_coded.value_coded) as reason_for_test,
    max(viral_load_sample_id.value_text) as sample_id,
    max(hiv_viral_load.value_numeric) as viral_load_result
from omrs_encounter e
left join temp_lower_than_detection_limit lower_than_detection_limit on e.encounter_id = lower_than_detection_limit.encounter_id
left join temp_sample_taken_for_viral_load sample_taken_for_viral_load on e.encounter_id = sample_taken_for_viral_load.encounter_id
left join temp_location_of_laboratory location_of_laboratory on e.encounter_id = location_of_laboratory.encounter_id
left join temp_less_than_limit less_than_limit on e.encounter_id = less_than_limit.encounter_id
left join temp_reason_for_no_result reason_for_no_result on e.encounter_id = reason_for_no_result.encounter_id
left join temp_reason_for_testing_coded reason_for_testing_coded on e.encounter_id = reason_for_testing_coded.encounter_id
left join temp_viral_load_sample_id viral_load_sample_id on e.encounter_id = viral_load_sample_id.encounter_id
left join temp_hiv_viral_load hiv_viral_load on e.encounter_id = hiv_viral_load.encounter_id
where e.encounter_type in ('Viral Load Screening')
group by e.patient_id, e.encounter_date, e.location;