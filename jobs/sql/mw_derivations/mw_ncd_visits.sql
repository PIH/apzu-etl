-- Derivation script for mw_ncd_visits
-- Generated from Pentaho transform: import-into-mw-ncd-visits.ktr

SET SESSION group_concat_max_len = 1000000;

drop table if exists mw_ncd_visits;
create table mw_ncd_visits
(
    ncd_visit_id                   int not null auto_increment primary key,
    patient_id                     int not null,
    visit_date                     date,
    location                       varchar(255),
    visit_types                    varchar(255),
    cc_initial                     boolean,
    cc_followup                    boolean,
    diabetes_htn_initial           boolean,
    diabetes_htn_followup          boolean,
    asthma_initial                 boolean,
    asthma_followup                boolean,
    epilepsy_initial               boolean,
    epilepsy_followup              boolean,
    mental_health_initial          boolean,
    mental_health_followup         boolean,
    ckd_initial                    boolean,
    ckd_followup                   boolean,
    chf_initial                    boolean,
    chf_followup                   boolean,
    ncd_other_initial              boolean,
    ncd_other_followup             boolean,
    sickle_cell_initial            boolean,
    sickle_cell_followup           boolean,
    next_appointment_date          date,
    systolic_bp                    decimal(10, 2),
    diastolic_bp                   decimal(10, 2),
    on_insulin                     boolean,
    asthma_classification          varchar(100),
    seizure_activity               boolean,
    num_seizures                   decimal(10, 2),
    hba1c                          decimal(10, 2),
    serum_glucose                  decimal(10, 2),
    foot_check                     boolean,
    suicide_risk                   varchar(255),
    proteinuria                    varchar(255),
    creatinine                     decimal(10, 2),
    hiv_result                     varchar(255),
    visual_acuity                  varchar(255),
    cv_risk                        decimal(10, 2),
    hospitalized_since_last_visit  varchar(255),
    mental_status_exam             varchar(255),
    mental_health_drugs            text,
    mental_health_drug_side_effect varchar(255),
    mental_stable                  varchar(255),
    fundoscopy                     varchar(255)
);
alter table mw_ncd_visits add index mw_ncd_visit_patient_idx (patient_id);
alter table mw_ncd_visits add index mw_ncd_visit_patient_location_idx (patient_id, location);

drop temporary table if exists temp_ncd_visits_obs;
create temporary table temp_ncd_visits_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text, encounter_type
from omrs_obs
where encounter_type in (
    'CHRONIC_CARE_INITIAL', 'CHRONIC_CARE_FOLLOWUP',
    'DIABETES HYPERTENSION INITIAL VISIT', 'DIABETES HYPERTENSION FOLLOWUP',
    'ASTHMA_INITIAL', 'ASTHMA_FOLLOWUP',
    'EPILEPSY_INITIAL', 'EPILEPSY_FOLLOWUP',
    'MENTAL_HEALTH_INITIAL', 'MENTAL_HEALTH_FOLLOWUP',
    'CKD_INITIAL', 'CKD_FOLLOWUP',
    'CHF_INITIAL', 'CHF_FOLLOWUP',
    'NCD_OTHER_INITIAL', 'NCD_OTHER_FOLLOWUP',
    'SICKLE_CELL_DISEASE_INITIAL', 'SICKLE_CELL_DISEASE_FOLLOWUP'
);
alter table temp_ncd_visits_obs add index temp_ncd_visits_obs_concept_idx (concept);
alter table temp_ncd_visits_obs add index temp_ncd_visits_obs_encounter_idx (encounter_id);
alter table temp_ncd_visits_obs add index temp_ncd_visits_obs_group_idx (obs_group_id);

-- Pre-aggregate mental health drugs separately (requires encounter_type filter)
drop temporary table if exists temp_mental_health_drugs;
create temporary table temp_mental_health_drugs as
select encounter_id, group_concat(value_coded) as mental_health_drugs
from temp_ncd_visits_obs
where concept = 'Current drugs used' and encounter_type = 'MENTAL_HEALTH_FOLLOWUP'
group by encounter_id;
alter table temp_mental_health_drugs add index temp_mental_health_drugs_encounter_idx (encounter_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    min(case when concept = 'Appointment date'                                                                       then value_date    end) as next_appointment_date,
    max(case when concept = 'Asthma classification'                                                                  then value_coded   end) as asthma_classification,
    max(case when concept = 'Cardiovascular risk score'                                                              then value_numeric end) as cv_risk,
    max(case when concept = 'Creatinine'                                                                             then value_numeric end) as creatinine,
    max(case when concept = 'Current drugs used' and value_coded = 'Insulin'                                         then TRUE else FALSE end) as on_insulin,
    max(case when concept = 'Deformity of foot'                                                                      then 1 else 0 end) as has_deformity_of_foot,
    max(case when concept = 'Diastolic blood pressure'                                                               then value_numeric end) as diastolic_bp,
    max(case when concept = 'Does patient have adverse effects'                                                      then value_coded   end) as mental_health_drug_side_effect,
    max(case when concept = 'Foot ulcer or infection'                                                                then 1 else 0 end) as has_foot_ulcer,
    max(case when concept = 'Fundoscopy'                                                                             then value_text    end) as fundoscopy,
    max(case when concept = 'Glycated hemoglobin'                                                                    then value_numeric end) as hba1c,
    max(case when concept in ('Hospitalized for mental health since last visit',
                              'Patient hospitalized since last visit')                                               then value_coded   end) as hospitalized_since_last_visit,
    max(case when concept = 'Mental health chief complaint absent'                                                   then value_coded   end) as mental_status_exam,
    max(case when concept = 'Neuropathy and Peripheral Vascular Disease'                                             then 1 else 0 end) as has_neuropathy,
    max(case when concept = 'NUMBER OF SEIZURES'                                                                     then value_numeric end) as num_seizures,
    max(case when concept = 'Result of HIV test'                                                                     then value_coded   end) as hiv_result,
    max(case when concept = 'Seizure activity' and value_coded = 'Seizure since last visit'                          then TRUE else FALSE end) as seizure_activity,
    max(case when concept = 'Serum glucose'                                                                          then value_numeric end) as serum_glucose,
    max(case when concept = 'Stable'                                                                                 then value_coded   end) as mental_stable,
    max(case when concept = 'Suicide risk'                                                                           then value_coded   end) as suicide_risk,
    max(case when concept = 'Systolic blood pressure'                                                                then value_numeric end) as systolic_bp,
    max(case when concept = 'Urine protein'                                                                          then value_coded   end) as proteinuria,
    max(case when concept = 'Visual acuity (text)'                                                                   then value_text    end) as visual_acuity
from temp_ncd_visits_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_ncd_visits (patient_id, visit_date, location, visit_types, cc_initial, cc_followup, diabetes_htn_initial, diabetes_htn_followup, asthma_initial, asthma_followup, epilepsy_initial, epilepsy_followup, mental_health_initial, mental_health_followup, ckd_initial, ckd_followup, chf_initial, chf_followup, ncd_other_initial, ncd_other_followup, sickle_cell_initial, sickle_cell_followup, next_appointment_date, systolic_bp, diastolic_bp, on_insulin, asthma_classification, seizure_activity, num_seizures, hba1c, serum_glucose, foot_check, suicide_risk, proteinuria, creatinine, hiv_result, visual_acuity, cv_risk, hospitalized_since_last_visit, mental_status_exam, mental_health_drugs, mental_health_drug_side_effect, mental_stable, fundoscopy)
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
    sv.next_appointment_date,
    sv.systolic_bp,
    sv.diastolic_bp,
    sv.on_insulin,
    sv.asthma_classification,
    sv.seizure_activity,
    sv.num_seizures,
    sv.hba1c,
    sv.serum_glucose,
    case when (sv.has_neuropathy + sv.has_deformity_of_foot + sv.has_foot_ulcer) = 3 then 1 end as foot_check,
    sv.suicide_risk,
    sv.proteinuria,
    sv.creatinine,
    sv.hiv_result,
    sv.visual_acuity,
    sv.cv_risk,
    sv.hospitalized_since_last_visit,
    sv.mental_status_exam,
    mhd.mental_health_drugs,
    sv.mental_health_drug_side_effect,
    sv.mental_stable,
    sv.fundoscopy
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
left join temp_mental_health_drugs mhd on mhd.encounter_id = e.encounter_id
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

drop temporary table if exists temp_ncd_visits_obs;
drop temporary table if exists temp_mental_health_drugs;
drop temporary table if exists temp_single_values;
