-- Derivation script for mw_ckd_followup
-- Generated from Pentaho transform: import-into-mw-ckd-followup.ktr

drop table if exists mw_ckd_followup;
create table mw_ckd_followup
(
    ckd_followup_visit_id         int not null auto_increment,
    patient_id                    int not null,
    visit_date                    date         default null,
    location                      varchar(255) default null,
    height                        int          default null,
    weight                        int          default null,
    bp_systolic                   int          default null,
    bp_diastolic                  int          default null,
    heart_rate                    int          default null,
    creatinine                    int          default null,
    gfr                           int          default null,
    urine_protein                 varchar(255) default null,
    confusion                     varchar(255) default null,
    fatigue                       varchar(255) default null,
    nausea                        varchar(255) default null,
    anorexia                      varchar(255) default null,
    pruritus                      varchar(255) default null,
    conjunctiva                   varchar(255) default null,
    ascites                       varchar(255) default null,
    oedema                        varchar(255) default null,
    other_symptoms                varchar(255) default null,
    ckd_stage                     varchar(255) default null,
    nsaid_use                     varchar(255) default null,
    alcohol                       varchar(255) default null,
    tobacco                       varchar(255) default null,
    diuretic_hctz                 varchar(255) default null,
    diuretic_hctz_dose            int,
    diuretic_hctz_dosing_unit     varchar(50),
    diuretic_hctz_route           varchar(50),
    diuretic_hctz_frequency       varchar(50),
    diuretic_hctz_duration        int,
    diuretic_hctz_duration_units  varchar(50),
    diuretic_furo                 varchar(255) default null,
    diuretic_furp_dose            int,
    diuretic_furp_dosing_unit     varchar(50),
    diuretic_furp_route           varchar(50),
    diuretic_furp_frequency       varchar(50),
    diuretic_furp_duration        int,
    diuretic_furp_duration_units  varchar(50),
    diuretic_spiro                varchar(255) default null,
    diuretic_spiro_dose           int,
    diuretic_spiro_dosing_unit    varchar(50),
    diuretic_spiro_route          varchar(50),
    diuretic_spiro_frequency      varchar(50),
    diuretic_spiro_duration       int,
    diuretic_spiro_duration_units varchar(50),
    ace_i_enal                    varchar(50),
    ace_i_enal_dose               int,
    ace_i_enal_dosing_unit        varchar(50),
    ace_i_enal_route              varchar(50),
    ace_i_enal_frequency          varchar(50),
    ace_i_enal_duration           int,
    ace_i_enal_duration_units     varchar(50),
    ace_i_capt                    varchar(50),
    ace_i_capt_dose               int,
    ace_i_capt_dosing_unit        varchar(50),
    ace_i_capt_route              varchar(50),
    ace_i_capt_frequency          varchar(50),
    ace_i_capt_duration           int,
    ace_i_capt_duration_units     varchar(50),
    ace_i_lisin                   varchar(50),
    ace_i_lisin_dose              int,
    ace_i_lisin_dosing_unit       varchar(50),
    ace_i_lisin_route             varchar(50),
    ace_i_lisin_frequency         varchar(50),
    ace_i_lisin_duration          int,
    ace_i_lisin_duration_units    varchar(50),
    bb_aten                       varchar(50),
    bb_aten_dose                  int,
    bb_aten_dosing_unit           varchar(50),
    bb_aten_route                 varchar(50),
    bb_aten_frequency             varchar(50),
    bb_aten_duration              int,
    bb_aten_duration_units        varchar(50),
    bb_bis                        varchar(50),
    bb_bis_dose                   int,
    bb_bis_dosing_unit            varchar(50),
    bb_bis_route                  varchar(50),
    bb_bis_frequency              varchar(50),
    bb_bis_duration               int,
    bb_bis_duration_units         varchar(50),
    bb_prop                       varchar(50),
    bb_prop_dose                  int,
    bb_prop_dosing_unit           varchar(50),
    bb_prop_route                 varchar(50),
    bb_prop_frequency             varchar(50),
    bb_prop_duration              int,
    bb_prop_duration_units        varchar(50),
    ccb_aml                       varchar(50),
    ccb_aml_dose                  int,
    ccb_aml_dosing_unit           varchar(50),
    ccb_aml_route                 varchar(50),
    ccb_aml_frequency             varchar(50),
    ccb_aml_duration              int,
    ccb_aml_duration_units        varchar(50),
    ccb_nif                       varchar(50),
    ccb_nif_dose                  int,
    ccb_nif_dosing_unit           varchar(50),
    ccb_nif_route                 varchar(50),
    ccb_nif_frequency             varchar(50),
    ccb_nif_duration              int,
    ccb_nif_duration_units        varchar(50),
    other_medications             varchar(255) default null,
    took_medications_today        varchar(255) default null,
    diet_recommendations          varchar(255) default null,
    next_appointment_date         date         default null,
    weight_change                 text,
    primary key (ckd_followup_visit_id)
);

-- Build temp_medications in three steps to avoid a full scan of the ~20M-row omrs_obs table.
-- Step 1: pull only the drug-name obs for this encounter type (~20M rows → small set).
-- Step 2: pull only the detail obs whose obs_group_id appears in step 1 (indexed lookup).
-- Step 3: join the two small tables to produce one row per drug per encounter.
drop temporary table if exists temp_drug_name_obs;
create temporary table temp_drug_name_obs as
select obs_id, encounter_id, obs_group_id, value_coded as drug_name
from omrs_obs
where concept = 'Current drugs used'
  and encounter_type = 'CKD_FOLLOWUP';
alter table temp_drug_name_obs add index temp_drug_name_obs_group_idx (obs_group_id);
alter table temp_drug_name_obs add index temp_drug_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_drug_detail_obs;
create temporary table temp_drug_detail_obs as
select obs_group_id, concept, value_coded, value_numeric
from omrs_obs
where obs_group_id in (select obs_group_id from temp_drug_name_obs)
  and concept in ('Drug frequency coded', 'Quantity of medication prescribed per dose',
                  'Dosing unit', 'Routes of administration (coded)',
                  'Medication duration', 'Time units');
alter table temp_drug_detail_obs add index temp_drug_detail_obs_group_idx (obs_group_id);

drop temporary table if exists temp_medications;
create temporary table temp_medications as
select
    t.encounter_id,
    t.drug_name,
    max(case when d.concept = 'Drug frequency coded' then d.value_coded end)                         as frequency,
    max(case when d.concept = 'Quantity of medication prescribed per dose' then d.value_numeric end) as dose,
    max(case when d.concept = 'Dosing unit' then d.value_coded end)                                  as dosing_unit,
    max(case when d.concept = 'Routes of administration (coded)' then d.value_coded end)             as route,
    max(case when d.concept = 'Medication duration' then d.value_numeric end)                        as duration,
    max(case when d.concept = 'Time units' then d.value_coded end)                                   as duration_units
from temp_drug_name_obs t
join temp_drug_detail_obs d on d.obs_group_id = t.obs_group_id
group by t.encounter_id, t.obs_group_id, t.drug_name;
alter table temp_medications add index temp_medications_encounter_idx (encounter_id);
alter table temp_medications add index temp_medications_drug_idx (drug_name);

drop temporary table if exists temp_med_hctz;
create temporary table temp_med_hctz as select * from temp_medications where drug_name = 'Hydrochlorothiazide';
alter table temp_med_hctz add index temp_med_hctz_encounter_idx (encounter_id);

drop temporary table if exists temp_med_furosemide;
create temporary table temp_med_furosemide as select * from temp_medications where drug_name = 'Furosemide';
alter table temp_med_furosemide add index temp_med_furosemide_encounter_idx (encounter_id);

drop temporary table if exists temp_med_spironolactone;
create temporary table temp_med_spironolactone as select * from temp_medications where drug_name = 'Spironolactone';
alter table temp_med_spironolactone add index temp_med_spironolactone_encounter_idx (encounter_id);

drop temporary table if exists temp_med_enalapril;
create temporary table temp_med_enalapril as select * from temp_medications where drug_name = 'Enalapril';
alter table temp_med_enalapril add index temp_med_enalapril_encounter_idx (encounter_id);

drop temporary table if exists temp_med_captopril;
create temporary table temp_med_captopril as select * from temp_medications where drug_name = 'Captopril';
alter table temp_med_captopril add index temp_med_captopril_encounter_idx (encounter_id);

drop temporary table if exists temp_med_lisinopril;
create temporary table temp_med_lisinopril as select * from temp_medications where drug_name = 'Lisinopril';
alter table temp_med_lisinopril add index temp_med_lisinopril_encounter_idx (encounter_id);

drop temporary table if exists temp_med_atenolol;
create temporary table temp_med_atenolol as select * from temp_medications where drug_name = 'Atenolol';
alter table temp_med_atenolol add index temp_med_atenolol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_bisoprolol;
create temporary table temp_med_bisoprolol as select * from temp_medications where drug_name = 'Bisoprolol';
alter table temp_med_bisoprolol add index temp_med_bisoprolol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_propranolol;
create temporary table temp_med_propranolol as select * from temp_medications where drug_name = 'Propranolol';
alter table temp_med_propranolol add index temp_med_propranolol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_amlodipine;
create temporary table temp_med_amlodipine as select * from temp_medications where drug_name = 'Amlodipine';
alter table temp_med_amlodipine add index temp_med_amlodipine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_nifedipine;
create temporary table temp_med_nifedipine as select * from temp_medications where drug_name = 'Nifedipine';
alter table temp_med_nifedipine add index temp_med_nifedipine_encounter_idx (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from omrs_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from omrs_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_anorexia;
create temporary table temp_patient_has_anorexia as select encounter_id, value_coded from omrs_obs where concept = 'Patient has anorexia';
alter table temp_patient_has_anorexia add index temp_patient_has_anorexia_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_ascites;
create temporary table temp_patient_has_ascites as select encounter_id, value_coded from omrs_obs where concept = 'Patient has ascites';
alter table temp_patient_has_ascites add index temp_patient_has_ascites_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_ckd_stage;
create temporary table temp_ckd_stage as select encounter_id, value_coded from omrs_obs where concept = 'CKD stage';
alter table temp_ckd_stage add index temp_ckd_stage_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_confused_person_or_time;
create temporary table temp_patient_confused_person_or_time as select encounter_id, value_coded from omrs_obs where concept = 'Patient confused (newly disoriented in place, person or time)';
alter table temp_patient_confused_person_or_time add index temp_patient_confused_person_or_time_encounter_idx (encounter_id);

drop temporary table if exists temp_conjunctiva;
create temporary table temp_conjunctiva as select encounter_id, value_coded from omrs_obs where concept = 'Conjunctiva';
alter table temp_conjunctiva add index temp_conjunctiva_encounter_idx (encounter_id);

drop temporary table if exists temp_creatinine;
create temporary table temp_creatinine as select encounter_id, value_numeric from omrs_obs where concept = 'Creatinine';
alter table temp_creatinine add index temp_creatinine_encounter_idx (encounter_id);

drop temporary table if exists temp_diet_recommendations;
create temporary table temp_diet_recommendations as select encounter_id, value_coded from omrs_obs where concept = 'Diet recommendations';
alter table temp_diet_recommendations add index temp_diet_recommendations_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_fatigue;
create temporary table temp_patient_has_fatigue as select encounter_id, value_coded from omrs_obs where concept = 'Patient has fatigue';
alter table temp_patient_has_fatigue add index temp_patient_has_fatigue_encounter_idx (encounter_id);

drop temporary table if exists temp_glomerular_filtration_rate;
create temporary table temp_glomerular_filtration_rate as select encounter_id, value_numeric from omrs_obs where concept = 'Glomerular filtration rate';
alter table temp_glomerular_filtration_rate add index temp_glomerular_filtration_rate_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_nausea;
create temporary table temp_patient_has_nausea as select encounter_id, value_coded from omrs_obs where concept = 'Patient has nausea';
alter table temp_patient_has_nausea add index temp_patient_has_nausea_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_nonsteroidal_anti_inflammatory_drug_use;
create temporary table temp_nonsteroidal_anti_inflammatory_drug_use as select encounter_id, value_coded from omrs_obs where concept = 'Nonsteroidal anti-inflammatory drug use';
alter table temp_nonsteroidal_anti_inflammatory_drug_use add index temp_nonsteroidal_anti_inflammatory_drug_use_2 (encounter_id);

drop temporary table if exists temp_oedema;
create temporary table temp_oedema as select encounter_id, value_coded from omrs_obs where concept = 'Oedema';
alter table temp_oedema add index temp_oedema_encounter_idx (encounter_id);

drop temporary table if exists temp_other_chronic_heart_failure_drugs;
create temporary table temp_other_chronic_heart_failure_drugs as select encounter_id, value_text from omrs_obs where concept = 'Other chronic heart failure drugs';
alter table temp_other_chronic_heart_failure_drugs add index temp_other_chronic_heart_failure_drugs_encounter (encounter_id);

drop temporary table if exists temp_review_of_symptoms_other;
create temporary table temp_review_of_symptoms_other as select encounter_id, value_text from omrs_obs where concept = 'Review of symptoms other';
alter table temp_review_of_symptoms_other add index temp_review_of_symptoms_other_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_has_pruritus;
create temporary table temp_patient_has_pruritus as select encounter_id, value_coded from omrs_obs where concept = 'Patient has pruritus';
alter table temp_patient_has_pruritus add index temp_patient_has_pruritus_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from omrs_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

drop temporary table if exists temp_took_medications_today;
create temporary table temp_took_medications_today as select encounter_id, value_coded from omrs_obs where concept = 'Took medications today';
alter table temp_took_medications_today add index temp_took_medications_today_encounter_idx (encounter_id);

drop temporary table if exists temp_urine_protein;
create temporary table temp_urine_protein as select encounter_id, value_coded from omrs_obs where concept = 'Urine protein';
alter table temp_urine_protein add index temp_urine_protein_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_change;
create temporary table temp_weight_change as select encounter_id, value_text from omrs_obs where concept = 'Weight change';
alter table temp_weight_change add index temp_weight_change_encounter_idx (encounter_id);

insert into mw_ckd_followup (patient_id, visit_date, location, ace_i_enal_dose, diuretic_furp_dose, ccb_nif_dose, diuretic_spiro_dose, ccb_aml_dose, ccb_aml_dosing_unit, ccb_aml_duration, ccb_aml_duration_units, ccb_aml_frequency, ccb_aml_route, bb_aten_dose, bb_aten_dosing_unit, bb_aten_duration, bb_aten_duration_units, bb_aten_frequency, bb_aten_route, bb_bis_dose, bb_bis_dosing_unit, bb_bis_duration, bb_bis_duration_units, bb_bis_frequency, bb_bis_route, ace_i_capt_dose, ace_i_capt_dosing_unit, ace_i_capt_duration, ace_i_capt_duration_units, ace_i_capt_frequency, ace_i_capt_route, ace_i_enal_dosing_unit, ace_i_enal_duration, ace_i_enal_duration_units, ace_i_enal_frequency, ace_i_enal_route, diuretic_furp_dosing_unit, diuretic_furp_duration, diuretic_furp_duration_units, diuretic_furp_frequency, diuretic_furp_route, diuretic_hctz_dose, diuretic_hctz_dosing_unit, diuretic_hctz_duration, diuretic_hctz_duration_units, diuretic_hctz_frequency, diuretic_hctz_route, ace_i_lisin_dose, ace_i_lisin_dosing_unit, ace_i_lisin_duration, ace_i_lisin_duration_units, ace_i_lisin_frequency, ace_i_lisin_route, ccb_nif_dosing_unit, ccb_nif_duration, ccb_nif_frequency, ccb_nif_route, ccb_nif_duration_units, bb_prop_dose, bb_prop_dosing_unit, bb_prop_duration, bb_prop_duration_units, bb_prop_frequency, bb_prop_route, diuretic_spiro_dosing_unit, diuretic_spiro_duration, diuretic_spiro_duration_units, diuretic_spiro_frequency, diuretic_spiro_route, ace_i_capt, ace_i_enal, ace_i_lisin, alcohol, anorexia, ascites, bb_aten, bb_bis, bb_prop, bp_diastolic, bp_systolic, ccb_aml, ccb_nif, ckd_stage, confusion, conjunctiva, creatinine, diet_recommendations, diuretic_furo, diuretic_hctz, diuretic_spiro, fatigue, gfr, heart_rate, height, nausea, next_appointment_date, nsaid_use, oedema, other_medications, other_symptoms, pruritus, tobacco, took_medications_today, urine_protein, weight, weight_change)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(med_enalapril.dose) as ace_i_enal_dose,
    max(med_furosemide.dose) as diuretic_furp_dose,
    max(med_nifedipine.dose) as ccb_nif_dose,
    max(med_spironolactone.dose) as diuretic_spiro_dose,
    max(med_amlodipine.dose) as ccb_aml_dose,
    max(med_amlodipine.dosing_unit) as ccb_aml_dosing_unit,
    max(med_amlodipine.duration) as ccb_aml_duration,
    max(med_amlodipine.duration_units) as ccb_aml_duration_units,
    max(med_amlodipine.frequency) as ccb_aml_frequency,
    max(med_amlodipine.route) as ccb_aml_route,
    max(med_atenolol.dose) as bb_aten_dose,
    max(med_atenolol.dosing_unit) as bb_aten_dosing_unit,
    max(med_atenolol.duration) as bb_aten_duration,
    max(med_atenolol.duration_units) as bb_aten_duration_units,
    max(med_atenolol.frequency) as bb_aten_frequency,
    max(med_atenolol.route) as bb_aten_route,
    max(med_bisoprolol.dose) as bb_bis_dose,
    max(med_bisoprolol.dosing_unit) as bb_bis_dosing_unit,
    max(med_bisoprolol.duration) as bb_bis_duration,
    max(med_bisoprolol.duration_units) as bb_bis_duration_units,
    max(med_bisoprolol.frequency) as bb_bis_frequency,
    max(med_bisoprolol.route) as bb_bis_route,
    max(med_captopril.dose) as ace_i_capt_dose,
    max(med_captopril.dosing_unit) as ace_i_capt_dosing_unit,
    max(med_captopril.duration) as ace_i_capt_duration,
    max(med_captopril.duration_units) as ace_i_capt_duration_units,
    max(med_captopril.frequency) as ace_i_capt_frequency,
    max(med_captopril.route) as ace_i_capt_route,
    max(med_enalapril.dosing_unit) as ace_i_enal_dosing_unit,
    max(med_enalapril.duration) as ace_i_enal_duration,
    max(med_enalapril.duration_units) as ace_i_enal_duration_units,
    max(med_enalapril.frequency) as ace_i_enal_frequency,
    max(med_enalapril.route) as ace_i_enal_route,
    max(med_furosemide.dosing_unit) as diuretic_furp_dosing_unit,
    max(med_furosemide.duration) as diuretic_furp_duration,
    max(med_furosemide.duration_units) as diuretic_furp_duration_units,
    max(med_furosemide.frequency) as diuretic_furp_frequency,
    max(med_furosemide.route) as diuretic_furp_route,
    max(med_hctz.dose) as diuretic_hctz_dose,
    max(med_hctz.dosing_unit) as diuretic_hctz_dosing_unit,
    max(med_hctz.duration) as diuretic_hctz_duration,
    max(med_hctz.duration_units) as diuretic_hctz_duration_units,
    max(med_hctz.frequency) as diuretic_hctz_frequency,
    max(med_hctz.route) as diuretic_hctz_route,
    max(med_lisinopril.dose) as ace_i_lisin_dose,
    max(med_lisinopril.dosing_unit) as ace_i_lisin_dosing_unit,
    max(med_lisinopril.duration) as ace_i_lisin_duration,
    max(med_lisinopril.duration_units) as ace_i_lisin_duration_units,
    max(med_lisinopril.frequency) as ace_i_lisin_frequency,
    max(med_lisinopril.route) as ace_i_lisin_route,
    max(med_nifedipine.dosing_unit) as ccb_nif_dosing_unit,
    max(med_nifedipine.duration) as ccb_nif_duration,
    max(med_nifedipine.frequency) as ccb_nif_frequency,
    max(med_nifedipine.route) as ccb_nif_route,
    max(med_nifedipine.duration_units) as ccb_nif_duration_units,
    max(med_propranolol.dose) as bb_prop_dose,
    max(med_propranolol.dosing_unit) as bb_prop_dosing_unit,
    max(med_propranolol.duration) as bb_prop_duration,
    max(med_propranolol.duration_units) as bb_prop_duration_units,
    max(med_propranolol.frequency) as bb_prop_frequency,
    max(med_propranolol.route) as bb_prop_route,
    max(med_spironolactone.dosing_unit) as diuretic_spiro_dosing_unit,
    max(med_spironolactone.duration) as diuretic_spiro_duration,
    max(med_spironolactone.duration_units) as diuretic_spiro_duration_units,
    max(med_spironolactone.frequency) as diuretic_spiro_frequency,
    max(med_spironolactone.route) as diuretic_spiro_route,
    max(case when current_drugs_used.value_coded = 'Captopril' then current_drugs_used.value_coded end) as ace_i_capt,
    max(case when current_drugs_used.value_coded = 'Enalapril' then current_drugs_used.value_coded end) as ace_i_enal,
    max(case when current_drugs_used.value_coded = 'Lisinopril' then current_drugs_used.value_coded end) as ace_i_lisin,
    max(history_of_alcohol_use.value_coded) as alcohol,
    max(patient_has_anorexia.value_coded) as anorexia,
    max(patient_has_ascites.value_coded) as ascites,
    max(case when current_drugs_used.value_coded = 'Atenolol' then current_drugs_used.value_coded end) as bb_aten,
    max(case when current_drugs_used.value_coded = 'Bisoprolol' then current_drugs_used.value_coded end) as bb_bis,
    max(case when current_drugs_used.value_coded = 'Propranolol' then current_drugs_used.value_coded end) as bb_prop,
    max(diastolic_blood_pressure.value_numeric) as bp_diastolic,
    max(systolic_blood_pressure.value_numeric) as bp_systolic,
    max(case when current_drugs_used.value_coded = 'Amlodipine' then current_drugs_used.value_coded end) as ccb_aml,
    max(case when current_drugs_used.value_coded = 'Nifedipine' then current_drugs_used.value_coded end) as ccb_nif,
    max(ckd_stage.value_coded) as ckd_stage,
    max(patient_confused_person_or_time.value_coded) as confusion,
    max(conjunctiva.value_coded) as conjunctiva,
    max(creatinine.value_numeric) as creatinine,
    max(diet_recommendations.value_coded) as diet_recommendations,
    max(case when current_drugs_used.value_coded = 'Furosemide' then current_drugs_used.value_coded end) as diuretic_furo,
    max(case when current_drugs_used.value_coded = 'Hydrochlorothiazide' then current_drugs_used.value_coded end) as diuretic_hctz,
    max(case when current_drugs_used.value_coded = 'Spironolactone' then current_drugs_used.value_coded end) as diuretic_spiro,
    max(patient_has_fatigue.value_coded) as fatigue,
    max(glomerular_filtration_rate.value_numeric) as gfr,
    max(pulse.value_numeric) as heart_rate,
    max(height_cm.value_numeric) as height,
    max(patient_has_nausea.value_coded) as nausea,
    max(appointment_date.value_date) as next_appointment_date,
    max(nonsteroidal_anti_inflammatory_drug_use.value_coded) as nsaid_use,
    max(oedema.value_coded) as oedema,
    max(other_chronic_heart_failure_drugs.value_text) as other_medications,
    max(review_of_symptoms_other.value_text) as other_symptoms,
    max(patient_has_pruritus.value_coded) as pruritus,
    max(smoking_history.value_coded) as tobacco,
    max(took_medications_today.value_coded) as took_medications_today,
    max(urine_protein.value_coded) as urine_protein,
    max(weight_kg.value_numeric) as weight,
    max(weight_change.value_text) as weight_change
from omrs_encounter e
left join temp_med_hctz med_hctz on e.encounter_id = med_hctz.encounter_id
left join temp_med_furosemide med_furosemide on e.encounter_id = med_furosemide.encounter_id
left join temp_med_spironolactone med_spironolactone on e.encounter_id = med_spironolactone.encounter_id
left join temp_med_enalapril med_enalapril on e.encounter_id = med_enalapril.encounter_id
left join temp_med_captopril med_captopril on e.encounter_id = med_captopril.encounter_id
left join temp_med_lisinopril med_lisinopril on e.encounter_id = med_lisinopril.encounter_id
left join temp_med_atenolol med_atenolol on e.encounter_id = med_atenolol.encounter_id
left join temp_med_bisoprolol med_bisoprolol on e.encounter_id = med_bisoprolol.encounter_id
left join temp_med_propranolol med_propranolol on e.encounter_id = med_propranolol.encounter_id
left join temp_med_amlodipine med_amlodipine on e.encounter_id = med_amlodipine.encounter_id
left join temp_med_nifedipine med_nifedipine on e.encounter_id = med_nifedipine.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_patient_has_anorexia patient_has_anorexia on e.encounter_id = patient_has_anorexia.encounter_id
left join temp_patient_has_ascites patient_has_ascites on e.encounter_id = patient_has_ascites.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_ckd_stage ckd_stage on e.encounter_id = ckd_stage.encounter_id
left join temp_patient_confused_person_or_time patient_confused_person_or_time on e.encounter_id = patient_confused_person_or_time.encounter_id
left join temp_conjunctiva conjunctiva on e.encounter_id = conjunctiva.encounter_id
left join temp_creatinine creatinine on e.encounter_id = creatinine.encounter_id
left join temp_diet_recommendations diet_recommendations on e.encounter_id = diet_recommendations.encounter_id
left join temp_patient_has_fatigue patient_has_fatigue on e.encounter_id = patient_has_fatigue.encounter_id
left join temp_glomerular_filtration_rate glomerular_filtration_rate on e.encounter_id = glomerular_filtration_rate.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_patient_has_nausea patient_has_nausea on e.encounter_id = patient_has_nausea.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_nonsteroidal_anti_inflammatory_drug_use nonsteroidal_anti_inflammatory_drug_use on e.encounter_id = nonsteroidal_anti_inflammatory_drug_use.encounter_id
left join temp_oedema oedema on e.encounter_id = oedema.encounter_id
left join temp_other_chronic_heart_failure_drugs other_chronic_heart_failure_drugs on e.encounter_id = other_chronic_heart_failure_drugs.encounter_id
left join temp_review_of_symptoms_other review_of_symptoms_other on e.encounter_id = review_of_symptoms_other.encounter_id
left join temp_patient_has_pruritus patient_has_pruritus on e.encounter_id = patient_has_pruritus.encounter_id
left join temp_smoking_history smoking_history on e.encounter_id = smoking_history.encounter_id
left join temp_took_medications_today took_medications_today on e.encounter_id = took_medications_today.encounter_id
left join temp_urine_protein urine_protein on e.encounter_id = urine_protein.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_weight_change weight_change on e.encounter_id = weight_change.encounter_id
where e.encounter_type in ('CKD_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;