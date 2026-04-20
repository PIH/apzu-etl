-- Derivation script for mw_diabetes_hypertension_followup
-- Generated from Pentaho transform: import-into-mw-diabetes-hypertension-followup.ktr

-- TODO: This needs to be fixed.  See all the max(null) in the select statement

drop table if exists mw_diabetes_hypertension_followup;
create table mw_diabetes_hypertension_followup
(
    followup_visit_id                      int not null auto_increment,
    patient_id                             int not null,
    visit_date                             date,
    location                               varchar(255),
    height                                 double,
    weight                                 double,
    body_mass_index                        varchar(255),
    bp_stystolic                           int,
    bp_diastolic                           int,
    pulse_rate                             int,
    hba1c                                  double,
    fasting_blood_sugar                    double,
    blood_sugar_test_type                  varchar(255),
    tobbacco                               varchar(255),
    alcohol                                varchar(255),
    number_of_fruit_and_vegetable_portions varchar(255),
    days_per_week_with_30_min_of_exercise  int,
    cardiovascular_risk                    varchar(255),
    visual_acuity                          varchar(255),
    neuropathy_or_pvd                      varchar(255),
    deformities                            varchar(255),
    ulcers                                 varchar(255),
    hospitalized_since_last_visit          varchar(255),
    diabetes_med_long_acting               varchar(255),
    diabetes_med_short_acting              varchar(255),
    diabetes_med_metformin                 varchar(255),
    diabetes_med_gilbenclamide             varchar(255),
    diuretic_hctz                          varchar(255),
    diuretic_furp                          varchar(255),
    diuretic_spiro                         varchar(255),
    ccb_aml                                varchar(255),
    ccb_nif                                varchar(255),
    ace_i_enal                             varchar(255),
    ace_i_capt                             varchar(255),
    ace_i_lisin                            varchar(255),
    bb_aten                                varchar(255),
    bb_bis                                 varchar(255),
    bb_prop                                varchar(255),
    asprin_asa                             varchar(255),
    statin_simva                           varchar(255),
    statin_prava                           varchar(255),
    statin_atorva                          varchar(255),
    other_hyd                              varchar(255),
    other_issmn                            varchar(255),
    next_appointment_date                  date,
    primary key (followup_visit_id)
);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from omrs_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_blood_sugar_test_type;
create temporary table temp_blood_sugar_test_type as select encounter_id, value_coded from omrs_obs where concept = 'Blood sugar test type';
alter table temp_blood_sugar_test_type add index temp_blood_sugar_test_type_encounter_idx (encounter_id);

drop temporary table if exists temp_body_mass_index_coded;
create temporary table temp_body_mass_index_coded as select encounter_id, value_coded from omrs_obs where concept = 'Body Mass Index, coded';
alter table temp_body_mass_index_coded add index temp_body_mass_index_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_cardiovascular_risk_score;
create temporary table temp_cardiovascular_risk_score as select encounter_id, value_numeric from omrs_obs where concept = 'Cardiovascular risk score';
alter table temp_cardiovascular_risk_score add index temp_cardiovascular_risk_score_encounter_idx (encounter_id);

drop temporary table if exists temp_days_per_week_of_moderate_exercise;
create temporary table temp_days_per_week_of_moderate_exercise as select encounter_id, value_numeric from omrs_obs where concept = 'Days per week of moderate exercise';
alter table temp_days_per_week_of_moderate_exercise add index temp_days_per_week_moderate_exercise_encounter_idx (encounter_id);

drop temporary table if exists temp_deformity_of_foot;
create temporary table temp_deformity_of_foot as select encounter_id, value_coded from omrs_obs where concept = 'Deformity of foot';
alter table temp_deformity_of_foot add index temp_deformity_of_foot_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_serum_glucose;
create temporary table temp_serum_glucose as select encounter_id, value_numeric from omrs_obs where concept = 'Serum glucose';
alter table temp_serum_glucose add index temp_serum_glucose_encounter_idx (encounter_id);

drop temporary table if exists temp_glycated_hemoglobin;
create temporary table temp_glycated_hemoglobin as select encounter_id, value_numeric from omrs_obs where concept = 'Glycated hemoglobin';
alter table temp_glycated_hemoglobin add index temp_glycated_hemoglobin_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_neuropathy_and_peripheral_vascular_disease;
create temporary table temp_neuropathy_and_peripheral_vascular_disease as select encounter_id, value_coded from omrs_obs where concept = 'Neuropathy and Peripheral Vascular Disease';
alter table temp_neuropathy_and_peripheral_vascular_disease add index temp_neuropathy_and_peripheral_vascular_disease_2 (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_number_servings_fruits_and_vegetables;
create temporary table temp_number_servings_fruits_and_vegetables as select encounter_id, value_numeric from omrs_obs where concept = 'Number of servings of fruits and vegetables consumed per day';
alter table temp_number_servings_fruits_and_vegetables add index temp_number_servings_fruits_and_vegetables_2 (encounter_id);

drop temporary table if exists temp_patient_hospitalized_since_last_visit;
create temporary table temp_patient_hospitalized_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Patient hospitalized since last visit';
alter table temp_patient_hospitalized_since_last_visit add index temp_patient_hospitalized_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from omrs_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

drop temporary table if exists temp_foot_ulcer_or_infection;
create temporary table temp_foot_ulcer_or_infection as select encounter_id, value_coded from omrs_obs where concept = 'Foot ulcer or infection';
alter table temp_foot_ulcer_or_infection add index temp_foot_ulcer_or_infection_encounter_idx (encounter_id);

drop temporary table if exists temp_visual_acuity_text;
create temporary table temp_visual_acuity_text as select encounter_id, value_text from omrs_obs where concept = 'Visual acuity (text)';
alter table temp_visual_acuity_text add index temp_visual_acuity_text_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_diabetes_hypertension_followup (patient_id, visit_date, location, alcohol, ccb_aml, asprin_asa, bb_aten, statin_atorva, bp_stystolic, bb_bis, blood_sugar_test_type, body_mass_index, ace_i_capt, cardiovascular_risk, days_per_week_with_30_min_of_exercise, deformities, bp_diastolic, ace_i_enal, fasting_blood_sugar, diuretic_furp, diabetes_med_gilbenclamide, hba1c, height, other_hyd, diuretic_hctz, other_issmn, ace_i_lisin, diabetes_med_long_acting, diabetes_med_metformin, neuropathy_or_pvd, next_appointment_date, ccb_nif, number_of_fruit_and_vegetable_portions, hospitalized_since_last_visit, statin_prava, bb_prop, pulse_rate, diabetes_med_short_acting, statin_simva, diuretic_spiro, tobbacco, ulcers, visual_acuity, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(history_of_alcohol_use.value_coded) as alcohol,
    max(null) as ccb_aml,
    max(null) as asprin_asa,
    max(null) as bb_aten,
    max(null) as statin_atorva,
    max(systolic_blood_pressure.value_numeric) as bp_stystolic,
    max(null) as bb_bis,
    max(blood_sugar_test_type.value_coded) as blood_sugar_test_type,
    max(body_mass_index_coded.value_coded) as body_mass_index,
    max(null) as ace_i_capt,
    max(cardiovascular_risk_score.value_numeric) as cardiovascular_risk,
    max(days_per_week_of_moderate_exercise.value_numeric) as days_per_week_with_30_min_of_exercise,
    max(deformity_of_foot.value_coded) as deformities,
    max(diastolic_blood_pressure.value_numeric) as bp_diastolic,
    max(null) as ace_i_enal,
    max(serum_glucose.value_numeric) as fasting_blood_sugar,
    max(null) as diuretic_furp,
    max(null) as diabetes_med_gilbenclamide,
    max(glycated_hemoglobin.value_numeric) as hba1c,
    max(height_cm.value_numeric) as height,
    max(null) as other_hyd,
    max(null) as diuretic_hctz,
    max(null) as other_issmn,
    max(null) as ace_i_lisin,
    max(null) as diabetes_med_long_acting,
    max(null) as diabetes_med_metformin,
    max(neuropathy_and_peripheral_vascular_disease.value_coded) as neuropathy_or_pvd,
    max(appointment_date.value_date) as next_appointment_date,
    max(null) as ccb_nif,
    max(number_of_servings_of_fruits_and_vegetables_consumed_per_day.value_numeric) as number_of_fruit_and_vegetable_portions,
    max(patient_hospitalized_since_last_visit.value_coded) as hospitalized_since_last_visit,
    max(null) as statin_prava,
    max(null) as bb_prop,
    max(pulse.value_numeric) as pulse_rate,
    max(null) as diabetes_med_short_acting,
    max(null) as statin_simva,
    max(null) as diuretic_spiro,
    max(smoking_history.value_coded) as tobbacco,
    max(foot_ulcer_or_infection.value_coded) as ulcers,
    max(visual_acuity_text.value_text) as visual_acuity,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_blood_sugar_test_type blood_sugar_test_type on e.encounter_id = blood_sugar_test_type.encounter_id
left join temp_body_mass_index_coded body_mass_index_coded on e.encounter_id = body_mass_index_coded.encounter_id
left join temp_cardiovascular_risk_score cardiovascular_risk_score on e.encounter_id = cardiovascular_risk_score.encounter_id
left join temp_days_per_week_of_moderate_exercise days_per_week_of_moderate_exercise on e.encounter_id = days_per_week_of_moderate_exercise.encounter_id
left join temp_deformity_of_foot deformity_of_foot on e.encounter_id = deformity_of_foot.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_serum_glucose serum_glucose on e.encounter_id = serum_glucose.encounter_id
left join temp_glycated_hemoglobin glycated_hemoglobin on e.encounter_id = glycated_hemoglobin.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_neuropathy_and_peripheral_vascular_disease neuropathy_and_peripheral_vascular_disease on e.encounter_id = neuropathy_and_peripheral_vascular_disease.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_number_servings_fruits_and_vegetables number_of_servings_of_fruits_and_vegetables_consumed_per_day on e.encounter_id = number_of_servings_of_fruits_and_vegetables_consumed_per_day.encounter_id
left join temp_patient_hospitalized_since_last_visit patient_hospitalized_since_last_visit on e.encounter_id = patient_hospitalized_since_last_visit.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_smoking_history smoking_history on e.encounter_id = smoking_history.encounter_id
left join temp_foot_ulcer_or_infection foot_ulcer_or_infection on e.encounter_id = foot_ulcer_or_infection.encounter_id
left join temp_visual_acuity_text visual_acuity_text on e.encounter_id = visual_acuity_text.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('DIABETES HYPERTENSION FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;