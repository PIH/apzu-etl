-- Derivation script for mw_asthma_initial
-- Generated from Pentaho transform: import-into-mw-asthma-initial.ktr

drop table if exists mw_asthma_initial;
create table mw_asthma_initial
(
    asthma_initial_visit_id              int not null auto_increment,
    patient_id                           int not null,
    visit_date                           date         default null,
    location                             varchar(255) default null,
    diagnosis_asthma                     varchar(255) default null,
    diagnosis_date_asthma                date         default null,
    diagnosis_copd                       varchar(255) default null,
    diagnosis_date_copd                  date         default null,
    family_history_asthma                varchar(255) default null,
    family_history_copd                  varchar(255) default null,
    hiv_status                           varchar(255) default null,
    hiv_test_date                        date         default null,
    art_start_date                       date         default null,
    tb_status                            varchar(255) default null,
    tb_year                              int          default null,
    chronic_dry_cough                    varchar(255) default null,
    chronic_dry_cough_duration_in_months int          default null,
    chronic_dry_cough_age_at_onset       int          default null,
    tb_contact                           varchar(255) default null,
    tb_contact_date                      date         default null,
    cooking_indoor                       varchar(255) default null,
    smoking_history                      varchar(255) default null,
    last_smoking_history_date            date         default null,
    second_hand_smoking                  varchar(255) default null,
    second_hand_smoking_date             date         default null,
    occupation                           varchar(255) default null,
    occupation_exposure                  varchar(255) default null,
    occupation_exposure_date             date         default null,
    primary key (asthma_initial_visit_id)
);

drop temporary table if exists temp_asthma_initial_obs;
create temporary table temp_asthma_initial_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'ASTHMA_INITIAL';
alter table temp_asthma_initial_obs add index temp_asthma_initial_obs_concept_idx (concept);
alter table temp_asthma_initial_obs add index temp_asthma_initial_obs_encounter_idx (encounter_id);
alter table temp_asthma_initial_obs add index temp_asthma_initial_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Age at cough onset'                                                                 then value_numeric end) as chronic_dry_cough_age_at_onset,
    max(case when concept = 'Asthma family history'                                                              then value_coded   end) as family_history_asthma,
    max(case when concept = 'COPD family history'                                                                then value_coded   end) as family_history_copd,
    max(case when concept = 'Date antiretrovirals started'                                                       then value_date    end) as art_start_date,
    max(case when concept = 'Duration of symptom in months'                                                      then value_numeric end) as chronic_dry_cough_duration_in_months,
    max(case when concept = 'HIV status'                                                                         then value_coded   end) as hiv_status,
    max(case when concept = 'HIV test date'                                                                      then value_date    end) as hiv_test_date,
    max(case when concept = 'Last time person used tobacco'                                                      then value_date    end) as last_smoking_history_date,
    max(case when concept = 'Location of cooking'                                                                then value_coded   end) as cooking_indoor,
    max(case when concept = 'Main activity'                                                                      then value_coded   end) as occupation,
    max(case when concept = 'Smoking history' and value_coded = 'In the past'                                   then value_coded   end) as smoking_history,
    max(case when concept = 'Symptom present' and value_coded = 'Dry cough'                                     then value_coded   end) as chronic_dry_cough,
    max(case when concept = 'TB status'                                                                          then value_coded   end) as tb_status,
    max(case when concept = 'Year of Tuberculosis diagnosis'                                                     then value_numeric end) as tb_year
from temp_asthma_initial_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

-- "Chronic care diagnosis" coded value and the matching "Diagnosis date" share an obs_group.
-- "Exposure" coded value and the matching "Date of exposure" share an obs_group.
-- Pair them by obs_group_id so each diagnosis/exposure carries its own date.
-- (Each side is materialized into its own temp table so we don't self-join a temp table,
--  which MySQL 5.6 cannot do.)
drop temporary table if exists temp_chronic_care_diagnosis_obs;
create temporary table temp_chronic_care_diagnosis_obs as
select encounter_id, obs_group_id, value_coded
from temp_asthma_initial_obs
where concept = 'Chronic care diagnosis';
alter table temp_chronic_care_diagnosis_obs add index temp_ccd_obs_group_idx (obs_group_id);

drop temporary table if exists temp_diagnosis_date_obs;
create temporary table temp_diagnosis_date_obs as
select obs_group_id, value_date
from temp_asthma_initial_obs
where concept = 'Diagnosis date';
alter table temp_diagnosis_date_obs add index temp_dd_obs_group_idx (obs_group_id);

drop temporary table if exists temp_diagnosis_pairs;
create temporary table temp_diagnosis_pairs as
select diag.encounter_id,
       diag.value_coded as diagnosis,
       d.value_date     as diagnosis_date
from temp_chronic_care_diagnosis_obs diag
left join temp_diagnosis_date_obs d on d.obs_group_id = diag.obs_group_id;
alter table temp_diagnosis_pairs add index temp_diagnosis_pairs_encounter_idx (encounter_id);
alter table temp_diagnosis_pairs add index temp_diagnosis_pairs_diagnosis_idx (diagnosis);

drop temporary table if exists temp_exposure_obs;
create temporary table temp_exposure_obs as
select encounter_id, obs_group_id, value_coded
from temp_asthma_initial_obs
where concept = 'Exposure';
alter table temp_exposure_obs add index temp_exposure_obs_group_idx (obs_group_id);

drop temporary table if exists temp_date_of_exposure_obs;
create temporary table temp_date_of_exposure_obs as
select obs_group_id, value_date
from temp_asthma_initial_obs
where concept = 'Date of exposure';
alter table temp_date_of_exposure_obs add index temp_doe_obs_group_idx (obs_group_id);

drop temporary table if exists temp_exposure_pairs;
create temporary table temp_exposure_pairs as
select exp.encounter_id,
       exp.value_coded as exposure,
       d.value_date    as exposure_date
from temp_exposure_obs exp
left join temp_date_of_exposure_obs d on d.obs_group_id = exp.obs_group_id;
alter table temp_exposure_pairs add index temp_exposure_pairs_encounter_idx (encounter_id);
alter table temp_exposure_pairs add index temp_exposure_pairs_exposure_idx (exposure);

insert into mw_asthma_initial (patient_id, visit_date, location, art_start_date, chronic_dry_cough, chronic_dry_cough_age_at_onset, chronic_dry_cough_duration_in_months, cooking_indoor, diagnosis_asthma, diagnosis_copd, diagnosis_date_asthma, diagnosis_date_copd, family_history_asthma, family_history_copd, hiv_status, hiv_test_date, tb_contact, tb_contact_date, tb_status, tb_year, last_smoking_history_date, occupation, occupation_exposure, occupation_exposure_date, second_hand_smoking, second_hand_smoking_date, smoking_history)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sv.art_start_date) as art_start_date,
    max(sv.chronic_dry_cough) as chronic_dry_cough,
    max(sv.chronic_dry_cough_age_at_onset) as chronic_dry_cough_age_at_onset,
    max(sv.chronic_dry_cough_duration_in_months) as chronic_dry_cough_duration_in_months,
    max(sv.cooking_indoor) as cooking_indoor,
    max(case when dp.diagnosis = 'Asthma'                               then dp.diagnosis      end) as diagnosis_asthma,
    max(case when dp.diagnosis = 'Chronic obstructive pulmonary disease' then dp.diagnosis      end) as diagnosis_copd,
    max(case when dp.diagnosis = 'Asthma'                               then dp.diagnosis_date end) as diagnosis_date_asthma,
    max(case when dp.diagnosis = 'Chronic obstructive pulmonary disease' then dp.diagnosis_date end) as diagnosis_date_copd,
    max(sv.family_history_asthma) as family_history_asthma,
    max(sv.family_history_copd) as family_history_copd,
    max(sv.hiv_status) as hiv_status,
    max(sv.hiv_test_date) as hiv_test_date,
    max(case when ep.exposure = 'Contact with a TB+ person'             then ep.exposure       end) as tb_contact,
    max(case when ep.exposure = 'Contact with a TB+ person'             then ep.exposure_date  end) as tb_contact_date,
    max(sv.tb_status) as tb_status,
    max(sv.tb_year) as tb_year,
    max(sv.last_smoking_history_date) as last_smoking_history_date,
    max(sv.occupation) as occupation,
    max(case when ep.exposure = 'Occupational exposure'                 then ep.exposure       end) as occupation_exposure,
    max(case when ep.exposure = 'Occupational exposure'                 then ep.exposure_date  end) as occupation_exposure_date,
    max(case when ep.exposure = 'Exposed to second hand smoke?'         then ep.exposure       end) as second_hand_smoking,
    max(case when ep.exposure = 'Exposed to second hand smoke?'         then ep.exposure_date  end) as second_hand_smoking_date,
    max(sv.smoking_history) as smoking_history
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
left join temp_diagnosis_pairs dp on dp.encounter_id = e.encounter_id
left join temp_exposure_pairs ep on ep.encounter_id = e.encounter_id
where e.encounter_type in ('ASTHMA_INITIAL')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_asthma_initial_obs;
drop temporary table if exists temp_single_values;
drop temporary table if exists temp_chronic_care_diagnosis_obs;
drop temporary table if exists temp_diagnosis_date_obs;
drop temporary table if exists temp_diagnosis_pairs;
drop temporary table if exists temp_exposure_obs;
drop temporary table if exists temp_date_of_exposure_obs;
drop temporary table if exists temp_exposure_pairs;
