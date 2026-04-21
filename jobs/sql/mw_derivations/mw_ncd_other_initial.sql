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
  diagnosis_date_sickle_cell_disease date default null,
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

-- Build temp_diagnoses in three steps to correctly pair each diagnosis with its own date via obs_group_id.
-- Step 1: pull only Chronic care diagnosis obs for this encounter type.
drop temporary table if exists temp_diagnosis_name_obs;
create temporary table temp_diagnosis_name_obs as
select obs_id, obs_group_id, encounter_id, value_coded as diagnosis_name
from omrs_obs
where concept = 'Chronic care diagnosis'
  and encounter_type = 'NCD_OTHER_INITIAL';
alter table temp_diagnosis_name_obs add index temp_diagnosis_name_obs_group_idx (obs_group_id);
alter table temp_diagnosis_name_obs add index temp_diagnosis_name_obs_encounter_idx (encounter_id);

-- Step 2: pull only Diagnosis date obs that are siblings of a diagnosis from step 1.
drop temporary table if exists temp_diagnosis_date_obs;
create temporary table temp_diagnosis_date_obs as
select obs_group_id, value_date as diagnosis_date
from omrs_obs
where concept = 'Diagnosis date'
  and obs_group_id in (select obs_group_id from temp_diagnosis_name_obs);
alter table temp_diagnosis_date_obs add index temp_diagnosis_date_obs_group_idx (obs_group_id);

-- Step 3: one row per (encounter_id, diagnosis_name, diagnosis_date).
drop temporary table if exists temp_diagnoses;
create temporary table temp_diagnoses as
select n.encounter_id, n.diagnosis_name, d.diagnosis_date
from temp_diagnosis_name_obs n
left join temp_diagnosis_date_obs d on d.obs_group_id = n.obs_group_id;
alter table temp_diagnoses add index temp_diagnoses_encounter_idx (encounter_id);

-- ECG test date: Date of general test obs sharing obs_group_id with an Electrocardiogram diagnosis obs.
drop temporary table if exists temp_ecg_date;
create temporary table temp_ecg_date as
select o.encounter_id, o.value_date
from omrs_obs o
where o.concept = 'Date of general test'
  and o.obs_group_id in (
      select obs_group_id from omrs_obs
      where concept = 'Electrocardiogram diagnosis'
        and encounter_type = 'NCD_OTHER_INITIAL'
  );
alter table temp_ecg_date add index temp_ecg_date_encounter_idx (encounter_id);

-- ECHO test date: Date of general test obs sharing obs_group_id with an ECHO imaging result obs.
drop temporary table if exists temp_echo_date;
create temporary table temp_echo_date as
select o.encounter_id, o.value_date
from omrs_obs o
where o.concept = 'Date of general test'
  and o.obs_group_id in (
      select obs_group_id from omrs_obs
      where concept = 'ECHO imaging result'
        and encounter_type = 'NCD_OTHER_INITIAL'
  );
alter table temp_echo_date add index temp_echo_date_encounter_idx (encounter_id);

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

insert into mw_ncd_other_initial (patient_id, visit_date, location, art_start_date, comorbidities_chronic_kidney_disease, comorbidities_diabetes, comorbidities_hypertension, comorbidities_other, diagnosis_cirrhosis, diagnosis_date_cirrhosis, diagnosis_date_dvt_or_pe, diagnosis_date_other, diagnosis_date_rheumatoid_arthritis, diagnosis_date_sickle_cell_disease, diagnosis_dvt_or_pe, diagnosis_other, diagnosis_rheumatoid_arthritis, diagnosis_sickle_cell_disease, ecg_test_date, ecg_test_result, echo_test_date, echo_test_result, hiv_status, hiv_test_date, tb_start_date, tb_status)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(case when comorbidity.value_coded = 'Chronic kidney disease' then comorbidity.value_coded end) as comorbidities_chronic_kidney_disease,
    max(case when comorbidity.value_coded = 'Diabetes' then comorbidity.value_coded end) as comorbidities_diabetes,
    max(case when comorbidity.value_coded = 'Hypertension' then comorbidity.value_coded end) as comorbidities_hypertension,
    max(other_diagnosis.value_text) as comorbidities_other,
    max(case when diagnoses.diagnosis_name = 'Restrictive cardiomyopathy' then diagnoses.diagnosis_name end) as diagnosis_cirrhosis,
    max(case when diagnoses.diagnosis_name = 'Restrictive cardiomyopathy' then diagnoses.diagnosis_date end) as diagnosis_date_cirrhosis,
    max(case when diagnoses.diagnosis_name = 'Deep vein thrombosis' then diagnoses.diagnosis_date end) as diagnosis_date_dvt_or_pe,
    max(diagnoses.diagnosis_date) as diagnosis_date_other,
    max(case when diagnoses.diagnosis_name = 'Rheumatoid arthritis' then diagnoses.diagnosis_date end) as diagnosis_date_rheumatoid_arthritis,
    max(case when diagnoses.diagnosis_name = 'Sickle cell disease' then diagnoses.diagnosis_date end) as diagnosis_date_sickle_cell_disease,
    max(case when diagnoses.diagnosis_name = 'Deep vein thrombosis' then diagnoses.diagnosis_name end) as diagnosis_dvt_or_pe,
    max(other_diagnosis.value_text) as diagnosis_other,
    max(case when diagnoses.diagnosis_name = 'Rheumatoid arthritis' then diagnoses.diagnosis_name end) as diagnosis_rheumatoid_arthritis,
    max(case when diagnoses.diagnosis_name = 'Sickle cell disease' then diagnoses.diagnosis_name end) as diagnosis_sickle_cell_disease,
    max(ecg_date.value_date) as ecg_test_date,
    max(electrocardiogram_diagnosis.value_coded) as ecg_test_result,
    max(echo_date.value_date) as echo_test_date,
    max(echo_imaging_result.value_text) as echo_test_result,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(tuberculosis_diagnosis_date.value_date) as tb_start_date,
    max(tb_status.value_coded) as tb_status
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_current_opportunistic_infection_or comorbidity on e.encounter_id = comorbidity.encounter_id
left join temp_other_diagnosis other_diagnosis on e.encounter_id = other_diagnosis.encounter_id
left join temp_diagnoses diagnoses on e.encounter_id = diagnoses.encounter_id
left join temp_ecg_date ecg_date on e.encounter_id = ecg_date.encounter_id
left join temp_echo_date echo_date on e.encounter_id = echo_date.encounter_id
left join temp_electrocardiogram_diagnosis electrocardiogram_diagnosis on e.encounter_id = electrocardiogram_diagnosis.encounter_id
left join temp_echo_imaging_result echo_imaging_result on e.encounter_id = echo_imaging_result.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_tuberculosis_diagnosis_date tuberculosis_diagnosis_date on e.encounter_id = tuberculosis_diagnosis_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
where e.encounter_type in ('NCD_OTHER_INITIAL')
group by e.patient_id, e.encounter_date, e.location;
