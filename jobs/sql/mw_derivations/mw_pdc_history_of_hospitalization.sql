-- Derivation script for mw_pdc_history_of_hospitalization
-- Generated from Pentaho transform: import-into-mw-pdc-history-of-hospitalization.ktr

drop table if exists mw_pdc_history_of_hospitalization;
create table mw_pdc_history_of_hospitalization (
  pdc_history_of_hospitalization_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  discharge_date			date default null,
  reason_for_admission			varchar(255) default null,
  discharge_diagnosis			varchar(255) default null,
  discharge_medications			varchar(255) default null,
  primary key (pdc_history_of_hospitalization_id)
) ;

insert into mw_pdc_history_of_hospitalization
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Hospitalization discharge date' then o.value_date end) as discharge_date,
    max(case when o.concept = 'Discharge medications (text)' then o.value_text end) as discharge_medications,
    max(case when o.concept = 'Discharge diagnosis (text)' then o.value_text end) as discharge_diagnosis,
    max(case when o.concept = 'Reason for admission (text)' then o.value_text end) as reason_for_admission
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_HOSPITALIZATION_HISTORY')
group by e.patient_id, e.encounter_date, e.location;