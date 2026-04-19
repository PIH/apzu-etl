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

insert into mw_art_viral_load
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Lower than Detection Limit' then o.value_coded end) as ldl,
    max(case when o.concept = 'Sample taken for Viral Load' then o.value_coded end) as bled,
    max(case when o.concept = 'Location of laboratory' then o.value_coded end) as lab_location,
    max(case when o.concept = 'Less than limit' then o.value_numeric end) as less_than_limit,
    max(case when o.concept = 'Reason for no result' then o.value_coded end) as other_results,
    max(case when o.concept = 'Reason for testing (coded)' then o.value_coded end) as reason_for_test,
    max(case when o.concept = 'Viral Load Sample ID' then o.value_text end) as sample_id,
    max(case when o.concept = 'HIV viral load' then o.value_numeric end) as viral_load_result
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Viral Load Screening')
group by e.patient_id, e.encounter_date, e.location;