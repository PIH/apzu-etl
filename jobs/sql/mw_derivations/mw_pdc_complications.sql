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

drop temporary table if exists temp_date_of_complication;
create temporary table temp_date_of_complication as select encounter_id, value_date from omrs_obs where concept = 'Date of complication';
alter table temp_date_of_complication add index temp_date_of_complication_encounter_idx (encounter_id);

drop temporary table if exists temp_details_of_complications;
create temporary table temp_details_of_complications as select encounter_id, value_text from omrs_obs where concept = 'Details of Complications';
alter table temp_details_of_complications add index temp_details_of_complications_encounter_idx (encounter_id);

drop temporary table if exists temp_complications_since_last_visit;
create temporary table temp_complications_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Complications since last visit';
alter table temp_complications_since_last_visit add index temp_complications_since_last_visit_encounter_idx (encounter_id);

insert into mw_pdc_complications
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_of_complication.value_date) as date_of_complication,
    max(details_of_complications.value_text) as details_of_complications,
    max(complications_since_last_visit.value_coded) as self_reported_complication
from omrs_encounter e
left join temp_date_of_complication date_of_complication on e.encounter_id = date_of_complication.encounter_id
left join temp_details_of_complications details_of_complications on e.encounter_id = details_of_complications.encounter_id
left join temp_complications_since_last_visit complications_since_last_visit on e.encounter_id = complications_since_last_visit.encounter_id
where e.encounter_type in ('PDC_COMPLICATIONS')
group by e.patient_id, e.encounter_date, e.location;