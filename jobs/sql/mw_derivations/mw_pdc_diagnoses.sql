-- Derivation script for mw_pdc_diagnoses
-- Generated from Pentaho transform: import-into-mw-pdc-diagnoses.ktr

drop table if exists mw_pdc_diagnoses;
create table mw_pdc_diagnoses (
  patient_id     	int          not null,
  diagnosis    	varchar(255) not null,
  comments		varchar(255) default null,
  encounter_type 	varchar(255) not null,
  location  		varchar(255) not null,
  visit_date		date
);
alter table mw_pdc_diagnoses add index mw_pdc_diagnoses_patient_idx (patient_id);

insert into mw_pdc_diagnoses (patient_id, visit_date, diagnosis, comments, encounter_type, location)
select
    o.patient_id,
    o.obs_date as visit_date,
    o.value_coded as diagnosis,
    o.comments,
    o.encounter_type,
    o.location
from omrs_obs o
where o.concept = 'diagnosis'
and o.encounter_type = 'PDC_INITIAL';
