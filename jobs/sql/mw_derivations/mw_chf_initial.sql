-- Derivation script for mw_chf_initial
-- Generated from Pentaho transform: import-into-mw-chf-initial.ktr

drop table if exists mw_chf_initial;
create table mw_chf_initial (
  chf_initial_visit_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  diagnosis_dilated 			varchar(255) default null,
  diagnosis_date_dilated 		date default null,
  diagnosis_restricitive 		varchar(255) default null,
  diagnosis_date_restricitive 	date default null,
  diagnosis_valvular 			varchar(255) default null,
  diagnosis_date_valvular 		date default null,
  diagnosis_right_ventricular_failure 	varchar(255) default null,
  diagnosis_date_right_ventricular_failure date default null,
  diagnosis_unknown 			varchar(255) default null,
  diagnosis_date_unknown 		date default null,
  diagnosis_rheumatic 			varchar(255) default null,
  diagnosis_date_rheumatic 		date default null,
  diagnosis_congenital 		varchar(255) default null,
  diagnosis_date_congenital 		date default null,
  diagnosis_cad 			varchar(255) default null,
  diagnosis_date_cad 			date default null,
  diagnosis_stroke 			varchar(255) default null,
  diagnosis_date_stroke 		date default null,
  diagnosis_afib 			varchar(255) default null,
  diagnosis_date_afib 			date default null,
  diagnosis_pe 			varchar(255) default null,
  diagnosis_date_pe 			date default null,
  diagnosis_dvt 			varchar(255) default null,
  diagnosis_date_dvt			date default null,
  diagnosis_other 			varchar(255) default null,
  diagnosis_date_other 		date default null,
  hiv_status 				varchar(255) default null,
  hiv_test_date 			date default null,
  art_start_date 			date default null,
  tb_status 				varchar(255) default null,
  tb_year 				int default null,
  comorbidities_hypertension 		varchar(255) default null,
  comorbidities_diabetes 		varchar(255) default null,
  comorbidities_chronic_kidney_disease varchar(255) default null,
  comorbidities_other 			varchar(255) default null,
  echo_test_result 			varchar(255) default null,
  echo_test_date 			date default null,
  ecg_test_result 			varchar(255) default null,
  ecg_test_date 			date default null,
  primary key (chf_initial_visit_id)
);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_current_oi_or_comorbidity_confirmed_or;
create temporary table temp_current_oi_or_comorbidity_confirmed_or as select encounter_id, value_coded from omrs_obs where concept = 'Current opportunistic infection or comorbidity, confirmed or presumed';
alter table temp_current_oi_or_comorbidity_confirmed_or add index temp_current_oi_or_comorbidity_confirmed_or_2 (encounter_id);

drop temporary table if exists temp_other_diagnosis;
create temporary table temp_other_diagnosis as select encounter_id, value_text from omrs_obs where concept = 'Other diagnosis';
alter table temp_other_diagnosis add index temp_other_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_chronic_care_diagnosis;
create temporary table temp_chronic_care_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Chronic care diagnosis';
alter table temp_chronic_care_diagnosis add index temp_chronic_care_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date, value_numeric from omrs_obs where concept = 'Diagnosis date';
alter table temp_diagnosis_date add index temp_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_general_test;
create temporary table temp_date_of_general_test as select encounter_id, value_date from omrs_obs where concept = 'Date of general test';
alter table temp_date_of_general_test add index temp_date_of_general_test_encounter_idx (encounter_id);

drop temporary table if exists temp_electrocardiogram_diagnosis;
create temporary table temp_electrocardiogram_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Electrocardiogram diagnosis';
alter table temp_electrocardiogram_diagnosis add index temp_electrocardiogram_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_echo_imaging_result;
create temporary table temp_echo_imaging_result as select encounter_id, value_text from omrs_obs where concept = 'ECHO imaging result';
alter table temp_echo_imaging_result add index temp_echo_imaging_result_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_date;
create temporary table temp_hiv_test_date as select encounter_id, value_date from omrs_obs where concept = 'HIV test date';
alter table temp_hiv_test_date add index temp_hiv_test_date_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from omrs_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

drop temporary table if exists temp_year_of_tuberculosis_diagnosis;
create temporary table temp_year_of_tuberculosis_diagnosis as select encounter_id, value_numeric from omrs_obs where concept = 'Year of Tuberculosis diagnosis';
alter table temp_year_of_tuberculosis_diagnosis add index temp_year_of_tuberculosis_diagnosis_encounter_idx (encounter_id);

insert into mw_chf_initial (patient_id, visit_date, location, art_start_date, comorbidities_chronic_kidney_disease, comorbidities_diabetes, comorbidities_hypertension, comorbidities_other, diagnosis_afib, diagnosis_cad, diagnosis_congenital, diagnosis_date_rheumatic, diagnosis_date_afib, diagnosis_date_cad, diagnosis_date_congenital, diagnosis_date_dilated, diagnosis_date_dvt, diagnosis_date_other, diagnosis_date_pe, diagnosis_date_restricitive, diagnosis_date_stroke, diagnosis_date_unknown, diagnosis_date_valvular, diagnosis_dilated, diagnosis_dvt, diagnosis_other, diagnosis_pe, diagnosis_restricitive, diagnosis_rheumatic, diagnosis_stroke, diagnosis_unknown, diagnosis_valvular, ecg_test_date, ecg_test_result, echo_test_date, echo_test_result, hiv_status, hiv_test_date, tb_status, tb_year, diagnosis_date_right_ventricular_failure, diagnosis_right_ventricular_failure)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(case when current_oi_or_comorbidity_confirmed_or_presumed.value_coded = 'Chronic kidney disease' then current_oi_or_comorbidity_confirmed_or_presumed.value_coded end) as comorbidities_chronic_kidney_disease,
    max(case when current_oi_or_comorbidity_confirmed_or_presumed.value_coded = 'Diabetes' then current_oi_or_comorbidity_confirmed_or_presumed.value_coded end) as comorbidities_diabetes,
    max(case when current_oi_or_comorbidity_confirmed_or_presumed.value_coded = 'Hypertension' then current_oi_or_comorbidity_confirmed_or_presumed.value_coded end) as comorbidities_hypertension,
    max(other_diagnosis.value_text) as comorbidities_other,
    max(case when chronic_care_diagnosis.value_coded = 'Irregular rhythm' then chronic_care_diagnosis.value_coded end) as diagnosis_afib,
    max(case when chronic_care_diagnosis.value_coded = 'Coronary artery disease' then chronic_care_diagnosis.value_coded end) as diagnosis_cad,
    max(case when chronic_care_diagnosis.value_coded = 'Congenital heart disease' then chronic_care_diagnosis.value_coded end) as diagnosis_congenital,
    max(diagnosis_date.value_date) as diagnosis_date_rheumatic,
    max(diagnosis_date.value_date) as diagnosis_date_afib,
    max(diagnosis_date.value_date) as diagnosis_date_cad,
    max(diagnosis_date.value_date) as diagnosis_date_congenital,
    max(diagnosis_date.value_date) as diagnosis_date_dilated,
    max(diagnosis_date.value_date) as diagnosis_date_dvt,
    max(diagnosis_date.value_date) as diagnosis_date_other,
    max(diagnosis_date.value_date) as diagnosis_date_pe,
    max(diagnosis_date.value_numeric) as diagnosis_date_restricitive,
    max(diagnosis_date.value_date) as diagnosis_date_stroke,
    max(diagnosis_date.value_date) as diagnosis_date_unknown,
    max(diagnosis_date.value_numeric) as diagnosis_date_valvular,
    max(case when chronic_care_diagnosis.value_coded = 'Dilated cardiomyopathy' then chronic_care_diagnosis.value_coded end) as diagnosis_dilated,
    max(case when chronic_care_diagnosis.value_coded = 'Deep vein thrombosis' then chronic_care_diagnosis.value_coded end) as diagnosis_dvt,
    max(chronic_care_diagnosis.value_coded) as diagnosis_other,
    max(case when chronic_care_diagnosis.value_coded = 'Pulmonary embolism' then chronic_care_diagnosis.value_coded end) as diagnosis_pe,
    max(case when chronic_care_diagnosis.value_coded = 'Restrictive cardiomyopathy' then chronic_care_diagnosis.value_coded end) as diagnosis_restricitive,
    max(case when chronic_care_diagnosis.value_coded = 'Rheumatic heart disease' then chronic_care_diagnosis.value_coded end) as diagnosis_rheumatic,
    max(case when chronic_care_diagnosis.value_coded = 'Acute cerebrovascular attack' then chronic_care_diagnosis.value_coded end) as diagnosis_stroke,
    max(case when chronic_care_diagnosis.value_coded = 'Unknown' then chronic_care_diagnosis.value_coded end) as diagnosis_unknown,
    max(case when chronic_care_diagnosis.value_coded = 'Valvular heart disease' then chronic_care_diagnosis.value_coded end) as diagnosis_valvular,
    max(date_of_general_test.value_date) as ecg_test_date,
    max(electrocardiogram_diagnosis.value_coded) as ecg_test_result,
    max(date_of_general_test.value_date) as echo_test_date,
    max(echo_imaging_result.value_text) as echo_test_result,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(tb_status.value_coded) as tb_status,
    max(year_of_tuberculosis_diagnosis.value_numeric) as tb_year,
    max(diagnosis_date.value_numeric) as diagnosis_date_right_ventricular_failure,
    max(case when chronic_care_diagnosis.value_coded = 'Right ventricular failure' then chronic_care_diagnosis.value_coded end) as diagnosis_right_ventricular_failure
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_current_oi_or_comorbidity_confirmed_or current_oi_or_comorbidity_confirmed_or_presumed on e.encounter_id = current_oi_or_comorbidity_confirmed_or_presumed.encounter_id
left join temp_other_diagnosis other_diagnosis on e.encounter_id = other_diagnosis.encounter_id
left join temp_chronic_care_diagnosis chronic_care_diagnosis on e.encounter_id = chronic_care_diagnosis.encounter_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_date_of_general_test date_of_general_test on e.encounter_id = date_of_general_test.encounter_id
left join temp_electrocardiogram_diagnosis electrocardiogram_diagnosis on e.encounter_id = electrocardiogram_diagnosis.encounter_id
left join temp_echo_imaging_result echo_imaging_result on e.encounter_id = echo_imaging_result.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_year_of_tuberculosis_diagnosis year_of_tuberculosis_diagnosis on e.encounter_id = year_of_tuberculosis_diagnosis.encounter_id
where e.encounter_type in ('CHF_INITIAL')
group by e.patient_id, e.encounter_date, e.location;