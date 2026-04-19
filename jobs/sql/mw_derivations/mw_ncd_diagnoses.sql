-- Derivation script for mw_ncd_diagnoses
-- Generated from Pentaho transform: import-into-mw-ncd-diagnoses.ktr

drop table if exists mw_ncd_diagnoses;
create table mw_ncd_diagnoses (
  patient_id     	int          not null,
  diagnosis      	varchar(100) not null,
  diagnosis_date 	date         not null,
  encounter_type       varchar(255),
  location       	varchar(255)
);
alter table mw_ncd_diagnoses add index mw_ncd_diagnoses_patient_idx (patient_id);

-- One row per NCD diagnosis, joined with its diagnosis date via obs_group_id
insert into mw_ncd_diagnoses (patient_id, diagnosis, diagnosis_date, encounter_type, location)
select
    diag.patient_id,
    diag.value_coded as diagnosis,
    ddate.value_date as diagnosis_date,
    diag.encounter_type,
    diag.location
from omrs_obs diag
left join omrs_obs ddate on ddate.obs_group_id = diag.obs_group_id
    and ddate.concept = 'Diagnosis date'
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
