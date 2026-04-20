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

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_asthma_classification;
create temporary table temp_asthma_classification as select encounter_id, value_coded from omrs_obs where concept = 'Asthma classification';
alter table temp_asthma_classification add index temp_asthma_classification_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_seizures;
create temporary table temp_number_of_seizures as select encounter_id, value_numeric from omrs_obs where concept = 'NUMBER OF SEIZURES';
alter table temp_number_of_seizures add index temp_number_of_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_glycated_hemoglobin;
create temporary table temp_glycated_hemoglobin as select encounter_id, value_numeric from omrs_obs where concept = 'Glycated hemoglobin';
alter table temp_glycated_hemoglobin add index temp_glycated_hemoglobin_encounter_idx (encounter_id);

drop temporary table if exists temp_serum_glucose;
create temporary table temp_serum_glucose as select encounter_id, value_numeric from omrs_obs where concept = 'Serum glucose';
alter table temp_serum_glucose add index temp_serum_glucose_encounter_idx (encounter_id);

drop temporary table if exists temp_suicide_risk;
create temporary table temp_suicide_risk as select encounter_id, value_coded from omrs_obs where concept = 'Suicide risk';
alter table temp_suicide_risk add index temp_suicide_risk_encounter_idx (encounter_id);

drop temporary table if exists temp_urine_protein;
create temporary table temp_urine_protein as select encounter_id, value_coded from omrs_obs where concept = 'Urine protein';
alter table temp_urine_protein add index temp_urine_protein_encounter_idx (encounter_id);

drop temporary table if exists temp_creatinine;
create temporary table temp_creatinine as select encounter_id, value_numeric from omrs_obs where concept = 'Creatinine';
alter table temp_creatinine add index temp_creatinine_encounter_idx (encounter_id);

drop temporary table if exists temp_result_of_hiv_test;
create temporary table temp_result_of_hiv_test as select encounter_id, value_coded from omrs_obs where concept = 'Result of HIV test';
alter table temp_result_of_hiv_test add index temp_result_of_hiv_test_encounter_idx (encounter_id);

drop temporary table if exists temp_visual_acuity_text;
create temporary table temp_visual_acuity_text as select encounter_id, value_text from omrs_obs where concept = 'Visual acuity (text)';
alter table temp_visual_acuity_text add index temp_visual_acuity_text_encounter_idx (encounter_id);

drop temporary table if exists temp_cardiovascular_risk_score;
create temporary table temp_cardiovascular_risk_score as select encounter_id, value_numeric from omrs_obs where concept = 'Cardiovascular risk score';
alter table temp_cardiovascular_risk_score add index temp_cardiovascular_risk_score_encounter_idx (encounter_id);

drop temporary table if exists temp_mental_health_chief_complaint_absent;
create temporary table temp_mental_health_chief_complaint_absent as select encounter_id, value_coded from omrs_obs where concept = 'Mental health chief complaint absent';
alter table temp_mental_health_chief_complaint_absent add index temp_mental_health_chief_complaint_absent_2 (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from omrs_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_seizure_activity;
create temporary table temp_seizure_activity as select encounter_id, value_coded from omrs_obs where concept = 'Seizure activity';
alter table temp_seizure_activity add index temp_seizure_activity_encounter_idx (encounter_id);

drop temporary table if exists temp_neuropathy_and_peripheral_vascular_disease;
create temporary table temp_neuropathy_and_peripheral_vascular_disease as select encounter_id, value_coded from omrs_obs where concept = 'Neuropathy and Peripheral Vascular Disease';
alter table temp_neuropathy_and_peripheral_vascular_disease add index temp_neuropathy_and_peripheral_vascular_disease_2 (encounter_id);

drop temporary table if exists temp_deformity_of_foot;
create temporary table temp_deformity_of_foot as select encounter_id, value_coded from omrs_obs where concept = 'Deformity of foot';
alter table temp_deformity_of_foot add index temp_deformity_of_foot_encounter_idx (encounter_id);

drop temporary table if exists temp_foot_ulcer_or_infection;
create temporary table temp_foot_ulcer_or_infection as select encounter_id, value_coded from omrs_obs where concept = 'Foot ulcer or infection';
alter table temp_foot_ulcer_or_infection add index temp_foot_ulcer_or_infection_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_hospitalized_since_last_visit;
create temporary table temp_patient_hospitalized_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Patient hospitalized since last visit';
alter table temp_patient_hospitalized_since_last_visit add index temp_patient_hospitalized_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_hospitalized_mental_health_since_last_visit;
create temporary table temp_hospitalized_mental_health_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Hospitalized for mental health since last visit';
alter table temp_hospitalized_mental_health_since_last_visit add index temp_hospitalized_mental_health_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_does_patient_have_adverse_effects;
create temporary table temp_does_patient_have_adverse_effects as select encounter_id, value_coded from omrs_obs where concept = 'Does patient have adverse effects';
alter table temp_does_patient_have_adverse_effects add index temp_does_patient_adverse_effects_encounter_idx (encounter_id);

drop temporary table if exists temp_stable;
create temporary table temp_stable as select encounter_id, value_coded from omrs_obs where concept = 'Stable';
alter table temp_stable add index temp_stable_encounter_idx (encounter_id);

drop temporary table if exists temp_fundoscopy;
create temporary table temp_fundoscopy as select encounter_id, value_text from omrs_obs where concept = 'Fundoscopy';
alter table temp_fundoscopy add index temp_fundoscopy_encounter_idx (encounter_id);

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
    min(appointment_date.value_date) as next_appointment_date,
    max(systolic_blood_pressure.value_numeric) as systolic_bp,
    max(diastolic_blood_pressure.value_numeric) as diastolic_bp,
    max(case when current_drugs_used.value_coded = 'Insulin' then TRUE else FALSE end) as on_insulin,
    max(asthma_classification.value_coded) as asthma_classification,
    max(case when seizure_activity.value_coded = 'Seizure since last visit' then TRUE else FALSE end) as seizure_activity,
    max(number_of_seizures.value_numeric) as num_seizures,
    max(glycated_hemoglobin.value_numeric) as hba1c,
    max(serum_glucose.value_numeric) as serum_glucose,
    case when (
        max(case when neuropathy_and_peripheral_vascular_disease.encounter_id is not null then 1 else 0 end) +
        max(case when deformity_of_foot.encounter_id is not null then 1 else 0 end) +
        max(case when foot_ulcer_or_infection.encounter_id is not null then 1 else 0 end)
    ) = 3 then 1 end as foot_check,
    max(suicide_risk.value_coded) as suicide_risk,
    max(urine_protein.value_coded) as proteinuria,
    max(creatinine.value_numeric) as creatinine,
    max(result_of_hiv_test.value_coded) as hiv_result,
    max(visual_acuity_text.value_text) as visual_acuity,
    max(cardiovascular_risk_score.value_numeric) as cv_risk,
    max(coalesce(patient_hospitalized_since_last_visit.value_coded, hospitalized_for_mental_health_since_last_visit.value_coded)) as hospitalized_since_last_visit,
    max(mental_health_chief_complaint_absent.value_coded) as mental_status_exam,
    group_concat(case when e.encounter_type = 'MENTAL_HEALTH_FOLLOWUP' then current_drugs_used.value_coded end) as mental_health_drugs,
    max(does_patient_have_adverse_effects.value_coded) as mental_health_drug_side_effect,
    max(stable.value_coded) as mental_stable,
    max(fundoscopy.value_text) as fundoscopy
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_asthma_classification asthma_classification on e.encounter_id = asthma_classification.encounter_id
left join temp_number_of_seizures number_of_seizures on e.encounter_id = number_of_seizures.encounter_id
left join temp_glycated_hemoglobin glycated_hemoglobin on e.encounter_id = glycated_hemoglobin.encounter_id
left join temp_serum_glucose serum_glucose on e.encounter_id = serum_glucose.encounter_id
left join temp_suicide_risk suicide_risk on e.encounter_id = suicide_risk.encounter_id
left join temp_urine_protein urine_protein on e.encounter_id = urine_protein.encounter_id
left join temp_creatinine creatinine on e.encounter_id = creatinine.encounter_id
left join temp_result_of_hiv_test result_of_hiv_test on e.encounter_id = result_of_hiv_test.encounter_id
left join temp_visual_acuity_text visual_acuity_text on e.encounter_id = visual_acuity_text.encounter_id
left join temp_cardiovascular_risk_score cardiovascular_risk_score on e.encounter_id = cardiovascular_risk_score.encounter_id
left join temp_mental_health_chief_complaint_absent mental_health_chief_complaint_absent on e.encounter_id = mental_health_chief_complaint_absent.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_does_patient_have_adverse_effects does_patient_have_adverse_effects on e.encounter_id = does_patient_have_adverse_effects.encounter_id
left join temp_stable stable on e.encounter_id = stable.encounter_id
left join temp_fundoscopy fundoscopy on e.encounter_id = fundoscopy.encounter_id
left join temp_seizure_activity seizure_activity on e.encounter_id = seizure_activity.encounter_id
left join temp_neuropathy_and_peripheral_vascular_disease neuropathy_and_peripheral_vascular_disease on e.encounter_id = neuropathy_and_peripheral_vascular_disease.encounter_id
left join temp_deformity_of_foot deformity_of_foot on e.encounter_id = deformity_of_foot.encounter_id
left join temp_foot_ulcer_or_infection foot_ulcer_or_infection on e.encounter_id = foot_ulcer_or_infection.encounter_id
left join temp_patient_hospitalized_since_last_visit patient_hospitalized_since_last_visit on e.encounter_id = patient_hospitalized_since_last_visit.encounter_id
left join temp_hospitalized_mental_health_since_last_visit hospitalized_for_mental_health_since_last_visit on e.encounter_id = hospitalized_for_mental_health_since_last_visit.encounter_id
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

