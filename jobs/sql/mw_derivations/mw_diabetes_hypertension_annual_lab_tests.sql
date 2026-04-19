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

insert into mw_diabetes_hypertension_annual_lab_tests
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Creatinine' then o.value_numeric end) as creatinine,
    max(case when o.concept = 'Fundoscopy' then o.value_text end) as fundoscopy,
    max(case when o.concept = 'Electrocardiogram' then o.value_text end) as ecg,
    max(case when o.concept = 'Lipid profile' then o.value_coded end) as lipid_profile
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('ANNUAL DIABETES HYPERTENSION LAB TESTS')
group by e.patient_id, e.encounter_date, e.location;