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

insert into mw_asthma_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date antiretrovirals started' then o.value_date end) as art_start_date,
    max(case when o.concept = 'Symptom present' and o.value_coded = 'Dry cough' then o.value_coded end) as chronic_dry_cough,
    max(case when o.concept = 'Age at cough onset' then o.value_numeric end) as chronic_dry_cough_age_at_onset,
    max(case when o.concept = 'Duration of symptom in months' then o.value_numeric end) as chronic_dry_cough_duration_in_months,
    max(case when o.concept = 'Location of cooking' and o.value_coded = 'Indoors' then o.value_coded end) as cooking_indoor,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Asthma' then o.value_coded end) as diagnosis_asthma,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Chronic obstructive pulmonary disease' then o.value_coded end) as diagnosis_copd,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_asthma,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_copd,
    max(case when o.concept = 'Asthma family history' then o.value_coded end) as family_history_asthma,
    max(case when o.concept = 'COPD family history' then o.value_coded end) as family_history_copd,
    max(case when o.concept = 'HIV status' then o.value_coded end) as hiv_status,
    max(case when o.concept = 'HIV test date' then o.value_date end) as hiv_test_date,
    max(case when o.concept = 'Exposure' and o.value_coded = 'Contact with a TB+ person' then o.value_coded end) as tb_contact,
    max(case when o.concept = 'Date of exposure' then o.value_date end) as tb_contact_date,
    max(case when o.concept = 'TB status' then o.value_coded end) as tb_status,
    max(case when o.concept = 'Year of Tuberculosis diagnosis' then o.value_numeric end) as tb_year,
    max(case when o.concept = 'Location of cooking' and o.value_coded = 'Outdoors' then o.value_coded end) as cooking_indoor,
    max(case when o.concept = 'Last time person used tobacco' then o.value_date end) as last_smoking_history_date,
    max(case when o.concept = 'Main activity' then o.value_coded end) as occupation,
    max(case when o.concept = 'Exposure' and o.value_coded = 'Occupational exposure' then o.value_coded end) as occupation_exposure,
    max(case when o.concept = 'Date of exposure' then o.value_date end) as occupation_exposure_date,
    max(case when o.concept = 'Exposure' and o.value_coded = 'Exposed to second hand smoke?' then o.value_coded end) as second_hand_smoking,
    max(case when o.concept = 'Date of exposure' then o.value_date end) as second_hand_smoking_date,
    max(case when o.concept = 'Smoking history' and o.value_coded = 'In the past' then o.value_coded end) as smoking_history
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('ASTHMA_INITIAL')
group by e.patient_id, e.encounter_date, e.location;