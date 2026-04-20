-- Derivation script for mw_asthma_initial
-- Generated from Pentaho transform: import-into-mw-asthma-initial.ktr

drop table if exists mw_asthma_initial;
create table mw_asthma_initial (
  asthma_initial_visit_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  diagnosis_asthma 			varchar(255) default null,
  diagnosis_date_asthma 		date default null,
  diagnosis_copd 			varchar(255) default null,
  diagnosis_date_copd 			date default null,
  family_history_asthma 		varchar(255) default null,
  family_history_copd 			varchar(255) default null,
  hiv_status 				varchar(255) default null,
  hiv_test_date 			date default null,
  art_start_date 			date default null,
  tb_status 				varchar(255) default null,
  tb_year 				int default null,
  chronic_dry_cough 			varchar(255) default null,
  chronic_dry_cough_duration_in_months int default null,
  chronic_dry_cough_age_at_onset 	int default null,
  tb_contact 				varchar(255) default null,
  tb_contact_date 			date default null,
  cooking_indoor 			varchar(255) default null,
  smoking_history 			varchar(255) default null,
  last_smoking_history_date 		date default null,
  second_hand_smoking 			varchar(255) default null,
  second_hand_smoking_date 		date default null,
  occupation 				varchar(255) default null,
  occupation_exposure 			varchar(255) default null,
  occupation_exposure_date 		date default null,
  primary key (asthma_initial_visit_id)
);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_symptom_present;
create temporary table temp_symptom_present as select encounter_id, value_coded from omrs_obs where concept = 'Symptom present';
alter table temp_symptom_present add index temp_symptom_present_encounter_idx (encounter_id);

drop temporary table if exists temp_age_at_cough_onset;
create temporary table temp_age_at_cough_onset as select encounter_id, value_numeric from omrs_obs where concept = 'Age at cough onset';
alter table temp_age_at_cough_onset add index temp_age_at_cough_onset_encounter_idx (encounter_id);

drop temporary table if exists temp_duration_of_symptom_in_months;
create temporary table temp_duration_of_symptom_in_months as select encounter_id, value_numeric from omrs_obs where concept = 'Duration of symptom in months';
alter table temp_duration_of_symptom_in_months add index temp_duration_of_symptom_in_months_encounter_idx (encounter_id);

drop temporary table if exists temp_location_of_cooking;
create temporary table temp_location_of_cooking as select encounter_id, value_coded from omrs_obs where concept = 'Location of cooking';
alter table temp_location_of_cooking add index temp_location_of_cooking_encounter_idx (encounter_id);

drop temporary table if exists temp_chronic_care_diagnosis;
create temporary table temp_chronic_care_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Chronic care diagnosis';
alter table temp_chronic_care_diagnosis add index temp_chronic_care_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date from omrs_obs where concept = 'Diagnosis date';
alter table temp_diagnosis_date add index temp_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_asthma_family_history;
create temporary table temp_asthma_family_history as select encounter_id, value_coded from omrs_obs where concept = 'Asthma family history';
alter table temp_asthma_family_history add index temp_asthma_family_history_encounter_idx (encounter_id);

drop temporary table if exists temp_copd_family_history;
create temporary table temp_copd_family_history as select encounter_id, value_coded from omrs_obs where concept = 'COPD family history';
alter table temp_copd_family_history add index temp_copd_family_history_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_date;
create temporary table temp_hiv_test_date as select encounter_id, value_date from omrs_obs where concept = 'HIV test date';
alter table temp_hiv_test_date add index temp_hiv_test_date_encounter_idx (encounter_id);

drop temporary table if exists temp_exposure;
create temporary table temp_exposure as select encounter_id, value_coded from omrs_obs where concept = 'Exposure';
alter table temp_exposure add index temp_exposure_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_exposure;
create temporary table temp_date_of_exposure as select encounter_id, value_date from omrs_obs where concept = 'Date of exposure';
alter table temp_date_of_exposure add index temp_date_of_exposure_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from omrs_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

drop temporary table if exists temp_year_of_tuberculosis_diagnosis;
create temporary table temp_year_of_tuberculosis_diagnosis as select encounter_id, value_numeric from omrs_obs where concept = 'Year of Tuberculosis diagnosis';
alter table temp_year_of_tuberculosis_diagnosis add index temp_year_of_tuberculosis_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_last_time_person_used_tobacco;
create temporary table temp_last_time_person_used_tobacco as select encounter_id, value_date from omrs_obs where concept = 'Last time person used tobacco';
alter table temp_last_time_person_used_tobacco add index temp_last_time_person_used_tobacco_encounter_idx (encounter_id);

drop temporary table if exists temp_main_activity;
create temporary table temp_main_activity as select encounter_id, value_coded from omrs_obs where concept = 'Main activity';
alter table temp_main_activity add index temp_main_activity_encounter_idx (encounter_id);

drop temporary table if exists temp_smoking_history;
create temporary table temp_smoking_history as select encounter_id, value_coded from omrs_obs where concept = 'Smoking history';
alter table temp_smoking_history add index temp_smoking_history_encounter_idx (encounter_id);

insert into mw_asthma_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(case when symptom_present.value_coded = 'Dry cough' then symptom_present.value_coded end) as chronic_dry_cough,
    max(age_at_cough_onset.value_numeric) as chronic_dry_cough_age_at_onset,
    max(duration_of_symptom_in_months.value_numeric) as chronic_dry_cough_duration_in_months,
    max(case when location_of_cooking.value_coded = 'Indoors' then location_of_cooking.value_coded end) as cooking_indoor,
    max(case when chronic_care_diagnosis.value_coded = 'Asthma' then chronic_care_diagnosis.value_coded end) as diagnosis_asthma,
    max(case when chronic_care_diagnosis.value_coded = 'Chronic obstructive pulmonary disease' then chronic_care_diagnosis.value_coded end) as diagnosis_copd,
    max(diagnosis_date.value_date) as diagnosis_date_asthma,
    max(diagnosis_date.value_date) as diagnosis_date_copd,
    max(asthma_family_history.value_coded) as family_history_asthma,
    max(copd_family_history.value_coded) as family_history_copd,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(case when exposure.value_coded = 'Contact with a TB+ person' then exposure.value_coded end) as tb_contact,
    max(date_of_exposure.value_date) as tb_contact_date,
    max(tb_status.value_coded) as tb_status,
    max(year_of_tuberculosis_diagnosis.value_numeric) as tb_year,
    max(case when location_of_cooking.value_coded = 'Outdoors' then location_of_cooking.value_coded end) as cooking_indoor,
    max(last_time_person_used_tobacco.value_date) as last_smoking_history_date,
    max(main_activity.value_coded) as occupation,
    max(case when exposure.value_coded = 'Occupational exposure' then exposure.value_coded end) as occupation_exposure,
    max(date_of_exposure.value_date) as occupation_exposure_date,
    max(case when exposure.value_coded = 'Exposed to second hand smoke?' then exposure.value_coded end) as second_hand_smoking,
    max(date_of_exposure.value_date) as second_hand_smoking_date,
    max(case when smoking_history.value_coded = 'In the past' then smoking_history.value_coded end) as smoking_history
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_symptom_present symptom_present on e.encounter_id = symptom_present.encounter_id
left join temp_age_at_cough_onset age_at_cough_onset on e.encounter_id = age_at_cough_onset.encounter_id
left join temp_duration_of_symptom_in_months duration_of_symptom_in_months on e.encounter_id = duration_of_symptom_in_months.encounter_id
left join temp_location_of_cooking location_of_cooking on e.encounter_id = location_of_cooking.encounter_id
left join temp_chronic_care_diagnosis chronic_care_diagnosis on e.encounter_id = chronic_care_diagnosis.encounter_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_asthma_family_history asthma_family_history on e.encounter_id = asthma_family_history.encounter_id
left join temp_copd_family_history copd_family_history on e.encounter_id = copd_family_history.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_exposure exposure on e.encounter_id = exposure.encounter_id
left join temp_date_of_exposure date_of_exposure on e.encounter_id = date_of_exposure.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_year_of_tuberculosis_diagnosis year_of_tuberculosis_diagnosis on e.encounter_id = year_of_tuberculosis_diagnosis.encounter_id
left join temp_last_time_person_used_tobacco last_time_person_used_tobacco on e.encounter_id = last_time_person_used_tobacco.encounter_id
left join temp_main_activity main_activity on e.encounter_id = main_activity.encounter_id
left join temp_smoking_history smoking_history on e.encounter_id = smoking_history.encounter_id
where e.encounter_type in ('ASTHMA_INITIAL')
group by e.patient_id, e.encounter_date, e.location;