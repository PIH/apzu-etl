-- Derivation script for mw_ncd_visits
-- Generated from Pentaho transform: import-into-mw-ncd-visits.ktr

drop table if exists mw_ncd_visits;
create table mw_ncd_visits (
  ncd_visit_id                      int not null auto_increment primary key,
  patient_id                        int not null,
  visit_date                        date,
  location                          varchar(255),
  visit_types                       varchar(255),
  cc_initial                        boolean,
  cc_followup                       boolean,
  diabetes_htn_initial              boolean,
  diabetes_htn_followup             boolean,
  asthma_initial                    boolean,
  asthma_followup                   boolean,
  epilepsy_initial                  boolean,
  epilepsy_followup                 boolean,
  mental_health_initial             boolean,
  mental_health_followup            boolean,
  ckd_initial			     boolean,
  ckd_followup			     boolean,
  chf_initial			     boolean,
  chf_followup			     boolean,
  ncd_other_initial                 boolean,
  ncd_other_followup                boolean,
  sickle_cell_initial               boolean,
  sickle_cell_followup              boolean,
  next_appointment_date             date,
  systolic_bp                       decimal(10,2),
  diastolic_bp                      decimal(10,2),
  on_insulin                        boolean,
  asthma_classification             varchar(100),
  seizure_activity                  boolean,
  num_seizures                      decimal(10,2),
  hba1c                             decimal(10,2),
  serum_glucose                     decimal(10,2),
  foot_check                        boolean,
  suicide_risk                      varchar(255),
  proteinuria                       varchar(255),
  creatinine                        decimal(10,2),
  hiv_result                        varchar(255),
  visual_acuity                     varchar(255),
  cv_risk                           decimal(10,2),
  hospitalized_since_last_visit     varchar(255),
  mental_status_exam                varchar(255),
  mental_health_drugs               varchar(255),
  mental_health_drug_side_effect    varchar(255),
  mental_stable                     varchar(255),
  fundoscopy                        varchar(255)
);
alter table mw_ncd_visits add index mw_ncd_visit_patient_idx (patient_id);
alter table mw_ncd_visits add index mw_ncd_visit_patient_location_idx (patient_id, location);

insert into mw_ncd_visits
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    group_concat(distinct e.encounter_type order by e.encounter_type asc SEPARATOR ', ') as visit_types,
    max(case when e.encounter_type = 'CHRONIC_CARE_INITIAL' then TRUE else FALSE end) as cc_initial,
    max(case when e.encounter_type = 'CHRONIC_CARE_FOLLOWUP' then TRUE else FALSE end) as cc_followup,
    max(case when e.encounter_type = 'DIABETES HYPERTENSION INITIAL VISIT' then TRUE else FALSE end) as diabetes_htn_initial,
    max(case when e.encounter_type = 'DIABETES HYPERTENSION FOLLOWUP' then TRUE else FALSE end) as diabetes_htn_followup,
    max(case when e.encounter_type = 'ASTHMA_INITIAL' then TRUE else FALSE end) as asthma_initial,
    max(case when e.encounter_type = 'ASTHMA_FOLLOWUP' then TRUE else FALSE end) as asthma_followup,
    max(case when e.encounter_type = 'EPILEPSY_INITIAL' then TRUE else FALSE end) as epilepsy_initial,
    max(case when e.encounter_type = 'EPILEPSY_FOLLOWUP' then TRUE else FALSE end) as epilepsy_followup,
    max(case when e.encounter_type = 'MENTAL_HEALTH_INITIAL' then TRUE else FALSE end) as mental_health_initial,
    max(case when e.encounter_type = 'MENTAL_HEALTH_FOLLOWUP' then TRUE else FALSE end) as mental_health_followup,
    max(case when e.encounter_type = 'CKD_INITIAL' then TRUE else FALSE end) as ckd_initial,
    max(case when e.encounter_type = 'CKD_FOLLOWUP' then TRUE else FALSE end) as ckd_followup,
    max(case when e.encounter_type = 'CHF_INITIAL' then TRUE else FALSE end) as chf_initial,
    max(case when e.encounter_type = 'CHF_FOLLOWUP' then TRUE else FALSE end) as chf_followup,
    max(case when e.encounter_type = 'NCD_OTHER_INITIAL' then TRUE else FALSE end) as ncd_other_initial,
    max(case when e.encounter_type = 'NCD_OTHER_FOLLOWUP' then TRUE else FALSE end) as ncd_other_followup,
    max(case when e.encounter_type = 'SICKLE_CELL_DISEASE_INITIAL' then TRUE else FALSE end) as sickle_cell_initial,
    max(case when e.encounter_type = 'SICKLE_CELL_DISEASE_FOLLOWUP' then TRUE else FALSE end) as sickle_cell_followup,
    min(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Systolic blood pressure' then o.value_numeric end) as systolic_bp,
    max(case when o.concept = 'Diastolic blood pressure' then o.value_numeric end) as diastolic_bp,
    max(case when o.concept = 'Current drugs used' and o.value_coded = 'Insulin' then TRUE else FALSE end) as on_insulin,
    max(case when o.concept = 'Asthma classification' then o.value_coded end) as asthma_classification,
    max(case when o.concept = 'Seizure activity' and o.value_coded = 'Seizure since last visit' then TRUE else FALSE end) as seizure_activity,
    max(case when o.concept = 'NUMBER OF SEIZURES' then o.value_numeric end) as num_seizures,
    max(case when o.concept = 'Glycated hemoglobin' then o.value_numeric end) as hba1c,
    max(case when o.concept = 'Serum glucose' then o.value_numeric end) as serum_glucose,
    case when (
        max(case when o.concept = 'Neuropathy and Peripheral Vascular Disease' then 1 else 0 end) +
        max(case when o.concept = 'Deformity of foot' then 1 else 0 end) +
        max(case when o.concept = 'Foot ulcer or infection' then 1 else 0 end)
    ) = 3 then 1 end as foot_check,
    max(case when o.concept = 'Suicide risk' then o.value_coded end) as suicide_risk,
    max(case when o.concept = 'Urine protein' then o.value_coded end) as proteinuria,
    max(case when o.concept = 'Creatinine' then o.value_numeric end) as creatinine,
    max(case when o.concept = 'Result of HIV test' then o.value_coded end) as hiv_result,
    max(case when o.concept = 'Visual acuity (text)' then o.value_text end) as visual_acuity,
    max(case when o.concept = 'Cardiovascular risk score' then o.value_numeric end) as cv_risk,
    max(case when o.concept in ('Patient hospitalized since last visit', 'Hospitalized for mental health since last visit') then o.value_coded end) as hospitalized_since_last_visit,
    max(case when o.concept = 'Mental health chief complaint absent' then o.value_coded end) as mental_status_exam,
    group_concat(case when o.concept = 'Current drugs used' and e.encounter_type = 'MENTAL_HEALTH_FOLLOWUP' then o.value_coded end) as mental_health_drugs,
    max(case when o.concept = 'Does patient have adverse effects' then o.value_coded end) as mental_health_drug_side_effect,
    max(case when o.concept = 'Stable' then o.value_coded end) as mental_stable,
    max(case when o.concept = 'Fundoscopy' then o.value_text end) as fundoscopy
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in (
    'CHRONIC_CARE_INITIAL', 'CHRONIC_CARE_FOLLOWUP',
    'DIABETES HYPERTENSION INITIAL VISIT', 'DIABETES HYPERTENSION FOLLOWUP',
    'ASTHMA_INITIAL', 'ASTHMA_FOLLOWUP',
    'EPILEPSY_INITIAL', 'EPILEPSY_FOLLOWUP',
    'MENTAL_HEALTH_INITIAL', 'MENTAL_HEALTH_FOLLOWUP',
    'CKD_INITIAL', 'CKD_FOLLOWUP',
    'CHF_INITIAL', 'CHF_FOLLOWUP',
    'NCD_OTHER_INITIAL', 'NCD_OTHER_FOLLOWUP',
    'SICKLE_CELL_DISEASE_INITIAL', 'SICKLE_CELL_DISEASE_FOLLOWUP'
)
group by e.patient_id, e.encounter_date, e.location;

