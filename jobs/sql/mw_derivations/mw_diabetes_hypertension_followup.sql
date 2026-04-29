-- Derivation script for mw_diabetes_hypertension_followup
-- Generated from Pentaho transform: import-into-mw-diabetes-hypertension-followup.ktr

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

drop temporary table if exists temp_dh_followup_obs;
create temporary table temp_dh_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'DIABETES HYPERTENSION FOLLOWUP';
alter table temp_dh_followup_obs add index temp_dh_followup_obs_concept_idx (concept);
alter table temp_dh_followup_obs add index temp_dh_followup_obs_encounter_idx (encounter_id);
alter table temp_dh_followup_obs add index temp_dh_followup_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'History of alcohol use'                                             then value_coded   end) as alcohol,
    max(case when concept = 'Systolic blood pressure'                                            then value_numeric end) as bp_stystolic,
    max(case when concept = 'Blood sugar test type'                                              then value_coded   end) as blood_sugar_test_type,
    max(case when concept = 'Body Mass Index, coded'                                             then value_coded   end) as body_mass_index,
    max(case when concept = 'Cardiovascular risk score'                                          then value_numeric end) as cardiovascular_risk,
    max(case when concept = 'Days per week of moderate exercise'                                 then value_numeric end) as days_per_week_with_30_min_of_exercise,
    max(case when concept = 'Deformity of foot'                                                  then value_coded   end) as deformities,
    max(case when concept = 'Diastolic blood pressure'                                           then value_numeric end) as bp_diastolic,
    max(case when concept = 'Serum glucose'                                                      then value_numeric end) as fasting_blood_sugar,
    max(case when concept = 'Glycated hemoglobin'                                                then value_numeric end) as hba1c,
    max(case when concept = 'Height (cm)'                                                        then value_numeric end) as height,
    max(case when concept = 'Neuropathy and Peripheral Vascular Disease'                         then value_coded   end) as neuropathy_or_pvd,
    max(case when concept = 'Appointment date'                                                   then value_date    end) as next_appointment_date,
    max(case when concept = 'Number of servings of fruits and vegetables consumed per day'       then value_numeric end) as number_of_fruit_and_vegetable_portions,
    max(case when concept = 'Patient hospitalized since last visit'                              then value_coded   end) as hospitalized_since_last_visit,
    max(case when concept = 'Pulse'                                                              then value_numeric end) as pulse_rate,
    max(case when concept = 'Smoking history'                                                    then value_coded   end) as tobbacco,
    max(case when concept = 'Foot ulcer or infection'                                            then value_coded   end) as ulcers,
    max(case when concept = 'Visual acuity (text)'                                               then value_text    end) as visual_acuity,
    max(case when concept = 'Weight (kg)'                                                        then value_numeric end) as weight,
    max(case when value_coded = 'Amlodipine'              then value_coded end) as ccb_aml,
    max(case when value_coded = 'Aspirin'                 then value_coded end) as asprin_asa,
    max(case when value_coded = 'Atenolol'                then value_coded end) as bb_aten,
    max(case when value_coded = 'Atorvastatin'            then value_coded end) as statin_atorva,
    max(case when value_coded = 'Bisoprolol'              then value_coded end) as bb_bis,
    max(case when value_coded = 'Captopril'               then value_coded end) as ace_i_capt,
    max(case when value_coded = 'Enalapril'               then value_coded end) as ace_i_enal,
    max(case when value_coded = 'Furosemide'              then value_coded end) as diuretic_furp,
    max(case when value_coded = 'Glibenclamide'           then value_coded end) as diabetes_med_gilbenclamide,
    max(case when value_coded = 'Hydralazine'             then value_coded end) as other_hyd,
    max(case when value_coded = 'Hydrochlorothiazide'     then value_coded end) as diuretic_hctz,
    max(case when value_coded = 'Isosorbide mononitrate'  then value_coded end) as other_issmn,
    max(case when value_coded = 'Lisinopril'              then value_coded end) as ace_i_lisin,
    max(case when value_coded = 'Long acting insulin'     then value_coded end) as diabetes_med_long_acting,
    max(case when value_coded = 'Metformin'               then value_coded end) as diabetes_med_metformin,
    max(case when value_coded = 'Nifedipine'              then value_coded end) as ccb_nif,
    max(case when value_coded = 'Pravastatin'             then value_coded end) as statin_prava,
    max(case when value_coded = 'Propranolol'             then value_coded end) as bb_prop,
    max(case when value_coded = 'Insulin, soluble'        then value_coded end) as diabetes_med_short_acting,
    max(case when value_coded = 'Simvastatin'             then value_coded end) as statin_simva,
    max(case when value_coded = 'Spironolactone'          then value_coded end) as diuretic_spiro
from temp_dh_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_diabetes_hypertension_followup (
    patient_id, visit_date, location, alcohol, bp_stystolic, blood_sugar_test_type, body_mass_index, cardiovascular_risk,
    days_per_week_with_30_min_of_exercise, deformities, bp_diastolic, fasting_blood_sugar, hba1c, height, neuropathy_or_pvd,
    next_appointment_date, number_of_fruit_and_vegetable_portions, hospitalized_since_last_visit, pulse_rate, tobbacco, ulcers, visual_acuity, weight,
    ccb_aml, asprin_asa, bb_aten, statin_atorva, bb_bis, ace_i_capt, ace_i_enal, diuretic_furp, diabetes_med_gilbenclamide, other_hyd,
    diuretic_hctz, other_issmn, ace_i_lisin, diabetes_med_long_acting, diabetes_med_metformin, ccb_nif, statin_prava, bb_prop,
    diabetes_med_short_acting, statin_simva, diuretic_spiro
)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sv.alcohol) as alcohol,
    max(sv.bp_stystolic) as bp_stystolic,
    max(sv.blood_sugar_test_type) as blood_sugar_test_type,
    max(sv.body_mass_index) as body_mass_index,
    max(sv.cardiovascular_risk) as cardiovascular_risk,
    max(sv.days_per_week_with_30_min_of_exercise) as days_per_week_with_30_min_of_exercise,
    max(sv.deformities) as deformities,
    max(sv.bp_diastolic) as bp_diastolic,
    max(sv.fasting_blood_sugar) as fasting_blood_sugar,
    max(sv.hba1c) as hba1c,
    max(sv.height) as height,
    max(sv.neuropathy_or_pvd) as neuropathy_or_pvd,
    max(sv.next_appointment_date) as next_appointment_date,
    max(sv.number_of_fruit_and_vegetable_portions) as number_of_fruit_and_vegetable_portions,
    max(sv.hospitalized_since_last_visit) as hospitalized_since_last_visit,
    max(sv.pulse_rate) as pulse_rate,
    max(sv.tobbacco) as tobbacco,
    max(sv.ulcers) as ulcers,
    max(sv.visual_acuity) as visual_acuity,
    max(sv.weight) as weight,
    max(sv.ccb_aml) as ccb_aml,
    max(sv.asprin_asa) as asprin_asa,
    max(sv.bb_aten) as bb_aten,
    max(sv.statin_atorva) as statin_atorva,
    max(sv.bb_bis) as bb_bis,
    max(sv.ace_i_capt) as ace_i_capt,
    max(sv.ace_i_enal) as ace_i_enal,
    max(sv.diuretic_furp) as diuretic_furp,
    max(sv.diabetes_med_gilbenclamide) as diabetes_med_gilbenclamide,
    max(sv.other_hyd) as other_hyd,
    max(sv.diuretic_hctz) as diuretic_hctz,
    max(sv.other_issmn) as other_issmn,
    max(sv.ace_i_lisin) as ace_i_lisin,
    max(sv.diabetes_med_long_acting) as diabetes_med_long_acting,
    max(sv.diabetes_med_metformin) as diabetes_med_metformin,
    max(sv.ccb_nif) as ccb_nif,
    max(sv.statin_prava) as statin_prava,
    max(sv.bb_prop) as bb_prop,
    max(sv.diabetes_med_short_acting) as diabetes_med_short_acting,
    max(sv.statin_simva) as statin_simva,
    max(sv.diuretic_spiro) as diuretic_spiro
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('DIABETES HYPERTENSION FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_dh_followup_obs;
drop temporary table if exists temp_single_values;
