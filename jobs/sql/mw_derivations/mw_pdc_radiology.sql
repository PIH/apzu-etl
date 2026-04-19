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

insert into mw_pdc_radiology
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'ECHO imaging result' then o.value_text end) as echo_results,
    max(case when o.concept = 'Other lab test result' then o.value_text end) as other_results
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('RADIOLOGY_SCREENING')
group by e.patient_id, e.encounter_date, e.location;