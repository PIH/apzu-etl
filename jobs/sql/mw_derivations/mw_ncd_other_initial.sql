-- Derivation script for mw_ncd_other_initial
-- Generated from Pentaho transform: import-into-mw-ncd-other-initial.ktr

drop table if exists mw_ncd_other_initial;
create table mw_ncd_other_initial (
  ncd_other_initial_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  diagnosis_rheumatoid_arthritis varchar(255) default null,
  diagnosis_date_rheumatoid_arthritis date default null,
  diagnosis_cirrhosis varchar(255) default null,
  diagnosis_date_cirrhosis date default null,
  diagnosis_dvt_or_pe varchar(255) default null,
  diagnosis_date_dvt_or_pe date default null,
  diagnosis_sickle_cell_disease varchar(255) default null,
  diagnosis_other varchar(255) default null,
  diagnosis_date_other date default null,
  hiv_status varchar(255) default null,
  hiv_test_date date default null,
  art_start_date date default null,
  tb_status varchar(255) default null,
  tb_start_date date default null,
  comorbidities_hypertension varchar(255) default null,
  comorbidities_diabetes varchar(255) default null,
  comorbidities_chronic_kidney_disease varchar(255) default null,
  comorbidities_other varchar(255) default null,
  echo_test_result varchar(255) default null,
  echo_test_date date default null,
  ecg_test_result varchar(255) default null,
  ecg_test_date date default null,
  primary key (ncd_other_initial_visit_id)
);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_current_opportunistic_infection_or;
create temporary table temp_current_opportunistic_infection_or as select encounter_id, value_coded from omrs_obs where concept = 'Current opportunistic infection or comorbidity, confirmed or presumed';
alter table temp_current_opportunistic_infection_or add index temp_current_opportunistic_infection_or_2 (encounter_id);

drop temporary table if exists temp_other_diagnosis;
create temporary table temp_other_diagnosis as select encounter_id, value_text from omrs_obs where concept = 'Other diagnosis';
alter table temp_other_diagnosis add index temp_other_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_chronic_care_diagnosis;
create temporary table temp_chronic_care_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Chronic care diagnosis';
alter table temp_chronic_care_diagnosis add index temp_chronic_care_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date from omrs_obs where concept = 'Diagnosis date';
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

drop temporary table if exists temp_tuberculosis_diagnosis_date;
create temporary table temp_tuberculosis_diagnosis_date as select encounter_id, value_date from omrs_obs where concept = 'Tuberculosis diagnosis date';
alter table temp_tuberculosis_diagnosis_date add index temp_tuberculosis_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from omrs_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

insert into mw_ncd_other_initial (patient_id, visit_date, location, art_start_date, comorbidities_chronic_kidney_disease, comorbidities_diabetes, comorbidities_hypertension, comorbidities_other, diagnosis_cirrhosis, diagnosis_date_other, diagnosis_date_cirrhosis, diagnosis_date_dvt_or_pe, diagnosis_date_rheumatoid_arthritis, diagnosis_date_sickle_cell_disease, diagnosis_dvt_or_pe, diagnosis_other, diagnosis_rheumatoid_arthritis, diagnosis_sickle_cell_disease, ecg_test_date, ecg_test_result, echo_test_date, echo_test_result, hiv_status, hiv_test_date, tb_start_date, tb_status)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(case when current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.value_coded = 'Chronic kidney disease' then current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.value_coded end) as comorbidities_chronic_kidney_disease,
    max(case when current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.value_coded = 'Diabetes' then current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.value_coded end) as comorbidities_diabetes,
    max(case when current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.value_coded = 'Hypertension' then current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.value_coded end) as comorbidities_hypertension,
    max(other_diagnosis.value_text) as comorbidities_other,
    max(case when chronic_care_diagnosis.value_coded = 'Restrictive cardiomyopathy' then chronic_care_diagnosis.value_coded end) as diagnosis_cirrhosis,
    max(diagnosis_date.value_date) as diagnosis_date_other,
    max(diagnosis_date.value_date) as diagnosis_date_cirrhosis,
    max(diagnosis_date.value_date) as diagnosis_date_dvt_or_pe,
    max(diagnosis_date.value_date) as diagnosis_date_rheumatoid_arthritis,
    max(diagnosis_date.value_date) as diagnosis_date_sickle_cell_disease,
    max(case when chronic_care_diagnosis.value_coded = 'Deep vein thrombosis' then chronic_care_diagnosis.value_coded end) as diagnosis_dvt_or_pe,
    max(other_diagnosis.value_text) as diagnosis_other,
    max(case when chronic_care_diagnosis.value_coded = 'Rheumatoid arthritis' then chronic_care_diagnosis.value_coded end) as diagnosis_rheumatoid_arthritis,
    max(case when chronic_care_diagnosis.value_coded = 'Sickle cell disease' then chronic_care_diagnosis.value_coded end) as diagnosis_sickle_cell_disease,
    max(date_of_general_test.value_date) as ecg_test_date,
    max(electrocardiogram_diagnosis.value_coded) as ecg_test_result,
    max(date_of_general_test.value_date) as echo_test_date,
    max(echo_imaging_result.value_text) as echo_test_result,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(tuberculosis_diagnosis_date.value_date) as tb_start_date,
    max(tb_status.value_coded) as tb_status
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_current_opportunistic_infection_or current_opportunistic_infection_or_comorbidity_confirmed_or_presumed on e.encounter_id = current_opportunistic_infection_or_comorbidity_confirmed_or_presumed.encounter_id
left join temp_other_diagnosis other_diagnosis on e.encounter_id = other_diagnosis.encounter_id
left join temp_chronic_care_diagnosis chronic_care_diagnosis on e.encounter_id = chronic_care_diagnosis.encounter_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_date_of_general_test date_of_general_test on e.encounter_id = date_of_general_test.encounter_id
left join temp_electrocardiogram_diagnosis electrocardiogram_diagnosis on e.encounter_id = electrocardiogram_diagnosis.encounter_id
left join temp_echo_imaging_result echo_imaging_result on e.encounter_id = echo_imaging_result.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_tuberculosis_diagnosis_date tuberculosis_diagnosis_date on e.encounter_id = tuberculosis_diagnosis_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
where e.encounter_type in ('NCD_OTHER_INITIAL')
group by e.patient_id, e.encounter_date, e.location;