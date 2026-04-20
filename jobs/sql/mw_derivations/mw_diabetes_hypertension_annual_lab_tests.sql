-- Derivation script for mw_diabetes_hypertension_annual_lab_tests
-- Generated from Pentaho transform: import-into-mw-diabetes-hypertension-annual-lab-tests.ktr

drop table if exists mw_diabetes_hypertension_annual_lab_tests;
create table mw_diabetes_hypertension_annual_lab_tests (
  diabetes_hypertension_annual_lab_tests_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  ecg					varchar(255) default null,
  creatinine				varchar(255) default null,
  lipid_profile			varchar(255) default null,
  fundoscopy				varchar(255) default null,
  primary key (diabetes_hypertension_annual_lab_tests_id)
);

drop temporary table if exists temp_creatinine;
create temporary table temp_creatinine as select encounter_id, value_numeric from omrs_obs where concept = 'Creatinine';
alter table temp_creatinine add index temp_creatinine_encounter_idx (encounter_id);

drop temporary table if exists temp_fundoscopy;
create temporary table temp_fundoscopy as select encounter_id, value_text from omrs_obs where concept = 'Fundoscopy';
alter table temp_fundoscopy add index temp_fundoscopy_encounter_idx (encounter_id);

drop temporary table if exists temp_electrocardiogram;
create temporary table temp_electrocardiogram as select encounter_id, value_text from omrs_obs where concept = 'Electrocardiogram';
alter table temp_electrocardiogram add index temp_electrocardiogram_encounter_idx (encounter_id);

drop temporary table if exists temp_lipid_profile;
create temporary table temp_lipid_profile as select encounter_id, value_coded from omrs_obs where concept = 'Lipid profile';
alter table temp_lipid_profile add index temp_lipid_profile_encounter_idx (encounter_id);

insert into mw_diabetes_hypertension_annual_lab_tests
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(creatinine.value_numeric) as creatinine,
    max(fundoscopy.value_text) as fundoscopy,
    max(electrocardiogram.value_text) as ecg,
    max(lipid_profile.value_coded) as lipid_profile
from omrs_encounter e
left join temp_creatinine creatinine on e.encounter_id = creatinine.encounter_id
left join temp_fundoscopy fundoscopy on e.encounter_id = fundoscopy.encounter_id
left join temp_electrocardiogram electrocardiogram on e.encounter_id = electrocardiogram.encounter_id
left join temp_lipid_profile lipid_profile on e.encounter_id = lipid_profile.encounter_id
where e.encounter_type in ('ANNUAL DIABETES HYPERTENSION LAB TESTS')
group by e.patient_id, e.encounter_date, e.location;