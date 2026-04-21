-- Derivation script for mw_mental_health_followup
-- Generated from Pentaho transform: import-into-mw-mental-health-followup.ktr

drop table if exists mw_mental_health_followup;
create table mw_mental_health_followup
(
    mental_health_followup_visit_id     int not null auto_increment,
    patient_id                          int not null,
    visit_date                          date          default null,
    location                            varchar(255)  default null,
    height                              int           default null,
    weight                              int           default null,
    phq_nine_score                      int           default null,
    mse_depressed_mood                  varchar(255)  default null,
    mse_elevated_mood                   varchar(255)  default null,
    mse_disruptive_behaviour            varchar(255)  default null,
    mse_disorganized_speech             varchar(255)  default null,
    mse_delusions                       varchar(255)  default null,
    mse_hallucinations                  varchar(255)  default null,
    mse_Lack_of_insight                 varchar(255)  default null,
    mse_other                           varchar(255)  default null,
    patient_stable                      varchar(255)  default null,
    able_to_do_daily_activities         varchar(255)  default null,
    current_use_marijuana               varchar(255)  default null,
    current_use_alcohol                 varchar(255)  default null,
    current_use_other                   varchar(255)  default null,
    pregnant                            varchar(255)  default null,
    on_family_planning                  varchar(255)  default null,
    suicide_risk                        varchar(255)  default null,
    medications_side_effects            varchar(255)  default null,
    hospitalized_since_last_visit       varchar(255)  default null,
    counselling_provided                varchar(255)  default null,
    med_chloropromazine                 varchar(255)  default null,
    med_chloropromazine_dose            int,
    med_chloropromazine_dosing_unit     varchar(50),
    med_chloropromazine_route           varchar(50),
    med_chloropromazine_frequency       varchar(50),
    med_chloropromazine_duration        int,
    med_chloropromazine_duration_units  varchar(50),
    med_haloperidol                     varchar(255)  default null,
    med_haloperidolp_dose               int,
    med_haloperidol_dosing_unit         varchar(50),
    med_haloperidol_route               varchar(50),
    med_haloperidol_frequency           varchar(50),
    med_haloperidol_duration            int,
    med_haloperidol_duration_units      varchar(50),
    med_risperidone                     varchar(255)  default null,
    med_risperidone_dose                int,
    med_risperidone_dosing_unit         varchar(50),
    med_risperidone_route               varchar(50),
    med_risperidone_frequency           varchar(50),
    med_risperidone_duration            int,
    med_risperidone_duration_units      varchar(50),
    med_fluphenazine                    varchar(255)  default null,
    med_fluphenazine_dose               int,
    med_fluphenazine_dosing_unit        varchar(50),
    med_fluphenazine_route              varchar(50),
    med_fluphenazine_frequency          varchar(50),
    med_fluphenazine_duration           int,
    med_fluphenazine_duration_units     varchar(50),
    med_carbamazepine                   varchar(255)  default null,
    med_carbamazepine_dose              int,
    med_carbamazepine_dosing_unit       varchar(50),
    med_carbamazepine_route             varchar(50),
    med_carbamazepine_frequency         varchar(50),
    med_carbamazepine_duration          int,
    med_carbamazepine_duration_units    varchar(50),
    med_sodium_valproate                varchar(255)  default null,
    med_sodium_valproate_dose           int,
    med_sodium_valproate_dosing_unit    varchar(50),
    med_sodium_valproate_route          varchar(50),
    med_sodium_valproate_frequency      varchar(50),
    med_sodium_valproate_duration       int,
    med_sodium_valproate_duration_units varchar(50),
    med_fluoxetine                      varchar(255)  default null,
    med_fluoxetine_dose                 int,
    med_fluoxetine_dosing_unit          varchar(50),
    med_fluoxetine_route                varchar(50),
    med_fluoxetine_frequency            varchar(50),
    med_fluoxetine_duration             int,
    med_fluoxetine_duration_units       varchar(50),
    med_olanzapine                      varchar(255)  default null,
    med_olanzapine_dose                 int,
    med_olanzapine_dosing_unit          varchar(50),
    med_olanzapine_route                varchar(50),
    med_olanzapine_frequency            varchar(50),
    med_olanzapine_duration             int,
    med_olanzapine_duration_units       varchar(50),
    med_clozapine                       varchar(255)  default null,
    med_clozapine_dose                  int,
    med_clozapine_dosing_unit           varchar(50),
    med_clozapine_route                 varchar(50),
    med_clozapine_frequency             varchar(50),
    med_clozapine_duration              int,
    med_clozapine_duration_units        varchar(50),
    med_trifluoperazine                 varchar(255)  default null,
    med_trifluoperazine_dose            int,
    med_trifluoperazine_dosing_unit     varchar(50),
    med_trifluoperazine_route           varchar(50),
    med_trifluoperazine_frequency       varchar(50),
    med_trifluoperazine_duration        int,
    med_trifluoperazine_duration_units  varchar(50),
    med_clopixol                        varchar(255)  default null,
    med_clopixol_dose                   int,
    med_clopixol_dosing_unit            varchar(50),
    med_clopixol_route                  varchar(50),
    med_clopixol_frequency              varchar(50),
    med_clopixol_duration               int,
    med_clopixol_duration_units         varchar(50),
    med_amitriptyline                   varchar(255)  default null,
    med_amitriptyline_dose              int,
    med_amitriptyline_dosing_unit       varchar(50),
    med_amitriptyline_route             varchar(50),
    med_amitriptyline_frequency         varchar(50),
    med_amitriptyline_duration          int,
    med_amitriptyline_duration_units    varchar(50),
    med_other                           varchar(255)  default null,
    comments                            varchar(2000) default null,
    next_appointment_date               date          default null,
    primary key (mental_health_followup_visit_id)
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
  and encounter_type = 'MENTAL_HEALTH_FOLLOWUP';
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

drop temporary table if exists temp_med_carbamazepine;
create temporary table temp_med_carbamazepine as select * from temp_medications where drug_name = 'Carbamazepine';
alter table temp_med_carbamazepine add index temp_med_carbamazepine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_chlorpromazine;
create temporary table temp_med_chlorpromazine as select * from temp_medications where drug_name = 'Chlorpromazine';
alter table temp_med_chlorpromazine add index temp_med_chlorpromazine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_clopixol;
create temporary table temp_med_clopixol as select * from temp_medications where drug_name = 'Clopixol';
alter table temp_med_clopixol add index temp_med_clopixol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_clozapine;
create temporary table temp_med_clozapine as select * from temp_medications where drug_name = 'Clozapine';
alter table temp_med_clozapine add index temp_med_clozapine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_fluoxetine;
create temporary table temp_med_fluoxetine as select * from temp_medications where drug_name = 'Fluoxetine';
alter table temp_med_fluoxetine add index temp_med_fluoxetine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_fluphenazine;
create temporary table temp_med_fluphenazine as select * from temp_medications where drug_name = 'Fluphenazine';
alter table temp_med_fluphenazine add index temp_med_fluphenazine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_haloperidol;
create temporary table temp_med_haloperidol as select * from temp_medications where drug_name = 'Haloperidol';
alter table temp_med_haloperidol add index temp_med_haloperidol_encounter_idx (encounter_id);

drop temporary table if exists temp_med_olanzapine;
create temporary table temp_med_olanzapine as select * from temp_medications where drug_name = 'Olanzapine';
alter table temp_med_olanzapine add index temp_med_olanzapine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_risperidone;
create temporary table temp_med_risperidone as select * from temp_medications where drug_name = 'Risperidone';
alter table temp_med_risperidone add index temp_med_risperidone_encounter_idx (encounter_id);

drop temporary table if exists temp_med_sodium_valproate;
create temporary table temp_med_sodium_valproate as select * from temp_medications where drug_name = 'Sodium valproate';
alter table temp_med_sodium_valproate add index temp_med_sodium_valproate_encounter_idx (encounter_id);

drop temporary table if exists temp_med_trifluoperazine;
create temporary table temp_med_trifluoperazine as select * from temp_medications where drug_name = 'Trifluoperazine';
alter table temp_med_trifluoperazine add index temp_med_trifluoperazine_encounter_idx (encounter_id);

drop temporary table if exists temp_med_amitriptyline;
create temporary table temp_med_amitriptyline as select * from temp_medications where drug_name = 'Amitriptyline';
alter table temp_med_amitriptyline add index temp_med_amitriptyline_encounter_idx (encounter_id);

drop temporary table if exists temp_able_to_perform_daily_activities;
create temporary table temp_able_to_perform_daily_activities as select encounter_id, value_coded from omrs_obs where concept = 'Able to perform daily activities';
alter table temp_able_to_perform_daily_activities add index temp_able_perform_daily_acts_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from omrs_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_mental_health_chief_complaint_absent;
create temporary table temp_mental_health_chief_complaint_absent as select encounter_id, value_coded from omrs_obs where concept = 'Mental health chief complaint absent';
alter table temp_mental_health_chief_complaint_absent add index temp_mental_health_chief_complaint_absent_2 (encounter_id);

drop temporary table if exists temp_family_planning;
create temporary table temp_family_planning as select encounter_id, value_coded from omrs_obs where concept = 'Family planning';
alter table temp_family_planning add index temp_family_planning_encounter_idx (encounter_id);

drop temporary table if exists temp_phq_9_score;
create temporary table temp_phq_9_score as select encounter_id, value_numeric from omrs_obs where concept = 'PHQ 9 Score';
alter table temp_phq_9_score add index temp_phq_9_score_encounter_idx (encounter_id);

drop temporary table if exists temp_stable;
create temporary table temp_stable as select encounter_id, value_coded from omrs_obs where concept = 'Stable';
alter table temp_stable add index temp_stable_encounter_idx (encounter_id);

drop temporary table if exists temp_suicide_risk;
create temporary table temp_suicide_risk as select encounter_id, value_coded from omrs_obs where concept = 'Suicide risk';
alter table temp_suicide_risk add index temp_suicide_risk_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_is_patient_pregnant;
create temporary table temp_is_patient_pregnant as select encounter_id, value_coded from omrs_obs where concept = 'Is patient pregnant?';
alter table temp_is_patient_pregnant add index temp_is_patient_pregnant_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_group_counselling;
create temporary table temp_group_counselling as select encounter_id, value_coded from omrs_obs where concept = 'Group Counselling';
alter table temp_group_counselling add index temp_group_counselling_encounter_idx (encounter_id);

drop temporary table if exists temp_hospitalized_mental_health_since_last_visit;
create temporary table temp_hospitalized_mental_health_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Hospitalized for mental health since last visit';
alter table temp_hospitalized_mental_health_since_last_visit add index temp_hospitalized_mental_health_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_does_patient_have_adverse_effects;
create temporary table temp_does_patient_have_adverse_effects as select encounter_id, value_coded from omrs_obs where concept = 'Does patient have adverse effects';
alter table temp_does_patient_have_adverse_effects add index temp_does_patient_adverse_effects_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_current_use_marijuana;
create temporary table temp_current_use_marijuana as
select o.encounter_id, o.value_coded
from omrs_obs o
where o.obs_group_id in (
    select obs_group_id from omrs_obs_group
    where concept = 'Marijuana use construct'
      and encounter_type = 'MENTAL_HEALTH_FOLLOWUP'
);
alter table temp_current_use_marijuana add index temp_current_use_marijuana_encounter_idx (encounter_id);

drop temporary table if exists temp_current_use_other;
create temporary table temp_current_use_other as
select o.encounter_id, o.value_coded
from omrs_obs o
where o.obs_group_id in (
    select obs_group_id from omrs_obs_group
    where concept = 'Drug use construct'
      and encounter_type = 'MENTAL_HEALTH_FOLLOWUP'
);
alter table temp_current_use_other add index temp_current_use_other_encounter_idx (encounter_id);

insert into mw_mental_health_followup (patient_id, visit_date, location, med_carbamazepine_frequency, med_clopixol_frequency, med_clozapine_frequency, med_fluphenazine_frequency, med_haloperidol_frequency, med_sodium_valproate_frequency, med_sodium_valproate_route, med_trifluoperazine_frequency, able_to_do_daily_activities, med_amitriptyline_dose, med_amitriptyline_dosing_unit, med_amitriptyline_duration, med_amitriptyline_duration_units, med_amitriptyline_frequency, med_amitriptyline_route, med_carbamazepine_dose, med_carbamazepine_dosing_unit, med_carbamazepine_duration, med_carbamazepine_duration_units, med_carbamazepine_route, med_chloropromazine_dose, med_chloropromazine_dosing_unit, med_chloropromazine_duration, med_chloropromazine_duration_units, med_chloropromazine_frequency, med_chloropromazine_route, med_clopixol_dose, med_clopixol_dosing_unit, med_clopixol_duration, med_clopixol_duration_units, med_clopixol_route, med_clozapine_dose, med_clozapine_dosing_unit, med_clozapine_duration, med_clozapine_duration_units, med_clozapine_route, current_use_alcohol, med_fluoxetine_dose, med_fluoxetine_dosing_unit, med_fluoxetine_duration, med_fluoxetine_duration_units, med_fluoxetine_frequency, med_fluoxetine_route, med_fluphenazine_dose, med_fluphenazine_dosing_unit, med_fluphenazine_duration, med_fluphenazine_duration_units, med_fluphenazine_route, med_haloperidolp_dose, med_haloperidol_dosing_unit, med_haloperidol_duration, med_haloperidol_duration_units, med_haloperidol_route, mse_depressed_mood, mse_disorganized_speech, mse_disruptive_behaviour, mse_elevated_mood, mse_lack_of_insight, mse_delusions, mse_hallucinations, mse_other, med_olanzapine_dose, med_olanzapine_dosing_unit, med_olanzapine_duration, med_olanzapine_duration_units, med_olanzapine_frequency, med_olanzapine_route, on_family_planning, phq_nine_score, patient_stable, med_risperidone_dose, med_risperidone_dosing_unit, med_risperidone_duration, med_risperidone_duration_units, med_risperidone_frequency, med_risperidone_route, med_sodium_valproate_dose, med_sodium_valproate_dosing_unit, med_sodium_valproate_duration, med_sodium_valproate_duration_units, suicide_risk, med_trifluoperazine_dose, med_trifluoperazine_dosing_unit, med_trifluoperazine_duration, med_trifluoperazine_duration_units, med_trifluoperazine_route, comments, height, pregnant, weight, counselling_provided, hospitalized_since_last_visit, med_carbamazepine, med_chloropromazine, med_clopixol, med_clozapine, med_fluoxetine, med_fluphenazine, med_haloperidol, med_olanzapine, med_risperidone, med_sodium_valproate, med_trifluoperazine, med_amitriptyline, med_other, medications_side_effects, next_appointment_date, current_use_marijuana, current_use_other)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(med_carbamazepine.frequency) as med_carbamazepine_frequency,
    max(med_clopixol.frequency) as med_clopixol_frequency,
    max(med_clozapine.frequency) as med_clozapine_frequency,
    max(med_fluphenazine.frequency) as med_fluphenazine_frequency,
    max(med_haloperidol.frequency) as med_haloperidol_frequency,
    max(med_sodium_valproate.frequency) as med_sodium_valproate_frequency,
    max(med_sodium_valproate.route) as med_sodium_valproate_route,
    max(med_trifluoperazine.frequency) as med_trifluoperazine_frequency,
    max(able_to_perform_daily_activities.value_coded) as able_to_do_daily_activities,
    max(med_amitriptyline.dose) as med_amitriptyline_dose,
    max(med_amitriptyline.dosing_unit) as med_amitriptyline_dosing_unit,
    max(med_amitriptyline.duration) as med_amitriptyline_duration,
    max(med_amitriptyline.duration_units) as med_amitriptyline_duration_units,
    max(med_amitriptyline.frequency) as med_amitriptyline_frequency,
    max(med_amitriptyline.route) as med_amitriptyline_route,
    max(med_carbamazepine.dose) as med_carbamazepine_dose,
    max(med_carbamazepine.dosing_unit) as med_carbamazepine_dosing_unit,
    max(med_carbamazepine.duration) as med_carbamazepine_duration,
    max(med_carbamazepine.duration_units) as med_carbamazepine_duration_units,
    max(med_carbamazepine.route) as med_carbamazepine_route,
    max(med_chlorpromazine.dose) as med_chloropromazine_dose,
    max(med_chlorpromazine.dosing_unit) as med_chloropromazine_dosing_unit,
    max(med_chlorpromazine.duration) as med_chloropromazine_duration,
    max(med_chlorpromazine.duration_units) as med_chloropromazine_duration_units,
    max(med_chlorpromazine.frequency) as med_chloropromazine_frequency,
    max(med_chlorpromazine.route) as med_chloropromazine_route,
    max(med_clopixol.dose) as med_clopixol_dose,
    max(med_clopixol.dosing_unit) as med_clopixol_dosing_unit,
    max(med_clopixol.duration) as med_clopixol_duration,
    max(med_clopixol.duration_units) as med_clopixol_duration_units,
    max(med_clopixol.route) as med_clopixol_route,
    max(med_clozapine.dose) as med_clozapine_dose,
    max(med_clozapine.dosing_unit) as med_clozapine_dosing_unit,
    max(med_clozapine.duration) as med_clozapine_duration,
    max(med_clozapine.duration_units) as med_clozapine_duration_units,
    max(med_clozapine.route) as med_clozapine_route,
    max(history_of_alcohol_use.value_coded) as current_use_alcohol,
    max(med_fluoxetine.dose) as med_fluoxetine_dose,
    max(med_fluoxetine.dosing_unit) as med_fluoxetine_dosing_unit,
    max(med_fluoxetine.duration) as med_fluoxetine_duration,
    max(med_fluoxetine.duration_units) as med_fluoxetine_duration_units,
    max(med_fluoxetine.frequency) as med_fluoxetine_frequency,
    max(med_fluoxetine.route) as med_fluoxetine_route,
    max(med_fluphenazine.dose) as med_fluphenazine_dose,
    max(med_fluphenazine.dosing_unit) as med_fluphenazine_dosing_unit,
    max(med_fluphenazine.duration) as med_fluphenazine_duration,
    max(med_fluphenazine.duration_units) as med_fluphenazine_duration_units,
    max(med_fluphenazine.route) as med_fluphenazine_route,
    max(med_haloperidol.dose) as med_haloperidolp_dose,
    max(med_haloperidol.dosing_unit) as med_haloperidol_dosing_unit,
    max(med_haloperidol.duration) as med_haloperidol_duration,
    max(med_haloperidol.duration_units) as med_haloperidol_duration_units,
    max(med_haloperidol.route) as med_haloperidol_route,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Depressive Disorder' then mental_health_chief_complaint_absent.value_coded end) as mse_depressed_mood,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Abnormal speech' then mental_health_chief_complaint_absent.value_coded end) as mse_disorganized_speech,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Disruptive Behavior Disorder' then mental_health_chief_complaint_absent.value_coded end) as mse_disruptive_behaviour,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Hypomania' then mental_health_chief_complaint_absent.value_coded end) as mse_elevated_mood,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Lack of insight' then mental_health_chief_complaint_absent.value_coded end) as mse_lack_of_insight,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Delusions' then mental_health_chief_complaint_absent.value_coded end) as mse_delusions,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Hallucinations' then mental_health_chief_complaint_absent.value_coded end) as mse_hallucinations,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Other non-coded' then mental_health_chief_complaint_absent.value_coded end) as mse_other,
    max(med_olanzapine.dose) as med_olanzapine_dose,
    max(med_olanzapine.dosing_unit) as med_olanzapine_dosing_unit,
    max(med_olanzapine.duration) as med_olanzapine_duration,
    max(med_olanzapine.duration_units) as med_olanzapine_duration_units,
    max(med_olanzapine.frequency) as med_olanzapine_frequency,
    max(med_olanzapine.route) as med_olanzapine_route,
    max(family_planning.value_coded) as on_family_planning,
    max(phq_9_score.value_numeric) as phq_nine_score,
    max(stable.value_coded) as patient_stable,
    max(med_risperidone.dose) as med_risperidone_dose,
    max(med_risperidone.dosing_unit) as med_risperidone_dosing_unit,
    max(med_risperidone.duration) as med_risperidone_duration,
    max(med_risperidone.duration_units) as med_risperidone_duration_units,
    max(med_risperidone.frequency) as med_risperidone_frequency,
    max(med_risperidone.route) as med_risperidone_route,
    max(med_sodium_valproate.dose) as med_sodium_valproate_dose,
    max(med_sodium_valproate.dosing_unit) as med_sodium_valproate_dosing_unit,
    max(med_sodium_valproate.duration) as med_sodium_valproate_duration,
    max(med_sodium_valproate.duration_units) as med_sodium_valproate_duration_units,
    max(suicide_risk.value_coded) as suicide_risk,
    max(med_trifluoperazine.dose) as med_trifluoperazine_dose,
    max(med_trifluoperazine.dosing_unit) as med_trifluoperazine_dosing_unit,
    max(med_trifluoperazine.duration) as med_trifluoperazine_duration,
    max(med_trifluoperazine.duration_units) as med_trifluoperazine_duration_units,
    max(med_trifluoperazine.route) as med_trifluoperazine_route,
    max(clinical_impression_comments.value_text) as comments,
    max(height_cm.value_numeric) as height,
    max(is_patient_pregnant.value_coded) as pregnant,
    max(weight_kg.value_numeric) as weight,
    max(group_counselling.value_coded) as counselling_provided,
    max(hospitalized_for_mental_health_since_last_visit.value_coded) as hospitalized_since_last_visit,
    max(med_carbamazepine.drug_name) as med_carbamazepine,
    max(med_chlorpromazine.drug_name) as med_chloropromazine,
    max(med_clopixol.drug_name) as med_clopixol,
    max(med_clozapine.drug_name) as med_clozapine,
    max(med_fluoxetine.drug_name) as med_fluoxetine,
    max(med_fluphenazine.drug_name) as med_fluphenazine,
    max(med_haloperidol.drug_name) as med_haloperidol,
    max(med_olanzapine.drug_name) as med_olanzapine,
    max(med_risperidone.drug_name) as med_risperidone,
    max(med_sodium_valproate.drug_name) as med_sodium_valproate,
    max(med_trifluoperazine.drug_name) as med_trifluoperazine,
    max(med_amitriptyline.drug_name) as med_amitriptyline,
    max(null) as med_other,
    max(does_patient_have_adverse_effects.value_coded) as medications_side_effects,
    max(appointment_date.value_date) as next_appointment_date,
    max(current_use_marijuana.value_coded) as current_use_marijuana,
    max(current_use_other.value_coded) as current_use_other
from omrs_encounter e
left join temp_med_carbamazepine med_carbamazepine on e.encounter_id = med_carbamazepine.encounter_id
left join temp_med_chlorpromazine med_chlorpromazine on e.encounter_id = med_chlorpromazine.encounter_id
left join temp_med_clopixol med_clopixol on e.encounter_id = med_clopixol.encounter_id
left join temp_med_clozapine med_clozapine on e.encounter_id = med_clozapine.encounter_id
left join temp_med_fluoxetine med_fluoxetine on e.encounter_id = med_fluoxetine.encounter_id
left join temp_med_fluphenazine med_fluphenazine on e.encounter_id = med_fluphenazine.encounter_id
left join temp_med_haloperidol med_haloperidol on e.encounter_id = med_haloperidol.encounter_id
left join temp_med_olanzapine med_olanzapine on e.encounter_id = med_olanzapine.encounter_id
left join temp_med_risperidone med_risperidone on e.encounter_id = med_risperidone.encounter_id
left join temp_med_sodium_valproate med_sodium_valproate on e.encounter_id = med_sodium_valproate.encounter_id
left join temp_med_trifluoperazine med_trifluoperazine on e.encounter_id = med_trifluoperazine.encounter_id
left join temp_med_amitriptyline med_amitriptyline on e.encounter_id = med_amitriptyline.encounter_id
left join temp_able_to_perform_daily_activities able_to_perform_daily_activities on e.encounter_id = able_to_perform_daily_activities.encounter_id
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_mental_health_chief_complaint_absent mental_health_chief_complaint_absent on e.encounter_id = mental_health_chief_complaint_absent.encounter_id
left join temp_family_planning family_planning on e.encounter_id = family_planning.encounter_id
left join temp_phq_9_score phq_9_score on e.encounter_id = phq_9_score.encounter_id
left join temp_stable stable on e.encounter_id = stable.encounter_id
left join temp_suicide_risk suicide_risk on e.encounter_id = suicide_risk.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_is_patient_pregnant is_patient_pregnant on e.encounter_id = is_patient_pregnant.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_group_counselling group_counselling on e.encounter_id = group_counselling.encounter_id
left join temp_hospitalized_mental_health_since_last_visit hospitalized_for_mental_health_since_last_visit on e.encounter_id = hospitalized_for_mental_health_since_last_visit.encounter_id
left join temp_does_patient_have_adverse_effects does_patient_have_adverse_effects on e.encounter_id = does_patient_have_adverse_effects.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_current_use_marijuana current_use_marijuana on e.encounter_id = current_use_marijuana.encounter_id
left join temp_current_use_other current_use_other on e.encounter_id = current_use_other.encounter_id
where e.encounter_type in ('MENTAL_HEALTH_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;
