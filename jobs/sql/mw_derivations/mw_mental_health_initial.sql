-- Derivation script for mw_mental_health_initial
-- Generated from Pentaho transform: import-into-mw-mental-health-initial.ktr

drop table if exists mw_mental_health_initial;
create table mw_mental_health_initial (
 mental_health_initial_visit_id 			int not null auto_increment primary key,
 patient_id 						int not null,
 visit_date 						date default null,
 location						varchar(255) default null,
 diagnosis_bipolar_mood_disorder			varchar(255) default null,
 diagnosis_date_bipolar_mood_disorder			date default null,
 diagnosis_stress_reactive_adjustment_disorder	varchar(255) default null,
 diagnosis_date_stress_reactive_adjustment_disorder	date default null,
 diagnosis_dissociative_mood_disorder			varchar(255) default null,
 diagnosis_date_dissociative_mood_disorder		date default null,
 diagnosis_hyperkinetic_disorder			varchar(255) default null,
 diagnosis_date_hyperkinetic_disorder			date default null,
 diagnosis_puerperal_mental_disorder			varchar(255) default null,
 diagnosis_date_puerperal_mental_disorder		date default null,
 diagnosis_schizophrenia 				varchar(255) default null,
 diagnosis_date_schizophrenia 			date default null,
 diagnosis_mood_affective_disorder_manic 		varchar(255) default null,
 diagnosis_date_mood_affective_disorder_manic 	date default null,
 diagnosis_mood_affective_disorder_depression 	varchar(255) default null,
 diagnosis_date_mood_affective_disorder_depression 	date default null,
 diagnosis_acute_and_transient_psychotic 		varchar(255) default null,
 diagnosis_date_acute_and_transient_psychotic 	date default null,
 diagnosis_schizoaffective_disorder 		varchar(255) default null,
 diagnosis_date_schizoaffective_disorder 	date default null,
 diagnosis_anxiety_disorder 			varchar(255) default null,
 diagnosis_date_anxiety_disorder 		date default null,
 diagnosis_organic_mental_disorder_acute 	varchar(255) default null,
 diagnosis_date_organic_mental_disorder_acute date default null,
 diagnosis_organic_mental_disorder_chronic	 varchar(255) default null,
 diagnosis_date_organic_mental_disorder_chronic date default null,
 diagnosis_drug_use_mental_disorder 		varchar(255) default null,
 diagnosis_date_drug_use_mental_disorder 	date default null,
 diagnosis_alcohol_use_mental_disorder 	varchar(255) default null,
 diagnosis_date_alcohol_use_mental_disorder	date default null,
 diagnosis_other_1 				varchar(255) default null,
 diagnosis_date_other_1 			date default null,
 diagnosis_other_2 				varchar(255) default null,
 diagnosis_date_other_2 			date default null,
 diagnosis_other_3 				varchar(255) default null,
 diagnosis_date_other_3 			date default null,
 diagnosis_somatoform_disorder			varchar(255) default null,
 diagnosis_date_somatoform_disorder			date default null,
 diagnosis_personality_disorder			varchar(255) default null,
 diagnosis_date_personality_disorder			date default null,
 diagnosis_mental_retardation_disorder		varchar(255) default null,
 diagnosis_date_mental_retardation_disorder		date default null,
 diagnosis_psych_development_disorder			varchar(255) default null,
 diagnosis_date_psych_development_disorder		date default null,
 hiv_status 					varchar(255) default null,
 hiv_test_date 				date default null,
 art_start_date 				date default null,
 tb_status 					varchar(255) default null,
 tb_year 					decimal(10,2) default null,
 hallucinations 				varchar(255) default null,
 hallucinations_date 				date default null,
 delusions 					varchar(255) default null,
 delusions_date 				date default null,
 disorganised_or_disruptive_behaviour 	varchar(255) default null,
 disorganised_or_disruptive_behaviour_date 	date default null,
 disorganised_speech 				varchar(255) default null,
 disorganised_speech_date 			date default null,
 depressive_symptoms 				varchar(255) default null,
 depressive_symptoms_date 			date default null,
 other_complaints 				varchar(255) default null,
 other_complaints_date 			date default null,
 alcohol_exposure 				varchar(255) default null,
 alcohol_years_exposed 			decimal(10,2) default null,
 alcohol_date_last_used 			date default null,
 marijuana_exposure 				varchar(255) default null,
 marijuana_years_exposed			decimal(10,2) default null,
 marijuana_date_last_used 			date default null,
 other_drugs_exposure 				varchar(255) default null,
 other_drugs_years_exposed 			decimal(10,2) default null,
 other_drugs_date_last_used 			date default null,
 traditional_med_exposure 			varchar(255) default null,
 traditional_med_years_exposed 		decimal(10,2) default null,
 traditional_med_date_last_used 		date default null,
 epilepsy_family_history 			varchar(255) default null,
 mental_family_history 			varchar(255) default null,
 behavior_problems_family_history 		varchar(255) default null
) ;

-- Build temp_diagnoses in three steps to correctly pair each diagnosis with its own date via obs_group_id.
-- Step 1: pull only Chronic care diagnosis obs for this encounter type.
drop temporary table if exists temp_diagnosis_name_obs;
create temporary table temp_diagnosis_name_obs as
select obs_id, obs_group_id, encounter_id, value_coded as diagnosis_name
from omrs_obs
where concept = 'Chronic care diagnosis'
  and encounter_type = 'MENTAL_HEALTH_INITIAL';
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

-- Build temp_complaints to pair each chief complaint with its own date via obs_group_id.
drop temporary table if exists temp_complaint_name_obs;
create temporary table temp_complaint_name_obs as
select obs_id, obs_group_id, encounter_id, value_coded as complaint_name
from omrs_obs
where concept = 'Mental health chief complaint'
  and encounter_type = 'MENTAL_HEALTH_INITIAL';
alter table temp_complaint_name_obs add index temp_complaint_name_obs_group_idx (obs_group_id);
alter table temp_complaint_name_obs add index temp_complaint_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_complaint_date_obs;
create temporary table temp_complaint_date_obs as
select obs_group_id, value_date as complaint_date
from omrs_obs
where concept = 'Diagnosis date'
  and obs_group_id in (select obs_group_id from temp_complaint_name_obs);
alter table temp_complaint_date_obs add index temp_complaint_date_obs_group_idx (obs_group_id);

drop temporary table if exists temp_complaints;
create temporary table temp_complaints as
select n.encounter_id, n.complaint_name, d.complaint_date
from temp_complaint_name_obs n
left join temp_complaint_date_obs d on d.obs_group_id = n.obs_group_id;
alter table temp_complaints add index temp_complaints_encounter_idx (encounter_id);

-- Build temp_exposures to pair each exposure type (marijuana, other drugs, traditional medicine)
-- with its date and duration via obs_group_id.
drop temporary table if exists temp_exposure_name_obs;
create temporary table temp_exposure_name_obs as
select obs_id, obs_group_id, encounter_id, value_coded as exposure_name
from omrs_obs
where concept = 'History of exposure'
  and encounter_type = 'MENTAL_HEALTH_INITIAL';
alter table temp_exposure_name_obs add index temp_exposure_name_obs_group_idx (obs_group_id);
alter table temp_exposure_name_obs add index temp_exposure_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_exposure_detail_obs;
create temporary table temp_exposure_detail_obs as
select obs_group_id, concept, value_date, value_numeric
from omrs_obs
where obs_group_id in (select obs_group_id from temp_exposure_name_obs)
  and concept in ('Date of exposure', 'Duration in years');
alter table temp_exposure_detail_obs add index temp_exposure_detail_obs_group_idx (obs_group_id);

drop temporary table if exists temp_exposures;
create temporary table temp_exposures as
select
    n.encounter_id,
    n.exposure_name,
    max(case when d.concept = 'Date of exposure' then d.value_date end) as exposure_date,
    max(case when d.concept = 'Duration in years' then d.value_numeric end) as exposure_years
from temp_exposure_name_obs n
left join temp_exposure_detail_obs d on d.obs_group_id = n.obs_group_id
group by n.encounter_id, n.obs_group_id, n.exposure_name;
alter table temp_exposures add index temp_exposures_encounter_idx (encounter_id);

-- Build temp_alcohol_exposure to pair alcohol exposure with its date and duration via obs_group_id.
drop temporary table if exists temp_alcohol_name_obs;
create temporary table temp_alcohol_name_obs as
select obs_id, obs_group_id, encounter_id, value_coded as exposure_name
from omrs_obs
where concept = 'History of alcohol use'
  and encounter_type = 'MENTAL_HEALTH_INITIAL';
alter table temp_alcohol_name_obs add index temp_alcohol_name_obs_group_idx (obs_group_id);
alter table temp_alcohol_name_obs add index temp_alcohol_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_alcohol_detail_obs;
create temporary table temp_alcohol_detail_obs as
select obs_group_id, concept, value_date, value_numeric
from omrs_obs
where obs_group_id in (select obs_group_id from temp_alcohol_name_obs)
  and concept in ('Date of exposure', 'Duration in years');
alter table temp_alcohol_detail_obs add index temp_alcohol_detail_obs_group_idx (obs_group_id);

drop temporary table if exists temp_alcohol_exposure;
create temporary table temp_alcohol_exposure as
select
    n.encounter_id,
    n.exposure_name as alcohol_exposure,
    max(case when d.concept = 'Date of exposure' then d.value_date end) as alcohol_date,
    max(case when d.concept = 'Duration in years' then d.value_numeric end) as alcohol_years
from temp_alcohol_name_obs n
left join temp_alcohol_detail_obs d on d.obs_group_id = n.obs_group_id
group by n.encounter_id, n.obs_group_id, n.exposure_name;
alter table temp_alcohol_exposure add index temp_alcohol_exposure_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_behavioral_problems;
create temporary table temp_family_history_of_behavioral_problems as select encounter_id, value_coded from omrs_obs where concept = 'Family history of behavioral problems';
alter table temp_family_history_of_behavioral_problems add index temp_family_history_behavioral_problems_encounter (encounter_id);

drop temporary table if exists temp_family_history_of_epilepsy;
create temporary table temp_family_history_of_epilepsy as select encounter_id, value_coded from omrs_obs where concept = 'Family history of epilepsy';
alter table temp_family_history_of_epilepsy add index temp_family_history_of_epilepsy_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_mental_illness;
create temporary table temp_family_history_of_mental_illness as select encounter_id, value_coded from omrs_obs where concept = 'Family history of mental illness';
alter table temp_family_history_of_mental_illness add index temp_family_history_mental_illness_encounter_idx (encounter_id);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

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

insert into mw_mental_health_initial (patient_id, visit_date, location, diagnosis_date_mood_affective_disorder_depression, alcohol_date_last_used, alcohol_exposure, alcohol_years_exposed, behavior_problems_family_history, delusions_date, depressive_symptoms, depressive_symptoms_date, diagnosis_schizophrenia, diagnosis_date_stress_reactive_adjustment_disorder, diagnosis_acute_and_transient_psychotic, diagnosis_anxiety_disorder, diagnosis_bipolar_mood_disorder, diagnosis_date_schizophrenia, diagnosis_date_acute_and_transient_psychotic, diagnosis_date_anxiety_disorder, diagnosis_date_bipolar_mood_disorder, diagnosis_date_dissociative_mood_disorder, diagnosis_date_drug_use_mental_disorder, diagnosis_date_hyperkinetic_disorder, diagnosis_date_mood_affective_disorder_manic, diagnosis_date_organic_mental_disorder_acute, diagnosis_date_organic_mental_disorder_chronic, diagnosis_date_puerperal_mental_disorder, diagnosis_date_schizoaffective_disorder, diagnosis_dissociative_mood_disorder, diagnosis_drug_use_mental_disorder, diagnosis_hyperkinetic_disorder, diagnosis_mood_affective_disorder_depression, diagnosis_mood_affective_disorder_manic, diagnosis_organic_mental_disorder_acute, diagnosis_organic_mental_disorder_chronic, diagnosis_puerperal_mental_disorder, diagnosis_schizoaffective_disorder, diagnosis_stress_reactive_adjustment_disorder, disorganised_or_disruptive_behaviour, disorganised_speech, epilepsy_family_history, hallucinations_date, marijuana_date_last_used, marijuana_exposure, marijuana_years_exposed, mental_family_history, other_complaints, other_complaints_date, other_drugs_date_last_used, other_drugs_exposure, other_drugs_years_exposed, traditional_med_date_last_used, traditional_med_exposure, traditional_med_years_exposed, diagnosis_other_3, art_start_date, delusions, diagnosis_alcohol_use_mental_disorder, diagnosis_date_alcohol_use_mental_disorder, diagnosis_date_mental_retardation_disorder, diagnosis_date_other_1, diagnosis_date_other_2, diagnosis_date_other_3, diagnosis_date_personality_disorder, diagnosis_date_psych_development_disorder, diagnosis_date_somatoform_disorder, diagnosis_mental_retardation_disorder, diagnosis_other_1, diagnosis_other_2, diagnosis_personality_disorder, diagnosis_psych_development_disorder, diagnosis_somatoform_disorder, disorganised_or_disruptive_behaviour_date, disorganised_speech_date, hallucinations, hiv_status, hiv_test_date, tb_status, tb_year)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when diagnoses.diagnosis_name = 'Depression' then diagnoses.diagnosis_date end) as diagnosis_date_mood_affective_disorder_depression,
    max(alcohol_exp.alcohol_date) as alcohol_date_last_used,
    max(alcohol_exp.alcohol_exposure) as alcohol_exposure,
    max(alcohol_exp.alcohol_years) as alcohol_years_exposed,
    max(family_history_of_behavioral_problems.value_coded) as behavior_problems_family_history,
    max(case when complaints.complaint_name = 'Delusions' then complaints.complaint_date end) as delusions_date,
    max(case when complaints.complaint_name = 'Depressive Disorder' then complaints.complaint_name end) as depressive_symptoms,
    max(case when complaints.complaint_name = 'Depressive Disorder' then complaints.complaint_date end) as depressive_symptoms_date,
    max(case when diagnoses.diagnosis_name = 'Schizophrenia' then diagnoses.diagnosis_name end) as diagnosis_schizophrenia,
    max(case when diagnoses.diagnosis_name = 'Stress Reaction Adjustment Disorder' then diagnoses.diagnosis_date end) as diagnosis_date_stress_reactive_adjustment_disorder,
    max(case when diagnoses.diagnosis_name = 'Acute Psychotic disorder' then diagnoses.diagnosis_name end) as diagnosis_acute_and_transient_psychotic,
    max(case when diagnoses.diagnosis_name = 'Anxiety disorder' then diagnoses.diagnosis_name end) as diagnosis_anxiety_disorder,
    max(case when diagnoses.diagnosis_name = 'Mood Affective Disorder (Bipolar)' then diagnoses.diagnosis_name end) as diagnosis_bipolar_mood_disorder,
    max(case when diagnoses.diagnosis_name = 'Schizophrenia' then diagnoses.diagnosis_date end) as diagnosis_date_schizophrenia,
    max(case when diagnoses.diagnosis_name = 'Acute Psychotic disorder' then diagnoses.diagnosis_date end) as diagnosis_date_acute_and_transient_psychotic,
    max(case when diagnoses.diagnosis_name = 'Anxiety disorder' then diagnoses.diagnosis_date end) as diagnosis_date_anxiety_disorder,
    max(case when diagnoses.diagnosis_name = 'Mood Affective Disorder (Bipolar)' then diagnoses.diagnosis_date end) as diagnosis_date_bipolar_mood_disorder,
    max(case when diagnoses.diagnosis_name = 'Dissociative Conversion Disorder' then diagnoses.diagnosis_date end) as diagnosis_date_dissociative_mood_disorder,
    max(case when diagnoses.diagnosis_name = 'Drug-induced mental and behavior disorder' then diagnoses.diagnosis_date end) as diagnosis_date_drug_use_mental_disorder,
    max(case when diagnoses.diagnosis_name = 'Hyperkinetic Conductal Disorder (ADHD)' then diagnoses.diagnosis_date end) as diagnosis_date_hyperkinetic_disorder,
    max(case when diagnoses.diagnosis_name = 'Bipolar Affective Disorder, Manic' then diagnoses.diagnosis_date end) as diagnosis_date_mood_affective_disorder_manic,
    max(case when diagnoses.diagnosis_name = 'Organic mental disorder (acute)' then diagnoses.diagnosis_date end) as diagnosis_date_organic_mental_disorder_acute,
    max(case when diagnoses.diagnosis_name = 'Organic mental disorder (chronic)' then diagnoses.diagnosis_date end) as diagnosis_date_organic_mental_disorder_chronic,
    max(case when diagnoses.diagnosis_name = 'Puerperal Mental Disorder' then diagnoses.diagnosis_date end) as diagnosis_date_puerperal_mental_disorder,
    max(case when diagnoses.diagnosis_name = 'Schizoaffective Disorder' then diagnoses.diagnosis_date end) as diagnosis_date_schizoaffective_disorder,
    max(case when diagnoses.diagnosis_name = 'Dissociative Conversion Disorder' then diagnoses.diagnosis_name end) as diagnosis_dissociative_mood_disorder,
    max(case when diagnoses.diagnosis_name = 'Drug-induced mental and behavior disorder' then diagnoses.diagnosis_name end) as diagnosis_drug_use_mental_disorder,
    max(case when diagnoses.diagnosis_name = 'Hyperkinetic Conductal Disorder (ADHD)' then diagnoses.diagnosis_name end) as diagnosis_hyperkinetic_disorder,
    max(case when diagnoses.diagnosis_name = 'Depression' then diagnoses.diagnosis_name end) as diagnosis_mood_affective_disorder_depression,
    max(case when diagnoses.diagnosis_name = 'Bipolar Affective Disorder, Manic' then diagnoses.diagnosis_name end) as diagnosis_mood_affective_disorder_manic,
    max(case when diagnoses.diagnosis_name = 'Organic mental disorder (acute)' then diagnoses.diagnosis_name end) as diagnosis_organic_mental_disorder_acute,
    max(case when diagnoses.diagnosis_name = 'Organic mental disorder (chronic)' then diagnoses.diagnosis_name end) as diagnosis_organic_mental_disorder_chronic,
    max(case when diagnoses.diagnosis_name = 'Puerperal Mental Disorder' then diagnoses.diagnosis_name end) as diagnosis_puerperal_mental_disorder,
    max(case when diagnoses.diagnosis_name = 'Schizoaffective Disorder' then diagnoses.diagnosis_name end) as diagnosis_schizoaffective_disorder,
    max(case when diagnoses.diagnosis_name = 'Stress Reaction Adjustment Disorder' then diagnoses.diagnosis_name end) as diagnosis_stress_reactive_adjustment_disorder,
    max(case when complaints.complaint_name = 'Disruptive Behavior Disorder' then complaints.complaint_name end) as disorganised_or_disruptive_behaviour,
    max(case when complaints.complaint_name = 'Abnormal speech' then complaints.complaint_name end) as disorganised_speech,
    max(family_history_of_epilepsy.value_coded) as epilepsy_family_history,
    max(case when complaints.complaint_name = 'Hallucinations' then complaints.complaint_date end) as hallucinations_date,
    max(case when exposures.exposure_name = 'Marijuana' then exposures.exposure_date end) as marijuana_date_last_used,
    max(case when exposures.exposure_name = 'Marijuana' then exposures.exposure_name end) as marijuana_exposure,
    max(case when exposures.exposure_name = 'Marijuana' then exposures.exposure_years end) as marijuana_years_exposed,
    max(family_history_of_mental_illness.value_coded) as mental_family_history,
    max(case when complaints.complaint_name = 'Other non-coded' then complaints.complaint_name end) as other_complaints,
    max(case when complaints.complaint_name = 'Other non-coded' then complaints.complaint_date end) as other_complaints_date,
    max(case when exposures.exposure_name = 'Other drugs' then exposures.exposure_date end) as other_drugs_date_last_used,
    max(case when exposures.exposure_name = 'Other drugs' then exposures.exposure_name end) as other_drugs_exposure,
    max(case when exposures.exposure_name = 'Other drugs' then exposures.exposure_years end) as other_drugs_years_exposed,
    max(case when exposures.exposure_name = 'Traditional medicine' then exposures.exposure_date end) as traditional_med_date_last_used,
    max(case when exposures.exposure_name = 'Traditional medicine' then exposures.exposure_name end) as traditional_med_exposure,
    max(case when exposures.exposure_name = 'Traditional medicine' then exposures.exposure_years end) as traditional_med_years_exposed,
    max(diagnoses.diagnosis_name) as diagnosis_other_3,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(case when complaints.complaint_name = 'Delusions' then complaints.complaint_name end) as delusions,
    max(case when diagnoses.diagnosis_name = 'Alcohol-induced mental and behavior disorder' then diagnoses.diagnosis_name end) as diagnosis_alcohol_use_mental_disorder,
    max(case when diagnoses.diagnosis_name = 'Alcohol-induced mental and behavior disorder' then diagnoses.diagnosis_date end) as diagnosis_date_alcohol_use_mental_disorder,
    max(case when diagnoses.diagnosis_name = 'Mental retardation' then diagnoses.diagnosis_date end) as diagnosis_date_mental_retardation_disorder,
    max(diagnoses.diagnosis_date) as diagnosis_date_other_1,
    max(diagnoses.diagnosis_date) as diagnosis_date_other_2,
    max(diagnoses.diagnosis_date) as diagnosis_date_other_3,
    max(case when diagnoses.diagnosis_name = 'Personality Disorder' then diagnoses.diagnosis_date end) as diagnosis_date_personality_disorder,
    max(case when diagnoses.diagnosis_name = 'Psychological development disorder' then diagnoses.diagnosis_date end) as diagnosis_date_psych_development_disorder,
    max(case when diagnoses.diagnosis_name = 'Somatoform Disorder' then diagnoses.diagnosis_date end) as diagnosis_date_somatoform_disorder,
    max(case when diagnoses.diagnosis_name = 'Mental retardation' then diagnoses.diagnosis_name end) as diagnosis_mental_retardation_disorder,
    max(other_non_coded_text.value_text) as diagnosis_other_1,
    max(other_non_coded_text.value_text) as diagnosis_other_2,
    max(case when diagnoses.diagnosis_name = 'Personality Disorder' then diagnoses.diagnosis_name end) as diagnosis_personality_disorder,
    max(case when diagnoses.diagnosis_name = 'Psychological development disorder' then diagnoses.diagnosis_name end) as diagnosis_psych_development_disorder,
    max(case when diagnoses.diagnosis_name = 'Somatoform Disorder' then diagnoses.diagnosis_name end) as diagnosis_somatoform_disorder,
    max(case when complaints.complaint_name = 'Disruptive Behavior Disorder' then complaints.complaint_date end) as disorganised_or_disruptive_behaviour_date,
    max(case when complaints.complaint_name = 'Abnormal speech' then complaints.complaint_date end) as disorganised_speech_date,
    max(case when complaints.complaint_name = 'Hallucinations' then complaints.complaint_name end) as hallucinations,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(tb_status.value_coded) as tb_status,
    max(year_of_tuberculosis_diagnosis.value_numeric) as tb_year
from omrs_encounter e
left join temp_diagnoses diagnoses on e.encounter_id = diagnoses.encounter_id
left join temp_complaints complaints on e.encounter_id = complaints.encounter_id
left join temp_exposures exposures on e.encounter_id = exposures.encounter_id
left join temp_alcohol_exposure alcohol_exp on e.encounter_id = alcohol_exp.encounter_id
left join temp_family_history_of_behavioral_problems family_history_of_behavioral_problems on e.encounter_id = family_history_of_behavioral_problems.encounter_id
left join temp_family_history_of_epilepsy family_history_of_epilepsy on e.encounter_id = family_history_of_epilepsy.encounter_id
left join temp_family_history_of_mental_illness family_history_of_mental_illness on e.encounter_id = family_history_of_mental_illness.encounter_id
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_year_of_tuberculosis_diagnosis year_of_tuberculosis_diagnosis on e.encounter_id = year_of_tuberculosis_diagnosis.encounter_id
where e.encounter_type in ('MENTAL_HEALTH_INITIAL')
group by e.patient_id, e.encounter_date, e.location;
