-- Derivation script for mw_asthma_followup
-- Generated from Pentaho transform: import-into-mw-asthma-followup.ktr

drop table if exists mw_asthma_followup;
create table mw_asthma_followup
(
    asthma_followup_visit_id                   int not null auto_increment,
    patient_id                                 int not null,
    visit_date                                 date         default null,
    location                                   varchar(255) default null,
    planned_visit                              varchar(255) default null,
    height                                     int          default null,
    weight                                     int          default null,
    day_symptoms                               int          default null,
    night_symptoms                             int          default null,
    inhaler_use_frequency_daily                int          default null,
    inhaler_use_frequency_weekly               int          default null,
    inhaler_use_frequency_monthly              int          default null,
    inhaler_use_frequency_yearly               int          default null,
    steroid_inhaler_daily                      varchar(255) default null,
    number_of_cigarettes_per_day               int          default null,
    passive_smoking                            varchar(255) default null,
    cooking_indoor                             varchar(255) default null,
    exacerbation_today                         varchar(255) default null,
    asthma_severity                            varchar(255) default null,
    copd                                       varchar(255) default null,
    other_diagnosis                            varchar(255) default null,
    treatment_inhaled_b_agonist                varchar(255) default null,
    treatment_inhaled_b_agonist_dose           int,
    treatment_inhaled_b_agonist_dosing_unit    varchar(50),
    treatment_inhaled_b_agonist_route          varchar(50),
    treatment_inhaled_b_agonist_frequency      varchar(50),
    treatment_inhaled_b_agonist_duration       int,
    treatment_inhaled_b_agonist_duration_units varchar(50),
    treatment_inhaled_steriod                  varchar(255) default null,
    treatment_inhaled_steriod_dose             int,
    treatment_inhaled_steriod_dosing_unit      varchar(50),
    treatment_inhaled_steriod_route            varchar(50),
    treatment_inhaled_steriod_frequency        varchar(50),
    treatment_inhaled_steriod_duration         int,
    treatment_inhaled_steriod_duration_units   varchar(50),
    treatment_oral_steroid                     varchar(255) default null,
    treatment_oral_steroid_dose                int,
    treatment_oral_steroid_dosing_unit         varchar(50),
    treatment_oral_steroid_route               varchar(50),
    treatment_oral_steroid_frequency           varchar(50),
    treatment_oral_steroid_duration            int,
    treatment_oral_steroid_duration_units      varchar(50),
    other_treatment                            varchar(255) default null,
    other_treatment_dose                       int,
    other_treatment_dosing_unit                varchar(50),
    other_treatment_route                      varchar(50),
    other_treatment_frequency                  varchar(50),
    other_treatment_duration                   int,
    other_treatment_duration_units             varchar(50),
    comments                                   varchar(255) default null,
    next_appointment_date                      date,
    primary key (asthma_followup_visit_id)
);

drop temporary table if exists temp_asthma_classification;
create temporary table temp_asthma_classification as select encounter_id, value_coded from omrs_obs where concept = 'Asthma classification';
alter table temp_asthma_classification add index temp_asthma_classification_encounter_idx (encounter_id);

drop temporary table if exists temp_location_of_cooking;
create temporary table temp_location_of_cooking as select encounter_id, value_coded from omrs_obs where concept = 'Location of cooking';
alter table temp_location_of_cooking add index temp_location_of_cooking_encounter_idx (encounter_id);

drop temporary table if exists temp_chronic_care_diagnosis;
create temporary table temp_chronic_care_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Chronic care diagnosis';
alter table temp_chronic_care_diagnosis add index temp_chronic_care_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_daytime_symptom_frequency;
create temporary table temp_daytime_symptom_frequency as select encounter_id, value_numeric from omrs_obs where concept = 'Daytime symptom frequency';
alter table temp_daytime_symptom_frequency add index temp_daytime_symptom_frequency_encounter_idx (encounter_id);

drop temporary table if exists temp_asthma_exacerbation_today;
create temporary table temp_asthma_exacerbation_today as select encounter_id, value_coded from omrs_obs where concept = 'Asthma exacerbation today';
alter table temp_asthma_exacerbation_today add index temp_asthma_exacerbation_today_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_inhaler_use_per_day;
create temporary table temp_inhaler_use_per_day as select encounter_id, value_numeric from omrs_obs where concept = 'Inhaler use per day';
alter table temp_inhaler_use_per_day add index temp_inhaler_use_per_day_encounter_idx (encounter_id);

drop temporary table if exists temp_inhaler_use_per_month;
create temporary table temp_inhaler_use_per_month as select encounter_id, value_numeric from omrs_obs where concept = 'Inhaler use per month';
alter table temp_inhaler_use_per_month add index temp_inhaler_use_per_month_encounter_idx (encounter_id);

drop temporary table if exists temp_inhaler_use_per_week;
create temporary table temp_inhaler_use_per_week as select encounter_id, value_numeric from omrs_obs where concept = 'Inhaler use per week';
alter table temp_inhaler_use_per_week add index temp_inhaler_use_per_week_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_times_inhaler_is_used_in_a_year;
create temporary table temp_number_of_times_inhaler_is_used_in_a_year as select encounter_id, value_numeric from omrs_obs where concept = 'Number of times inhaler is used in a year';
alter table temp_number_of_times_inhaler_is_used_in_a_year add index temp_number_times_inhaler_used_year_encounter_idx (encounter_id);

drop temporary table if exists temp_nighttime_symptom_frequency;
create temporary table temp_nighttime_symptom_frequency as select encounter_id, value_numeric from omrs_obs where concept = 'Nighttime symptom frequency';
alter table temp_nighttime_symptom_frequency add index temp_nighttime_symptom_frequency_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_cigarettes_smoked_per_day;
create temporary table temp_number_of_cigarettes_smoked_per_day as select encounter_id, value_numeric from omrs_obs where concept = 'Number of cigarettes smoked per day';
alter table temp_number_of_cigarettes_smoked_per_day add index temp_number_cigarettes_smoked_per_day_encounter (encounter_id);

drop temporary table if exists temp_other_diagnosis;
create temporary table temp_other_diagnosis as select encounter_id, value_text from omrs_obs where concept = 'Other diagnosis';
alter table temp_other_diagnosis add index temp_other_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_exposed_to_second_hand_smoke;
create temporary table temp_exposed_to_second_hand_smoke as select encounter_id, value_coded from omrs_obs where concept = 'Exposed to second hand smoke?';
alter table temp_exposed_to_second_hand_smoke add index temp_exposed_to_second_hand_smoke_encounter_idx (encounter_id);

drop temporary table if exists temp_scheduled_visit;
create temporary table temp_scheduled_visit as select encounter_id, value_coded from omrs_obs where concept = 'Scheduled visit';
alter table temp_scheduled_visit add index temp_scheduled_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_daily_inhaled_steroid_use;
create temporary table temp_daily_inhaled_steroid_use as select encounter_id, value_coded from omrs_obs where concept = 'Daily inhaled steroid use';
alter table temp_daily_inhaled_steroid_use add index temp_daily_inhaled_steroid_use_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

-- Each chronic lung disease treatment is recorded as a sibling obs group: the treatment name obs
-- (concept='Chronic lung disease treatment') and its detail obs (dose, frequency, route, etc.)
-- share the same obs_group_id under a parent drug-order obs group.  Joining on obs_group_id
-- ensures each treatment's details are scoped to that specific treatment, not just the encounter.
drop temporary table if exists temp_medications;
create temporary table temp_medications as
select
    t.encounter_id,
    t.value_coded                                                                             as treatment_name,
    max(case when d.concept = 'Drug frequency coded' then d.value_coded end)                 as frequency,
    max(case when d.concept = 'Quantity of medication prescribed per dose' then d.value_numeric end) as dose,
    max(case when d.concept = 'Dosing unit' then d.value_coded end)                          as dosing_unit,
    max(case when d.concept = 'Routes of administration (coded)' then d.value_coded end)     as route,
    max(case when d.concept = 'Medication duration' then d.value_numeric end)                as duration,
    max(case when d.concept = 'Time units' then d.value_coded end)                           as duration_units
from omrs_obs t
join omrs_obs d on d.obs_group_id = t.obs_group_id
where t.concept = 'Chronic lung disease treatment'
group by t.encounter_id, t.obs_group_id, t.value_coded;
alter table temp_medications add index temp_medications_encounter_idx (encounter_id);
alter table temp_medications add index temp_medications_treatment_idx (treatment_name);

-- MySQL 5.6 cannot reference the same temporary table more than once in a query,
-- so each treatment type is materialized into its own table before the final join.
drop temporary table if exists temp_b_agonist;
create temporary table temp_b_agonist as select * from temp_medications where treatment_name = 'Beta-agonists (inhaled)';
alter table temp_b_agonist add index temp_b_agonist_encounter_idx (encounter_id);

drop temporary table if exists temp_inhaled_steroid;
create temporary table temp_inhaled_steroid as select * from temp_medications where treatment_name = 'Inhaled steroid';
alter table temp_inhaled_steroid add index temp_inhaled_steroid_encounter_idx (encounter_id);

drop temporary table if exists temp_oral_steroid;
create temporary table temp_oral_steroid as select * from temp_medications where treatment_name = 'Oral steroid';
alter table temp_oral_steroid add index temp_oral_steroid_encounter_idx (encounter_id);

drop temporary table if exists temp_other_treatment;
create temporary table temp_other_treatment as select * from temp_medications where treatment_name = 'Other non-coded';
alter table temp_other_treatment add index temp_other_treatment_encounter_idx (encounter_id);

insert into mw_asthma_followup (patient_id, visit_date, location, asthma_severity, cooking_indoor, copd, day_symptoms, exacerbation_today, height, inhaler_use_frequency_daily, inhaler_use_frequency_monthly, inhaler_use_frequency_weekly, inhaler_use_frequency_yearly, night_symptoms, number_of_cigarettes_per_day, other_diagnosis, passive_smoking, planned_visit, steroid_inhaler_daily, treatment_inhaled_b_agonist, weight, comments, next_appointment_date, other_treatment, treatment_inhaled_b_agonist_frequency, treatment_inhaled_b_agonist_dose, treatment_inhaled_b_agonist_dosing_unit, treatment_inhaled_b_agonist_duration, treatment_inhaled_b_agonist_duration_units, treatment_inhaled_b_agonist_route, treatment_inhaled_steriod, treatment_inhaled_steriod_frequency, treatment_inhaled_steriod_dose, treatment_inhaled_steriod_dosing_unit, treatment_inhaled_steriod_duration, treatment_inhaled_steriod_duration_units, treatment_inhaled_steriod_route, treatment_oral_steroid, treatment_oral_steroid_frequency, treatment_oral_steroid_dose, treatment_oral_steroid_dosing_unit, treatment_oral_steroid_duration, treatment_oral_steroid_duration_units, treatment_oral_steroid_route, other_treatment_frequency, other_treatment_dose, other_treatment_dosing_unit, other_treatment_duration, other_treatment_duration_units, other_treatment_route)
select
    e.patient_id,
    date(e.encounter_date)                                                                                                   as visit_date,
    e.location,
    max(asthma_classification.value_coded)                                                                                   as asthma_severity,
    max(location_of_cooking.value_coded)                                                                                     as cooking_indoor,
    max(case when chronic_care_diagnosis.value_coded = 'Chronic obstructive pulmonary disease' then chronic_care_diagnosis.value_coded end) as copd,
    max(daytime_symptom_frequency.value_numeric)                                                                             as day_symptoms,
    max(asthma_exacerbation_today.value_coded)                                                                               as exacerbation_today,
    max(height_cm.value_numeric)                                                                                             as height,
    max(inhaler_use_per_day.value_numeric)                                                                                   as inhaler_use_frequency_daily,
    max(inhaler_use_per_month.value_numeric)                                                                                 as inhaler_use_frequency_monthly,
    max(inhaler_use_per_week.value_numeric)                                                                                  as inhaler_use_frequency_weekly,
    max(number_of_times_inhaler_is_used_in_a_year.value_numeric)                                                             as inhaler_use_frequency_yearly,
    max(nighttime_symptom_frequency.value_numeric)                                                                           as night_symptoms,
    max(number_of_cigarettes_smoked_per_day.value_numeric)                                                                   as number_of_cigarettes_per_day,
    max(other_diagnosis.value_text)                                                                                          as other_diagnosis,
    max(exposed_to_second_hand_smoke.value_coded)                                                                            as passive_smoking,
    max(scheduled_visit.value_coded)                                                                                         as planned_visit,
    max(daily_inhaled_steroid_use.value_coded)                                                                               as steroid_inhaler_daily,
    max(b_agonist.treatment_name)                                                                                            as treatment_inhaled_b_agonist,
    max(weight_kg.value_numeric)                                                                                             as weight,
    max(clinical_impression_comments.value_text)                                                                             as comments,
    max(appointment_date.value_date)                                                                                         as next_appointment_date,
    max(other_treatment.treatment_name)                                                                                      as other_treatment,
    max(b_agonist.frequency)                                                                                                 as treatment_inhaled_b_agonist_frequency,
    max(b_agonist.dose)                                                                                                      as treatment_inhaled_b_agonist_dose,
    max(b_agonist.dosing_unit)                                                                                               as treatment_inhaled_b_agonist_dosing_unit,
    max(b_agonist.duration)                                                                                                  as treatment_inhaled_b_agonist_duration,
    max(b_agonist.duration_units)                                                                                            as treatment_inhaled_b_agonist_duration_units,
    max(b_agonist.route)                                                                                                     as treatment_inhaled_b_agonist_route,
    max(inhaled_steroid.treatment_name)                                                                                      as treatment_inhaled_steriod,
    max(inhaled_steroid.frequency)                                                                                           as treatment_inhaled_steriod_frequency,
    max(inhaled_steroid.dose)                                                                                                as treatment_inhaled_steriod_dose,
    max(inhaled_steroid.dosing_unit)                                                                                         as treatment_inhaled_steriod_dosing_unit,
    max(inhaled_steroid.duration)                                                                                            as treatment_inhaled_steriod_duration,
    max(inhaled_steroid.duration_units)                                                                                      as treatment_inhaled_steriod_duration_units,
    max(inhaled_steroid.route)                                                                                               as treatment_inhaled_steriod_route,
    max(oral_steroid.treatment_name)                                                                                         as treatment_oral_steroid,
    max(oral_steroid.frequency)                                                                                              as treatment_oral_steroid_frequency,
    max(oral_steroid.dose)                                                                                                   as treatment_oral_steroid_dose,
    max(oral_steroid.dosing_unit)                                                                                            as treatment_oral_steroid_dosing_unit,
    max(oral_steroid.duration)                                                                                               as treatment_oral_steroid_duration,
    max(oral_steroid.duration_units)                                                                                         as treatment_oral_steroid_duration_units,
    max(oral_steroid.route)                                                                                                  as treatment_oral_steroid_route,
    max(other_treatment.frequency)                                                                                           as other_treatment_frequency,
    max(other_treatment.dose)                                                                                                as other_treatment_dose,
    max(other_treatment.dosing_unit)                                                                                         as other_treatment_dosing_unit,
    max(other_treatment.duration)                                                                                            as other_treatment_duration,
    max(other_treatment.duration_units)                                                                                      as other_treatment_duration_units,
    max(other_treatment.route)                                                                                               as other_treatment_route
from omrs_encounter e
left join temp_asthma_classification asthma_classification on e.encounter_id = asthma_classification.encounter_id
left join temp_location_of_cooking location_of_cooking on e.encounter_id = location_of_cooking.encounter_id
left join temp_chronic_care_diagnosis chronic_care_diagnosis on e.encounter_id = chronic_care_diagnosis.encounter_id
left join temp_daytime_symptom_frequency daytime_symptom_frequency on e.encounter_id = daytime_symptom_frequency.encounter_id
left join temp_asthma_exacerbation_today asthma_exacerbation_today on e.encounter_id = asthma_exacerbation_today.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_inhaler_use_per_day inhaler_use_per_day on e.encounter_id = inhaler_use_per_day.encounter_id
left join temp_inhaler_use_per_month inhaler_use_per_month on e.encounter_id = inhaler_use_per_month.encounter_id
left join temp_inhaler_use_per_week inhaler_use_per_week on e.encounter_id = inhaler_use_per_week.encounter_id
left join temp_number_of_times_inhaler_is_used_in_a_year number_of_times_inhaler_is_used_in_a_year on e.encounter_id = number_of_times_inhaler_is_used_in_a_year.encounter_id
left join temp_nighttime_symptom_frequency nighttime_symptom_frequency on e.encounter_id = nighttime_symptom_frequency.encounter_id
left join temp_number_of_cigarettes_smoked_per_day number_of_cigarettes_smoked_per_day on e.encounter_id = number_of_cigarettes_smoked_per_day.encounter_id
left join temp_other_diagnosis other_diagnosis on e.encounter_id = other_diagnosis.encounter_id
left join temp_exposed_to_second_hand_smoke exposed_to_second_hand_smoke on e.encounter_id = exposed_to_second_hand_smoke.encounter_id
left join temp_scheduled_visit scheduled_visit on e.encounter_id = scheduled_visit.encounter_id
left join temp_daily_inhaled_steroid_use daily_inhaled_steroid_use on e.encounter_id = daily_inhaled_steroid_use.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_b_agonist b_agonist on e.encounter_id = b_agonist.encounter_id
left join temp_inhaled_steroid inhaled_steroid on e.encounter_id = inhaled_steroid.encounter_id
left join temp_oral_steroid oral_steroid on e.encounter_id = oral_steroid.encounter_id
left join temp_other_treatment other_treatment on e.encounter_id = other_treatment.encounter_id
where e.encounter_type in ('ASTHMA_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;
