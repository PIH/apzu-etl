-- Derivation script for mw_diabetes_hypertension_initial
-- Generated from Pentaho transform: import-into-mw-diabetes-hypertension-initial.ktr

drop table if exists mw_diabetes_hypertension_initial;
create table mw_diabetes_hypertension_initial (
  initial_visit_id 				int not null auto_increment,
  patient_id    				int not null,
  visit_date            			date,
  location              			varchar(255),
  diagnosis_type_1_diabetes 			varchar(255),
  diagnosis_type_1_diabetes_date		date, 
  diagnosis_type_2_diabetes 			varchar(255),
  diagnosis_type_2_diabetes_date		date, 
  diagnosis_hypertension 			varchar(255),
  diagnosis_hypertension_date			date, 
  hiv_status		 			varchar(255),
  hiv_test_date				date, 
  art_start_date				date, 
  cardiovascular_disease			varchar(255),
  cardiovascular_disease_date			date,
  retinopathy					varchar(255),
  retinopathy_date				date,
  renal_disease				varchar(255),
  renal_disease_date				date,
  family_history_diabetes_mellitus		varchar(255),
  family_history_hypertension   		varchar(255),
  tb_status					varchar(255),
  tb_status_year		   		varchar(255),
  stroke_and_tia				varchar(255),
  stroke_and_tia_date				date,
  peripheral_vascular_disease			varchar(255),
  peripheral_vascular_disease_date		date,
  neuropathy					varchar(255),
  neuropathy_date				date,
  sexual_disorder				varchar(255),
  sexual_disorder_date				date,
     primary key (initial_visit_id)
);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date, obs_group_id from omrs_obs where concept = 'Diagnosis date';
alter table temp_diagnosis_date add index temp_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_diabetes_mellitus;
create temporary table temp_family_history_of_diabetes_mellitus as select encounter_id, value_coded from omrs_obs where concept = 'Family History of Diabetes Mellitus';
alter table temp_family_history_of_diabetes_mellitus add index temp_family_history_diabetes_mellitus_encounter (encounter_id);

drop temporary table if exists temp_family_history_of_hypertension;
create temporary table temp_family_history_of_hypertension as select encounter_id, value_coded from omrs_obs where concept = 'Family history of hypertension';
alter table temp_family_history_of_hypertension add index temp_family_history_of_hypertension_encounter_idx (encounter_id);

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

insert into mw_diabetes_hypertension_initial (patient_id, visit_date, location, art_start_date, cardiovascular_disease, cardiovascular_disease_obs_group_id, cardiovascular_disease_date, cardiovascular_disease_obs_group_id, family_history_diabetes_mellitus, family_history_hypertension, hiv_status, hiv_test_date, diagnosis_hypertension, hypertension_obs_group_id, diagnosis_hypertension_date, hypertension_obs_group_id, neuropathy, neuropathy_obs_group_id, neuropathy_date, neuropathy_obs_group_id, peripheral_vascular_disease_date, peripheral_vascular_disease_obs_group_id, peripheral_vascular_disease, peripheral_vascular_disease_obs_group_id, renal_disease, renal_disease_obs_group_id, renal_disease_date, renal_disease_obs_group_id, retinopathy, retinopathy_obs_group_id, retinopathy_date, retinopathy_obs_group_id, sexual_disorder, sexual_disorder_obs_group_id, sexual_disorder_date, sexual_disorder_obs_group_id, stroke_and_tia_date, stroke_and_tia, tb_status, tb_status_year, diagnosis_type_1_diabetes, type_1_diabetes_obs_group_id, diagnosis_type_1_diabetes_date, type_1_diabetes_obs_group_id, diagnosis_type_2_diabetes, type_2_diabetes_obs_group_id, diagnosis_type_2_diabetes_date, type_2_diabetes_obs_group_id)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(null) as cardiovascular_disease,
    max(null) as cardiovascular_disease_obs_group_id,
    max(diagnosis_date.value_date) as cardiovascular_disease_date,
    max(diagnosis_date.obs_group_id) as cardiovascular_disease_obs_group_id,
    max(family_history_of_diabetes_mellitus.value_coded) as family_history_diabetes_mellitus,
    max(family_history_of_hypertension.value_coded) as family_history_hypertension,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(null) as diagnosis_hypertension,
    max(null) as hypertension_obs_group_id,
    max(diagnosis_date.value_date) as diagnosis_hypertension_date,
    max(diagnosis_date.obs_group_id) as hypertension_obs_group_id,
    max(null) as neuropathy,
    max(null) as neuropathy_obs_group_id,
    max(diagnosis_date.value_date) as neuropathy_date,
    max(diagnosis_date.obs_group_id) as neuropathy_obs_group_id,
    max(diagnosis_date.value_date) as peripheral_vascular_disease_date,
    max(diagnosis_date.obs_group_id) as peripheral_vascular_disease_obs_group_id,
    max(null) as peripheral_vascular_disease,
    max(null) as peripheral_vascular_disease_obs_group_id,
    max(null) as renal_disease,
    max(null) as renal_disease_obs_group_id,
    max(diagnosis_date.value_date) as renal_disease_date,
    max(diagnosis_date.obs_group_id) as renal_disease_obs_group_id,
    max(null) as retinopathy,
    max(null) as retinopathy_obs_group_id,
    max(diagnosis_date.value_date) as retinopathy_date,
    max(diagnosis_date.obs_group_id) as retinopathy_obs_group_id,
    max(null) as sexual_disorder,
    max(null) as sexual_disorder_obs_group_id,
    max(diagnosis_date.value_date) as sexual_disorder_date,
    max(diagnosis_date.obs_group_id) as sexual_disorder_obs_group_id,
    max(diagnosis_date.value_date) as stroke_and_tia_date,
    max(null) as stroke_and_tia,
    max(tb_status.value_coded) as tb_status,
    max(year_of_tuberculosis_diagnosis.value_numeric) as tb_status_year,
    max(null) as diagnosis_type_1_diabetes,
    max(null) as type_1_diabetes_obs_group_id,
    max(diagnosis_date.value_date) as diagnosis_type_1_diabetes_date,
    max(diagnosis_date.obs_group_id) as type_1_diabetes_obs_group_id,
    max(null) as diagnosis_type_2_diabetes,
    max(null) as type_2_diabetes_obs_group_id,
    max(diagnosis_date.value_date) as diagnosis_type_2_diabetes_date,
    max(diagnosis_date.obs_group_id) as type_2_diabetes_obs_group_id
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_family_history_of_diabetes_mellitus family_history_of_diabetes_mellitus on e.encounter_id = family_history_of_diabetes_mellitus.encounter_id
left join temp_family_history_of_hypertension family_history_of_hypertension on e.encounter_id = family_history_of_hypertension.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_year_of_tuberculosis_diagnosis year_of_tuberculosis_diagnosis on e.encounter_id = year_of_tuberculosis_diagnosis.encounter_id
where e.encounter_type in ('DIABETES HYPERTENSION INITIAL VISIT')
group by e.patient_id, e.encounter_date, e.location;