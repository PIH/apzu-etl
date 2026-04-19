-- Derivation script for mw_pdc_complications
-- Generated from Pentaho transform: import-into-mw-pdc-complications.ktr

drop table if exists mw_pdc_complications;
create table mw_pdc_complications (
  pdc_complications_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  date_of_complication			date default null,
  self_reported_complication		varchar(255) default null,
  details_of_complications		varchar(255) default null,
  primary key (pdc_complications_id)
) ;

insert into mw_pdc_complications
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date of complication' then o.value_date end) as date_of_complication,
    max(case when o.concept = 'Details of Complications' then o.value_text end) as details_of_complications,
    max(case when o.concept = 'Complications since last visit' then o.value_coded end) as self_reported_complication
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_COMPLICATIONS')
group by e.patient_id, e.encounter_date, e.location;