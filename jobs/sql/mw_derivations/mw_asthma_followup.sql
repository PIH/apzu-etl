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

drop temporary table if exists temp_asthma_followup_obs;
create temporary table temp_asthma_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'ASTHMA_FOLLOWUP';
alter table temp_asthma_followup_obs add index temp_asthma_followup_obs_concept_idx (concept);
alter table temp_asthma_followup_obs add index temp_asthma_followup_obs_encounter_idx (encounter_id);
alter table temp_asthma_followup_obs add index temp_asthma_followup_obs_group_idx (obs_group_id);

-- Build temp_medications in three steps to avoid a full scan of the ~20M-row omrs_obs table.
-- Step 1: pull only the treatment-name obs for this encounter type (~20M rows → small set).
-- Step 2: pull only the detail obs whose obs_group_id appears in step 1 (indexed lookup).
-- Step 3: join the two small tables to produce one row per treatment per encounter.
drop temporary table if exists temp_drug_name_obs;
create temporary table temp_drug_name_obs as
select obs_id, encounter_id, obs_group_id, value_coded as treatment_name
from temp_asthma_followup_obs
where concept = 'Chronic lung disease treatment';
alter table temp_drug_name_obs add index temp_drug_name_obs_group_idx (obs_group_id);
alter table temp_drug_name_obs add index temp_drug_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_drug_detail_obs;
create temporary table temp_drug_detail_obs as
select obs_group_id, concept, value_coded, value_numeric
from temp_asthma_followup_obs
where obs_group_id in (select obs_group_id from temp_drug_name_obs)
  and concept in ('Drug frequency coded', 'Quantity of medication prescribed per dose',
                  'Dosing unit', 'Routes of administration (coded)',
                  'Medication duration', 'Time units');
alter table temp_drug_detail_obs add index temp_drug_detail_obs_group_idx (obs_group_id);

drop temporary table if exists temp_medications;
create temporary table temp_medications as
select
    t.encounter_id,
    t.treatment_name,
    max(case when d.concept = 'Drug frequency coded' then d.value_coded end)                         as frequency,
    max(case when d.concept = 'Quantity of medication prescribed per dose' then d.value_numeric end) as dose,
    max(case when d.concept = 'Dosing unit' then d.value_coded end)                                  as dosing_unit,
    max(case when d.concept = 'Routes of administration (coded)' then d.value_coded end)             as route,
    max(case when d.concept = 'Medication duration' then d.value_numeric end)                        as duration,
    max(case when d.concept = 'Time units' then d.value_coded end)                                   as duration_units
from temp_drug_name_obs t
join temp_drug_detail_obs d on d.obs_group_id = t.obs_group_id
group by t.encounter_id, t.obs_group_id, t.treatment_name;
alter table temp_medications add index temp_medications_encounter_idx (encounter_id);
alter table temp_medications add index temp_medications_treatment_idx (treatment_name);

drop temporary table if exists temp_med_values;
create temporary table temp_med_values as
select
    encounter_id,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then treatment_name end) as treatment_inhaled_b_agonist,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then dose         end) as treatment_inhaled_b_agonist_dose,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then dosing_unit  end) as treatment_inhaled_b_agonist_dosing_unit,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then route        end) as treatment_inhaled_b_agonist_route,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then frequency    end) as treatment_inhaled_b_agonist_frequency,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then duration     end) as treatment_inhaled_b_agonist_duration,
    max(case when treatment_name = 'Beta-agonists (inhaled)' then duration_units end) as treatment_inhaled_b_agonist_duration_units,
    max(case when treatment_name = 'Inhaled steroid'         then treatment_name end) as treatment_inhaled_steriod,
    max(case when treatment_name = 'Inhaled steroid'         then dose         end) as treatment_inhaled_steriod_dose,
    max(case when treatment_name = 'Inhaled steroid'         then dosing_unit  end) as treatment_inhaled_steriod_dosing_unit,
    max(case when treatment_name = 'Inhaled steroid'         then route        end) as treatment_inhaled_steriod_route,
    max(case when treatment_name = 'Inhaled steroid'         then frequency    end) as treatment_inhaled_steriod_frequency,
    max(case when treatment_name = 'Inhaled steroid'         then duration     end) as treatment_inhaled_steriod_duration,
    max(case when treatment_name = 'Inhaled steroid'         then duration_units end) as treatment_inhaled_steriod_duration_units,
    max(case when treatment_name = 'Oral steroid'            then treatment_name end) as treatment_oral_steroid,
    max(case when treatment_name = 'Oral steroid'            then dose         end) as treatment_oral_steroid_dose,
    max(case when treatment_name = 'Oral steroid'            then dosing_unit  end) as treatment_oral_steroid_dosing_unit,
    max(case when treatment_name = 'Oral steroid'            then route        end) as treatment_oral_steroid_route,
    max(case when treatment_name = 'Oral steroid'            then frequency    end) as treatment_oral_steroid_frequency,
    max(case when treatment_name = 'Oral steroid'            then duration     end) as treatment_oral_steroid_duration,
    max(case when treatment_name = 'Oral steroid'            then duration_units end) as treatment_oral_steroid_duration_units,
    max(case when treatment_name = 'Other non-coded'         then treatment_name end) as other_treatment,
    max(case when treatment_name = 'Other non-coded'         then dose         end) as other_treatment_dose,
    max(case when treatment_name = 'Other non-coded'         then dosing_unit  end) as other_treatment_dosing_unit,
    max(case when treatment_name = 'Other non-coded'         then route        end) as other_treatment_route,
    max(case when treatment_name = 'Other non-coded'         then frequency    end) as other_treatment_frequency,
    max(case when treatment_name = 'Other non-coded'         then duration     end) as other_treatment_duration,
    max(case when treatment_name = 'Other non-coded'         then duration_units end) as other_treatment_duration_units
from temp_medications
group by encounter_id;
alter table temp_med_values add index temp_med_values_encounter_idx (encounter_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Asthma classification'                                                      then value_coded   end) as asthma_severity,
    max(case when concept = 'Location of cooking'                                                        then value_coded   end) as cooking_indoor,
    max(case when concept = 'Chronic care diagnosis' and value_coded = 'Chronic obstructive pulmonary disease' then value_coded end) as copd,
    max(case when concept = 'Daytime symptom frequency'                                                  then value_numeric end) as day_symptoms,
    max(case when concept = 'Asthma exacerbation today'                                                  then value_coded   end) as exacerbation_today,
    max(case when concept = 'Height (cm)'                                                                then value_numeric end) as height,
    max(case when concept = 'Inhaler use per day'                                                        then value_numeric end) as inhaler_use_frequency_daily,
    max(case when concept = 'Inhaler use per month'                                                      then value_numeric end) as inhaler_use_frequency_monthly,
    max(case when concept = 'Inhaler use per week'                                                       then value_numeric end) as inhaler_use_frequency_weekly,
    max(case when concept = 'Number of times inhaler is used in a year'                                  then value_numeric end) as inhaler_use_frequency_yearly,
    max(case when concept = 'Nighttime symptom frequency'                                                then value_numeric end) as night_symptoms,
    max(case when concept = 'Number of cigarettes smoked per day'                                        then value_numeric end) as number_of_cigarettes_per_day,
    max(case when concept = 'Other diagnosis'                                                            then value_text    end) as other_diagnosis,
    max(case when concept = 'Exposed to second hand smoke?'                                              then value_coded   end) as passive_smoking,
    max(case when concept = 'Scheduled visit'                                                            then value_coded   end) as planned_visit,
    max(case when concept = 'Daily inhaled steroid use'                                                  then value_coded   end) as steroid_inhaler_daily,
    max(case when concept = 'Weight (kg)'                                                                then value_numeric end) as weight,
    max(case when concept = 'Clinical impression comments'                                               then value_text    end) as comments,
    max(case when concept = 'Appointment date'                                                           then value_date    end) as next_appointment_date
from temp_asthma_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_asthma_followup (patient_id, visit_date, location, asthma_severity, cooking_indoor, copd, day_symptoms, exacerbation_today, height, inhaler_use_frequency_daily, inhaler_use_frequency_monthly, inhaler_use_frequency_weekly, inhaler_use_frequency_yearly, night_symptoms, number_of_cigarettes_per_day, other_diagnosis, passive_smoking, planned_visit, steroid_inhaler_daily, treatment_inhaled_b_agonist, weight, comments, next_appointment_date, other_treatment, treatment_inhaled_b_agonist_frequency, treatment_inhaled_b_agonist_dose, treatment_inhaled_b_agonist_dosing_unit, treatment_inhaled_b_agonist_duration, treatment_inhaled_b_agonist_duration_units, treatment_inhaled_b_agonist_route, treatment_inhaled_steriod, treatment_inhaled_steriod_frequency, treatment_inhaled_steriod_dose, treatment_inhaled_steriod_dosing_unit, treatment_inhaled_steriod_duration, treatment_inhaled_steriod_duration_units, treatment_inhaled_steriod_route, treatment_oral_steroid, treatment_oral_steroid_frequency, treatment_oral_steroid_dose, treatment_oral_steroid_dosing_unit, treatment_oral_steroid_duration, treatment_oral_steroid_duration_units, treatment_oral_steroid_route, other_treatment_frequency, other_treatment_dose, other_treatment_dosing_unit, other_treatment_duration, other_treatment_duration_units, other_treatment_route)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.asthma_severity,
    sv.cooking_indoor,
    sv.copd,
    sv.day_symptoms,
    sv.exacerbation_today,
    sv.height,
    sv.inhaler_use_frequency_daily,
    sv.inhaler_use_frequency_monthly,
    sv.inhaler_use_frequency_weekly,
    sv.inhaler_use_frequency_yearly,
    sv.night_symptoms,
    sv.number_of_cigarettes_per_day,
    sv.other_diagnosis,
    sv.passive_smoking,
    sv.planned_visit,
    sv.steroid_inhaler_daily,
    mv.treatment_inhaled_b_agonist,
    sv.weight,
    sv.comments,
    sv.next_appointment_date,
    mv.other_treatment,
    mv.treatment_inhaled_b_agonist_frequency,
    mv.treatment_inhaled_b_agonist_dose,
    mv.treatment_inhaled_b_agonist_dosing_unit,
    mv.treatment_inhaled_b_agonist_duration,
    mv.treatment_inhaled_b_agonist_duration_units,
    mv.treatment_inhaled_b_agonist_route,
    mv.treatment_inhaled_steriod,
    mv.treatment_inhaled_steriod_frequency,
    mv.treatment_inhaled_steriod_dose,
    mv.treatment_inhaled_steriod_dosing_unit,
    mv.treatment_inhaled_steriod_duration,
    mv.treatment_inhaled_steriod_duration_units,
    mv.treatment_inhaled_steriod_route,
    mv.treatment_oral_steroid,
    mv.treatment_oral_steroid_frequency,
    mv.treatment_oral_steroid_dose,
    mv.treatment_oral_steroid_dosing_unit,
    mv.treatment_oral_steroid_duration,
    mv.treatment_oral_steroid_duration_units,
    mv.treatment_oral_steroid_route,
    mv.other_treatment_frequency,
    mv.other_treatment_dose,
    mv.other_treatment_dosing_unit,
    mv.other_treatment_duration,
    mv.other_treatment_duration_units,
    mv.other_treatment_route
from omrs_encounter e
left join temp_med_values mv on mv.encounter_id = e.encounter_id
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('ASTHMA_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_asthma_followup_obs;
drop temporary table if exists temp_drug_name_obs;
drop temporary table if exists temp_drug_detail_obs;
drop temporary table if exists temp_medications;
drop temporary table if exists temp_med_values;
drop temporary table if exists temp_single_values;
