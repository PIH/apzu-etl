-- Derivation script for mw_ncd_diagnoses
-- Generated from Pentaho transform: import-into-mw-ncd-diagnoses.ktr

drop table if exists mw_ncd_diagnoses;
create table mw_ncd_diagnoses
(
    patient_id     int          not null,
    obs_group_id   int,
    diagnosis      varchar(100) not null,
    diagnosis_date date,
    encounter_type varchar(255),
    location       varchar(255)
);
alter table mw_ncd_diagnoses add index mw_ncd_diagnoses_patient_idx (patient_id);
alter table mw_ncd_diagnoses add index mw_ncd_diagnoses_obs_group_idx (obs_group_id);

insert into mw_ncd_diagnoses (patient_id, obs_group_id, diagnosis, encounter_type, location)
select
    diag.patient_id,
    diag.obs_group_id,
    diag.value_coded as diagnosis,
    diag.encounter_type,
    diag.location
from omrs_obs diag
where diag.concept = 'Chronic care diagnosis'
  and diag.encounter_type in (
      'DIABETES HYPERTENSION INITIAL VISIT',
      'CHRONIC_CARE_INITIAL',
      'MENTAL_HEALTH_INITIAL',
      'EPILEPSY_INITIAL',
      'CKD_INITIAL',
      'CHF_INITIAL',
      'NCD_OTHER_INITIAL',
      'ASTHMA_INITIAL',
      'SICKLE_CELL_DISEASE_INITIAL'
);

update mw_ncd_diagnoses d
inner join omrs_obs o on o.obs_group_id = d.obs_group_id and o.concept = 'Diagnosis date'
set d.diagnosis_date = o.value_date;

alter table mw_ncd_diagnoses drop column obs_group_id;
