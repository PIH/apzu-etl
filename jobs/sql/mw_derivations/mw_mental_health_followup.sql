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

drop temporary table if exists temp_mh_followup_obs;
create temporary table temp_mh_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'MENTAL_HEALTH_FOLLOWUP';
alter table temp_mh_followup_obs add index temp_mh_followup_obs_concept_idx (concept);
alter table temp_mh_followup_obs add index temp_mh_followup_obs_encounter_idx (encounter_id);
alter table temp_mh_followup_obs add index temp_mh_followup_obs_group_idx (obs_group_id);

-- Build temp_medications in three steps to avoid a full scan of the ~20M-row omrs_obs table.
-- Step 1: pull only the drug-name obs for this encounter type (~20M rows → small set).
-- Step 2: pull only the detail obs whose obs_group_id appears in step 1 (indexed lookup).
-- Step 3: join the two small tables to produce one row per drug per encounter.
drop temporary table if exists temp_drug_name_obs;
create temporary table temp_drug_name_obs as
select encounter_id, obs_group_id, value_coded as drug_name
from temp_mh_followup_obs
where concept = 'Current drugs used';
alter table temp_drug_name_obs add index temp_drug_name_obs_group_idx (obs_group_id);
alter table temp_drug_name_obs add index temp_drug_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_drug_detail_obs;
create temporary table temp_drug_detail_obs as
select obs_group_id, concept, value_coded, value_numeric
from temp_mh_followup_obs
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

drop temporary table if exists temp_med_values;
create temporary table temp_med_values as
select
    encounter_id,
    max(case when drug_name = 'Carbamazepine'    then drug_name   end) as med_carbamazepine,
    max(case when drug_name = 'Carbamazepine'    then dose        end) as med_carbamazepine_dose,
    max(case when drug_name = 'Carbamazepine'    then dosing_unit end) as med_carbamazepine_dosing_unit,
    max(case when drug_name = 'Carbamazepine'    then route       end) as med_carbamazepine_route,
    max(case when drug_name = 'Carbamazepine'    then frequency   end) as med_carbamazepine_frequency,
    max(case when drug_name = 'Carbamazepine'    then duration    end) as med_carbamazepine_duration,
    max(case when drug_name = 'Carbamazepine'    then duration_units end) as med_carbamazepine_duration_units,
    max(case when drug_name = 'Chlorpromazine'   then drug_name   end) as med_chloropromazine,
    max(case when drug_name = 'Chlorpromazine'   then dose        end) as med_chloropromazine_dose,
    max(case when drug_name = 'Chlorpromazine'   then dosing_unit end) as med_chloropromazine_dosing_unit,
    max(case when drug_name = 'Chlorpromazine'   then route       end) as med_chloropromazine_route,
    max(case when drug_name = 'Chlorpromazine'   then frequency   end) as med_chloropromazine_frequency,
    max(case when drug_name = 'Chlorpromazine'   then duration    end) as med_chloropromazine_duration,
    max(case when drug_name = 'Chlorpromazine'   then duration_units end) as med_chloropromazine_duration_units,
    max(case when drug_name = 'Clopixol'         then drug_name   end) as med_clopixol,
    max(case when drug_name = 'Clopixol'         then dose        end) as med_clopixol_dose,
    max(case when drug_name = 'Clopixol'         then dosing_unit end) as med_clopixol_dosing_unit,
    max(case when drug_name = 'Clopixol'         then route       end) as med_clopixol_route,
    max(case when drug_name = 'Clopixol'         then frequency   end) as med_clopixol_frequency,
    max(case when drug_name = 'Clopixol'         then duration    end) as med_clopixol_duration,
    max(case when drug_name = 'Clopixol'         then duration_units end) as med_clopixol_duration_units,
    max(case when drug_name = 'Clozapine'        then drug_name   end) as med_clozapine,
    max(case when drug_name = 'Clozapine'        then dose        end) as med_clozapine_dose,
    max(case when drug_name = 'Clozapine'        then dosing_unit end) as med_clozapine_dosing_unit,
    max(case when drug_name = 'Clozapine'        then route       end) as med_clozapine_route,
    max(case when drug_name = 'Clozapine'        then frequency   end) as med_clozapine_frequency,
    max(case when drug_name = 'Clozapine'        then duration    end) as med_clozapine_duration,
    max(case when drug_name = 'Clozapine'        then duration_units end) as med_clozapine_duration_units,
    max(case when drug_name = 'Fluoxetine'       then drug_name   end) as med_fluoxetine,
    max(case when drug_name = 'Fluoxetine'       then dose        end) as med_fluoxetine_dose,
    max(case when drug_name = 'Fluoxetine'       then dosing_unit end) as med_fluoxetine_dosing_unit,
    max(case when drug_name = 'Fluoxetine'       then route       end) as med_fluoxetine_route,
    max(case when drug_name = 'Fluoxetine'       then frequency   end) as med_fluoxetine_frequency,
    max(case when drug_name = 'Fluoxetine'       then duration    end) as med_fluoxetine_duration,
    max(case when drug_name = 'Fluoxetine'       then duration_units end) as med_fluoxetine_duration_units,
    max(case when drug_name = 'Fluphenazine'     then drug_name   end) as med_fluphenazine,
    max(case when drug_name = 'Fluphenazine'     then dose        end) as med_fluphenazine_dose,
    max(case when drug_name = 'Fluphenazine'     then dosing_unit end) as med_fluphenazine_dosing_unit,
    max(case when drug_name = 'Fluphenazine'     then route       end) as med_fluphenazine_route,
    max(case when drug_name = 'Fluphenazine'     then frequency   end) as med_fluphenazine_frequency,
    max(case when drug_name = 'Fluphenazine'     then duration    end) as med_fluphenazine_duration,
    max(case when drug_name = 'Fluphenazine'     then duration_units end) as med_fluphenazine_duration_units,
    max(case when drug_name = 'Haloperidol'      then drug_name   end) as med_haloperidol,
    max(case when drug_name = 'Haloperidol'      then dose        end) as med_haloperidolp_dose,
    max(case when drug_name = 'Haloperidol'      then dosing_unit end) as med_haloperidol_dosing_unit,
    max(case when drug_name = 'Haloperidol'      then route       end) as med_haloperidol_route,
    max(case when drug_name = 'Haloperidol'      then frequency   end) as med_haloperidol_frequency,
    max(case when drug_name = 'Haloperidol'      then duration    end) as med_haloperidol_duration,
    max(case when drug_name = 'Haloperidol'      then duration_units end) as med_haloperidol_duration_units,
    max(case when drug_name = 'Olanzapine'       then drug_name   end) as med_olanzapine,
    max(case when drug_name = 'Olanzapine'       then dose        end) as med_olanzapine_dose,
    max(case when drug_name = 'Olanzapine'       then dosing_unit end) as med_olanzapine_dosing_unit,
    max(case when drug_name = 'Olanzapine'       then route       end) as med_olanzapine_route,
    max(case when drug_name = 'Olanzapine'       then frequency   end) as med_olanzapine_frequency,
    max(case when drug_name = 'Olanzapine'       then duration    end) as med_olanzapine_duration,
    max(case when drug_name = 'Olanzapine'       then duration_units end) as med_olanzapine_duration_units,
    max(case when drug_name = 'Risperidone'      then drug_name   end) as med_risperidone,
    max(case when drug_name = 'Risperidone'      then dose        end) as med_risperidone_dose,
    max(case when drug_name = 'Risperidone'      then dosing_unit end) as med_risperidone_dosing_unit,
    max(case when drug_name = 'Risperidone'      then route       end) as med_risperidone_route,
    max(case when drug_name = 'Risperidone'      then frequency   end) as med_risperidone_frequency,
    max(case when drug_name = 'Risperidone'      then duration    end) as med_risperidone_duration,
    max(case when drug_name = 'Risperidone'      then duration_units end) as med_risperidone_duration_units,
    max(case when drug_name = 'Sodium valproate' then drug_name   end) as med_sodium_valproate,
    max(case when drug_name = 'Sodium valproate' then dose        end) as med_sodium_valproate_dose,
    max(case when drug_name = 'Sodium valproate' then dosing_unit end) as med_sodium_valproate_dosing_unit,
    max(case when drug_name = 'Sodium valproate' then route       end) as med_sodium_valproate_route,
    max(case when drug_name = 'Sodium valproate' then frequency   end) as med_sodium_valproate_frequency,
    max(case when drug_name = 'Sodium valproate' then duration    end) as med_sodium_valproate_duration,
    max(case when drug_name = 'Sodium valproate' then duration_units end) as med_sodium_valproate_duration_units,
    max(case when drug_name = 'Trifluoperazine'  then drug_name   end) as med_trifluoperazine,
    max(case when drug_name = 'Trifluoperazine'  then dose        end) as med_trifluoperazine_dose,
    max(case when drug_name = 'Trifluoperazine'  then dosing_unit end) as med_trifluoperazine_dosing_unit,
    max(case when drug_name = 'Trifluoperazine'  then route       end) as med_trifluoperazine_route,
    max(case when drug_name = 'Trifluoperazine'  then frequency   end) as med_trifluoperazine_frequency,
    max(case when drug_name = 'Trifluoperazine'  then duration    end) as med_trifluoperazine_duration,
    max(case when drug_name = 'Trifluoperazine'  then duration_units end) as med_trifluoperazine_duration_units,
    max(case when drug_name = 'Amitriptyline'    then drug_name   end) as med_amitriptyline,
    max(case when drug_name = 'Amitriptyline'    then dose        end) as med_amitriptyline_dose,
    max(case when drug_name = 'Amitriptyline'    then dosing_unit end) as med_amitriptyline_dosing_unit,
    max(case when drug_name = 'Amitriptyline'    then route       end) as med_amitriptyline_route,
    max(case when drug_name = 'Amitriptyline'    then frequency   end) as med_amitriptyline_frequency,
    max(case when drug_name = 'Amitriptyline'    then duration    end) as med_amitriptyline_duration,
    max(case when drug_name = 'Amitriptyline'    then duration_units end) as med_amitriptyline_duration_units
from temp_medications
group by encounter_id;
alter table temp_med_values add index temp_med_values_encounter_idx (encounter_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Able to perform daily activities'                                                     then value_coded   end) as able_to_do_daily_activities,
    max(case when concept = 'History of alcohol use'                                                               then value_coded   end) as current_use_alcohol,
    max(case when concept = 'Family planning'                                                                      then value_coded   end) as on_family_planning,
    max(case when concept = 'PHQ 9 Score'                                                                          then value_numeric end) as phq_nine_score,
    max(case when concept = 'Stable'                                                                               then value_coded   end) as patient_stable,
    max(case when concept = 'Suicide risk'                                                                         then value_coded   end) as suicide_risk,
    max(case when concept = 'Clinical impression comments'                                                         then value_text    end) as comments,
    max(case when concept = 'Height (cm)'                                                                          then value_numeric end) as height,
    max(case when concept = 'Is patient pregnant?'                                                                 then value_coded   end) as pregnant,
    max(case when concept = 'Weight (kg)'                                                                          then value_numeric end) as weight,
    max(case when concept = 'Group Counselling'                                                                    then value_coded   end) as counselling_provided,
    max(case when concept = 'Hospitalized for mental health since last visit'                                      then value_coded   end) as hospitalized_since_last_visit,
    max(case when concept = 'Does patient have adverse effects'                                                    then value_coded   end) as medications_side_effects,
    max(case when concept = 'Appointment date'                                                                     then value_date    end) as next_appointment_date,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Depressive Disorder'         then value_coded   end) as mse_depressed_mood,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Abnormal speech'             then value_coded   end) as mse_disorganized_speech,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Disruptive Behavior Disorder' then value_coded  end) as mse_disruptive_behaviour,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Hypomania'                   then value_coded   end) as mse_elevated_mood,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Lack of insight'             then value_coded   end) as mse_lack_of_insight,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Delusions'                   then value_coded   end) as mse_delusions,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Hallucinations'              then value_coded   end) as mse_hallucinations,
    max(case when concept = 'Mental health chief complaint absent' and value_coded = 'Other non-coded'             then value_coded   end) as mse_other
from temp_mh_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

drop temporary table if exists temp_current_use_marijuana;
create temporary table temp_current_use_marijuana as
select o.encounter_id, o.value_coded
from temp_mh_followup_obs o
where o.obs_group_id in (
    select obs_group_id from omrs_obs_group
    where concept = 'Marijuana use construct'
      and encounter_type = 'MENTAL_HEALTH_FOLLOWUP'
);
alter table temp_current_use_marijuana add index temp_current_use_marijuana_encounter_idx (encounter_id);

drop temporary table if exists temp_current_use_other;
create temporary table temp_current_use_other as
select o.encounter_id, o.value_coded
from temp_mh_followup_obs o
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
    mv.med_carbamazepine_frequency,
    mv.med_clopixol_frequency,
    mv.med_clozapine_frequency,
    mv.med_fluphenazine_frequency,
    mv.med_haloperidol_frequency,
    mv.med_sodium_valproate_frequency,
    mv.med_sodium_valproate_route,
    mv.med_trifluoperazine_frequency,
    sv.able_to_do_daily_activities,
    mv.med_amitriptyline_dose,
    mv.med_amitriptyline_dosing_unit,
    mv.med_amitriptyline_duration,
    mv.med_amitriptyline_duration_units,
    mv.med_amitriptyline_frequency,
    mv.med_amitriptyline_route,
    mv.med_carbamazepine_dose,
    mv.med_carbamazepine_dosing_unit,
    mv.med_carbamazepine_duration,
    mv.med_carbamazepine_duration_units,
    mv.med_carbamazepine_route,
    mv.med_chloropromazine_dose,
    mv.med_chloropromazine_dosing_unit,
    mv.med_chloropromazine_duration,
    mv.med_chloropromazine_duration_units,
    mv.med_chloropromazine_frequency,
    mv.med_chloropromazine_route,
    mv.med_clopixol_dose,
    mv.med_clopixol_dosing_unit,
    mv.med_clopixol_duration,
    mv.med_clopixol_duration_units,
    mv.med_clopixol_route,
    mv.med_clozapine_dose,
    mv.med_clozapine_dosing_unit,
    mv.med_clozapine_duration,
    mv.med_clozapine_duration_units,
    mv.med_clozapine_route,
    sv.current_use_alcohol,
    mv.med_fluoxetine_dose,
    mv.med_fluoxetine_dosing_unit,
    mv.med_fluoxetine_duration,
    mv.med_fluoxetine_duration_units,
    mv.med_fluoxetine_frequency,
    mv.med_fluoxetine_route,
    mv.med_fluphenazine_dose,
    mv.med_fluphenazine_dosing_unit,
    mv.med_fluphenazine_duration,
    mv.med_fluphenazine_duration_units,
    mv.med_fluphenazine_route,
    mv.med_haloperidolp_dose,
    mv.med_haloperidol_dosing_unit,
    mv.med_haloperidol_duration,
    mv.med_haloperidol_duration_units,
    mv.med_haloperidol_route,
    sv.mse_depressed_mood,
    sv.mse_disorganized_speech,
    sv.mse_disruptive_behaviour,
    sv.mse_elevated_mood,
    sv.mse_lack_of_insight,
    sv.mse_delusions,
    sv.mse_hallucinations,
    sv.mse_other,
    mv.med_olanzapine_dose,
    mv.med_olanzapine_dosing_unit,
    mv.med_olanzapine_duration,
    mv.med_olanzapine_duration_units,
    mv.med_olanzapine_frequency,
    mv.med_olanzapine_route,
    sv.on_family_planning,
    sv.phq_nine_score,
    sv.patient_stable,
    mv.med_risperidone_dose,
    mv.med_risperidone_dosing_unit,
    mv.med_risperidone_duration,
    mv.med_risperidone_duration_units,
    mv.med_risperidone_frequency,
    mv.med_risperidone_route,
    mv.med_sodium_valproate_dose,
    mv.med_sodium_valproate_dosing_unit,
    mv.med_sodium_valproate_duration,
    mv.med_sodium_valproate_duration_units,
    sv.suicide_risk,
    mv.med_trifluoperazine_dose,
    mv.med_trifluoperazine_dosing_unit,
    mv.med_trifluoperazine_duration,
    mv.med_trifluoperazine_duration_units,
    mv.med_trifluoperazine_route,
    sv.comments,
    sv.height,
    sv.pregnant,
    sv.weight,
    sv.counselling_provided,
    sv.hospitalized_since_last_visit,
    mv.med_carbamazepine,
    mv.med_chloropromazine,
    mv.med_clopixol,
    mv.med_clozapine,
    mv.med_fluoxetine,
    mv.med_fluphenazine,
    mv.med_haloperidol,
    mv.med_olanzapine,
    mv.med_risperidone,
    mv.med_sodium_valproate,
    mv.med_trifluoperazine,
    mv.med_amitriptyline,
    max(null) as med_other,
    sv.medications_side_effects,
    sv.next_appointment_date,
    max(cum.value_coded) as current_use_marijuana,
    max(cuo.value_coded) as current_use_other
from omrs_encounter e
left join temp_med_values mv on mv.encounter_id = e.encounter_id
left join temp_single_values sv on sv.encounter_id = e.encounter_id
left join temp_current_use_marijuana cum on cum.encounter_id = e.encounter_id
left join temp_current_use_other cuo on cuo.encounter_id = e.encounter_id
where e.encounter_type in ('MENTAL_HEALTH_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_mh_followup_obs;
drop temporary table if exists temp_drug_name_obs;
drop temporary table if exists temp_drug_detail_obs;
drop temporary table if exists temp_medications;
drop temporary table if exists temp_med_values;
drop temporary table if exists temp_single_values;
drop temporary table if exists temp_current_use_marijuana;
drop temporary table if exists temp_current_use_other;
