-- Derivation script for mw_epilepsy_initial
-- Generated from Pentaho transform: import-into-mw-epilepsy-initial.ktr

drop table if exists mw_epilepsy_initial;
create table mw_epilepsy_initial (
  epilepsy_initial_visit_id 			int not null auto_increment,
  patient_id 					int not null,
  visit_date 					date default null,
  location 					varchar(255) default null,
  seizure_type_tonic_clonic 			varchar(255) default null,
  seizure_type_clonic 				varchar(255) default null,
  seizure_type_simple 				varchar(255) default null,
  seizure_type_absence 			varchar(255) default null,
  seizure_type_tonic 				varchar(255) default null,
  seizure_type_complex 			varchar(255) default null,
  seizure_type_myoclonic 			varchar(255) default null,
  seizure_type_atonic 				varchar(255) default null,
  seizure_type_unclassified 			varchar(255) default null,
  epilepsy_family_history 			varchar(255) default null,
  mental_health_family_history 		varchar(255) default null,
  behavioral_family_history 			varchar(255) default null,
  hiv_status 					varchar(255) default null,
  hiv_test_date 				date default null,
  art_start_date 				date default null,
  vdrl 					varchar(255) default null,
  month_of_onset 				int(11) default null,
  year_of_onset 				int(11) default null,
  age_at_onset 				int default null,
  marital_status 				varchar(255) default null,
  occupation 					varchar(255) default null,
  education_level 				varchar(255) default null,
  medication_history 				varchar(255) default null,
  pre_ictal_warning 				varchar(255) default null,
  post_ictal_headache 				varchar(255) default null,
  post_ictal_drowsiness 			varchar(255) default null,
  post_ictal_poor_concentration 		varchar(255) default null,
  post_ictal_poor_verbal_or_cognition 	varchar(255) default null,
  post_ictal_paralysis 			varchar(255) default null,
  post_ictal_disorientation 			varchar(255) default null,
  post_ictal_nausea 				varchar(255) default null,
  post_ictal_memory_loss		 	varchar(255) default null,
  post_ictal_hyperactivity 			varchar(255) default null,
  head_trauma_injury_surgery 			varchar(255) default null,
  history_of_seizure 				varchar(255) default null,
  complications_at_birth			varchar(255) default null,
  neonatal_infection_cerebral_malaria_meningitis varchar(255) default null,
  delayed_milestones 				varchar(255) default null,
  alcohol_trigger 				varchar(255) default null,
  fever_trigger 				varchar(255) default null,
  sound_light_and_touch_trigger 		varchar(255) default null,
  emotional_stress_anger_boredom_trigger 	varchar(255) default null,
  sleep_deprivation_and_overtired_trigger 	varchar(255) default null,
  missed_medication_trigger 			varchar(255) default null,
  menstruation_trigger 			varchar(255) default null,
  smoking_exposure 				varchar(255) default null,
  smoking_date_of_exposure 			date default null,
  alcohol_exposure 				varchar(255) default null,
  alcohol_date_of_exposure	 		date default null,
  pig_exposure 				varchar(255) default null,
  pig_date_of_exposure 			date default null,
  traditional_medicine_exposure		varchar(255) default null,
  traditional_medicine_date_of_exposure 	varchar(255) default null,
  injury_complication			 	varchar(255) default null,
  date_of_injury_complication 		date default null,
  burn_complication				varchar(255) default null,
  date_of_burn_complication			date default null,
  status_epilepticus_complication 		varchar(255) default null,
  date_of_status_epilepticus_complication 	date default null,
  psychosis_complication		 	varchar(255) default null,
  date_of_psychosis_complication	 	date default null,
  drug_related_complication		 	varchar(255) default null,
  drug_related_complication_date	 	date default null,
  other_complication			 	varchar(255) default null,
  other_complication_date 			date default null,
  primary key (epilepsy_initial_visit_id)
) ;

drop temporary table if exists temp_age_of_epilepsy_diagnosis;
create temporary table temp_age_of_epilepsy_diagnosis as select encounter_id, value_numeric from omrs_obs where concept = 'Age of epilepsy diagnosis';
alter table temp_age_of_epilepsy_diagnosis add index temp_age_of_epilepsy_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_exposure;
create temporary table temp_date_of_exposure as select encounter_id, value_date from omrs_obs where concept = 'Date of exposure';
alter table temp_date_of_exposure add index temp_date_of_exposure_encounter_idx (encounter_id);

drop temporary table if exists temp_exposure;
create temporary table temp_exposure as select encounter_id, value_coded from omrs_obs where concept = 'Exposure';
alter table temp_exposure add index temp_exposure_encounter_idx (encounter_id);

drop temporary table if exists temp_alcohol_trigger;
create temporary table temp_alcohol_trigger as select encounter_id, value_coded from omrs_obs where concept = 'Alcohol trigger';
alter table temp_alcohol_trigger add index temp_alcohol_trigger_encounter_idx (encounter_id);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_behavioral_problems;
create temporary table temp_family_history_of_behavioral_problems as select encounter_id, value_coded from omrs_obs where concept = 'Family history of behavioral problems';
alter table temp_family_history_of_behavioral_problems add index temp_family_history_behavioral_problems_encounter (encounter_id);

drop temporary table if exists temp_epilepsy_complications;
create temporary table temp_epilepsy_complications as select encounter_id, value_coded, obs_group_id from omrs_obs where concept = 'Epilepsy complications';
alter table temp_epilepsy_complications add index temp_epilepsy_complications_encounter_idx (encounter_id);

drop temporary table if exists temp_complications_at_birth;
create temporary table temp_complications_at_birth as select encounter_id, value_coded from omrs_obs where concept = 'Complications at birth';
alter table temp_complications_at_birth add index temp_complications_at_birth_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_complication;
create temporary table temp_date_of_complication as select encounter_id, value_date, obs_group_id from omrs_obs where concept = 'Date of complication';
alter table temp_date_of_complication add index temp_date_of_complication_encounter_idx (encounter_id);

drop temporary table if exists temp_delayed_milestones;
create temporary table temp_delayed_milestones as select encounter_id, value_coded from omrs_obs where concept = 'Delayed milestones';
alter table temp_delayed_milestones add index temp_delayed_milestones_encounter_idx (encounter_id);

drop temporary table if exists temp_highest_level_of_school_completed;
create temporary table temp_highest_level_of_school_completed as select encounter_id, value_coded from omrs_obs where concept = 'Highest level of school completed';
alter table temp_highest_level_of_school_completed add index temp_highest_level_school_completed_encounter_idx (encounter_id);

drop temporary table if exists temp_emotional_stress_anger_boredom;
create temporary table temp_emotional_stress_anger_boredom as select encounter_id, value_coded from omrs_obs where concept = 'Emotional stress, anger, boredom';
alter table temp_emotional_stress_anger_boredom add index temp_emotional_stress_anger_boredom_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_epilepsy;
create temporary table temp_family_history_of_epilepsy as select encounter_id, value_coded from omrs_obs where concept = 'Family history of epilepsy';
alter table temp_family_history_of_epilepsy add index temp_family_history_of_epilepsy_encounter_idx (encounter_id);

drop temporary table if exists temp_fever_trigger;
create temporary table temp_fever_trigger as select encounter_id, value_coded from omrs_obs where concept = 'Fever trigger';
alter table temp_fever_trigger add index temp_fever_trigger_encounter_idx (encounter_id);

drop temporary table if exists temp_injury_trauma_surgery_of_head;
create temporary table temp_injury_trauma_surgery_of_head as select encounter_id, value_coded from omrs_obs where concept = 'Injury, trauma, surgery of head';
alter table temp_injury_trauma_surgery_of_head add index temp_injury_trauma_surgery_of_head_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_seizure;
create temporary table temp_history_of_seizure as select encounter_id, value_coded from omrs_obs where concept = 'History of seizure';
alter table temp_history_of_seizure add index temp_history_of_seizure_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_date;
create temporary table temp_hiv_test_date as select encounter_id, value_date from omrs_obs where concept = 'HIV test date';
alter table temp_hiv_test_date add index temp_hiv_test_date_encounter_idx (encounter_id);

drop temporary table if exists temp_civil_status;
create temporary table temp_civil_status as select encounter_id, value_coded from omrs_obs where concept = 'Civil status';
alter table temp_civil_status add index temp_civil_status_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_history_text;
create temporary table temp_medication_history_text as select encounter_id, value_text from omrs_obs where concept = 'Medication history (text)';
alter table temp_medication_history_text add index temp_medication_history_text_encounter_idx (encounter_id);

drop temporary table if exists temp_menstruation_trigger;
create temporary table temp_menstruation_trigger as select encounter_id, value_coded from omrs_obs where concept = 'Menstruation trigger';
alter table temp_menstruation_trigger add index temp_menstruation_trigger_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_mental_illness;
create temporary table temp_family_history_of_mental_illness as select encounter_id, value_coded from omrs_obs where concept = 'Family history of mental illness';
alter table temp_family_history_of_mental_illness add index temp_family_history_mental_illness_encounter_idx (encounter_id);

drop temporary table if exists temp_missed_medication_trigger;
create temporary table temp_missed_medication_trigger as select encounter_id, value_coded from omrs_obs where concept = 'Missed medication trigger';
alter table temp_missed_medication_trigger add index temp_missed_medication_trigger_encounter_idx (encounter_id);

drop temporary table if exists temp_month_of_onset;
create temporary table temp_month_of_onset as select encounter_id, value_numeric from omrs_obs where concept = 'Month of onset';
alter table temp_month_of_onset add index temp_month_of_onset_encounter_idx (encounter_id);

drop temporary table if exists temp_neonatal_infection_cerebral_malaria_and_or;
create temporary table temp_neonatal_infection_cerebral_malaria_and_or as select encounter_id, value_coded from omrs_obs where concept = 'Neonatal infection, Cerebral Malaria, and/or Meningitis';
alter table temp_neonatal_infection_cerebral_malaria_and_or add index temp_neonatal_infection_cerebral_malaria_and_or_2 (encounter_id);

drop temporary table if exists temp_main_activity;
create temporary table temp_main_activity as select encounter_id, value_coded from omrs_obs where concept = 'Main activity';
alter table temp_main_activity add index temp_main_activity_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_disorientation;
create temporary table temp_post_ictal_disorientation as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal disorientation';
alter table temp_post_ictal_disorientation add index temp_post_ictal_disorientation_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_drowsiness;
create temporary table temp_post_ictal_drowsiness as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal drowsiness';
alter table temp_post_ictal_drowsiness add index temp_post_ictal_drowsiness_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_headache;
create temporary table temp_post_ictal_headache as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal headache';
alter table temp_post_ictal_headache add index temp_post_ictal_headache_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_hyperactivity;
create temporary table temp_post_ictal_hyperactivity as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal hyperactivity';
alter table temp_post_ictal_hyperactivity add index temp_post_ictal_hyperactivity_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_memory_loss;
create temporary table temp_post_ictal_memory_loss as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal memory loss';
alter table temp_post_ictal_memory_loss add index temp_post_ictal_memory_loss_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_nausea;
create temporary table temp_post_ictal_nausea as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal nausea';
alter table temp_post_ictal_nausea add index temp_post_ictal_nausea_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_paralysis;
create temporary table temp_post_ictal_paralysis as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal paralysis';
alter table temp_post_ictal_paralysis add index temp_post_ictal_paralysis_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_poor_concentration;
create temporary table temp_post_ictal_poor_concentration as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal poor concentration';
alter table temp_post_ictal_poor_concentration add index temp_post_ictal_poor_concentration_encounter_idx (encounter_id);

drop temporary table if exists temp_post_ictal_poor_verbal_or_cognition;
create temporary table temp_post_ictal_poor_verbal_or_cognition as select encounter_id, value_coded from omrs_obs where concept = 'Post-ictal poor verbal or cognition';
alter table temp_post_ictal_poor_verbal_or_cognition add index temp_post_ictal_poor_verbal_or_cognition_2 (encounter_id);

drop temporary table if exists temp_pre_ictal_warning;
create temporary table temp_pre_ictal_warning as select encounter_id, value_coded from omrs_obs where concept = 'Pre-ictal warning';
alter table temp_pre_ictal_warning add index temp_pre_ictal_warning_encounter_idx (encounter_id);

drop temporary table if exists temp_absence_seizures;
create temporary table temp_absence_seizures as select encounter_id, value_coded from omrs_obs where concept = 'Absence seizures';
alter table temp_absence_seizures add index temp_absence_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_atonic_seizures;
create temporary table temp_atonic_seizures as select encounter_id, value_coded from omrs_obs where concept = 'Atonic seizures';
alter table temp_atonic_seizures add index temp_atonic_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_clonic_seizures;
create temporary table temp_clonic_seizures as select encounter_id, value_coded from omrs_obs where concept = 'Clonic seizures';
alter table temp_clonic_seizures add index temp_clonic_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_complex_partial_seizure;
create temporary table temp_complex_partial_seizure as select encounter_id, value_coded from omrs_obs where concept = 'Complex partial seizure';
alter table temp_complex_partial_seizure add index temp_complex_partial_seizure_encounter_idx (encounter_id);

drop temporary table if exists temp_myoclonic_seizures;
create temporary table temp_myoclonic_seizures as select encounter_id, value_coded from omrs_obs where concept = 'Myoclonic seizures';
alter table temp_myoclonic_seizures add index temp_myoclonic_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_simple_partial_seizure;
create temporary table temp_simple_partial_seizure as select encounter_id, value_coded from omrs_obs where concept = 'Simple partial seizure';
alter table temp_simple_partial_seizure add index temp_simple_partial_seizure_encounter_idx (encounter_id);

drop temporary table if exists temp_tonic_seizures;
create temporary table temp_tonic_seizures as select encounter_id, value_coded from omrs_obs where concept = 'Tonic seizures';
alter table temp_tonic_seizures add index temp_tonic_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_seizures_grandmal;
create temporary table temp_seizures_grandmal as select encounter_id, value_coded from omrs_obs where concept = 'Seizures grandmal';
alter table temp_seizures_grandmal add index temp_seizures_grandmal_encounter_idx (encounter_id);

drop temporary table if exists temp_unclassified_epileptic_seizures;
create temporary table temp_unclassified_epileptic_seizures as select encounter_id, value_coded from omrs_obs where concept = 'Unclassified epileptic seizures';
alter table temp_unclassified_epileptic_seizures add index temp_unclassified_epileptic_seizures_encounter_idx (encounter_id);

drop temporary table if exists temp_sleep_deprivation_and_overtired;
create temporary table temp_sleep_deprivation_and_overtired as select encounter_id, value_coded from omrs_obs where concept = 'Sleep deprivation and overtired';
alter table temp_sleep_deprivation_and_overtired add index temp_sleep_deprivation_and_overtired_encounter_idx (encounter_id);

drop temporary table if exists temp_sound_light_and_touch;
create temporary table temp_sound_light_and_touch as select encounter_id, value_coded from omrs_obs where concept = 'Sound, light, and touch';
alter table temp_sound_light_and_touch add index temp_sound_light_and_touch_encounter_idx (encounter_id);

drop temporary table if exists temp_vdrl;
create temporary table temp_vdrl as select encounter_id, value_coded from omrs_obs where concept = 'Vdrl';
alter table temp_vdrl add index temp_vdrl_encounter_idx (encounter_id);

drop temporary table if exists temp_year_of_onset;
create temporary table temp_year_of_onset as select encounter_id, value_numeric from omrs_obs where concept = 'Year of onset';
alter table temp_year_of_onset add index temp_year_of_onset_encounter_idx (encounter_id);

insert into mw_epilepsy_initial (patient_id, visit_date, location, age_at_onset, alcohol_date_of_exposure, alcohol_exposure, alcohol_trigger, art_start_date, behavioral_family_history, burn_complication, obs_group_burn_complication, complications_at_birth, date_of_burn_complication, obs_group_burn_complication, date_of_injury_complication, date_of_psychosis_complication, date_of_status_epilepticus_complication, obs_group_epilepticus_complication, delayed_milestones, drug_related_complication, drug_related_complication_date, education_level, emotional_stress_anger_boredom_trigger, epilepsy_family_history, fever_trigger, head_trauma_injury_surgery, history_of_seizure, hiv_status, hiv_test_date, injury_complication, marital_status, medication_history, menstruation_trigger, mental_health_family_history, missed_medication_trigger, month_of_onset, neonatal_infection_cerebral_malaria_meningitis, occupation, other_complication, other_complication_date, pig_date_of_exposure, pig_exposure, post_ictal_disorientation, post_ictal_drowsiness, post_ictal_headache, post_ictal_hyperactivity, post_ictal_memory_loss, post_ictal_nausea, post_ictal_paralysis, post_ictal_poor_concentration, post_ictal_poor_verbal_or_cognition, pre_ictal_warning, psychosis_complication, seizure_type_absence, seizure_type_atonic, seizure_type_clonic, seizure_type_complex, seizure_type_myoclonic, seizure_type_simple, seizure_type_tonic, seizure_type_tonic_clonic, seizure_type_unclassified, sleep_deprivation_and_overtired_trigger, smoking_date_of_exposure, smoking_exposure, sound_light_and_touch_trigger, status_epilepticus_complication, obs_group_epilepticus_complication, traditional_medicine_date_of_exposure, traditional_medicine_exposure, vdrl, year_of_onset)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(age_of_epilepsy_diagnosis.value_numeric) as age_at_onset,
    max(date_of_exposure.value_date) as alcohol_date_of_exposure,
    max(case when exposure.value_coded = 'Alcohol' then exposure.value_coded end) as alcohol_exposure,
    max(alcohol_trigger.value_coded) as alcohol_trigger,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(family_history_of_behavioral_problems.value_coded) as behavioral_family_history,
    max(case when epilepsy_complications.value_coded = 'Burn' then epilepsy_complications.value_coded end) as burn_complication,
    max(case when epilepsy_complications.value_coded = 'Burn' then epilepsy_complications.obs_group_id end) as obs_group_burn_complication,
    max(complications_at_birth.value_coded) as complications_at_birth,
    max(date_of_complication.value_date) as date_of_burn_complication,
    max(date_of_complication.obs_group_id) as obs_group_burn_complication,
    max(date_of_complication.value_date) as date_of_injury_complication,
    max(date_of_complication.value_date) as date_of_psychosis_complication,
    max(date_of_complication.value_date) as date_of_status_epilepticus_complication,
    max(date_of_complication.obs_group_id) as obs_group_epilepticus_complication,
    max(delayed_milestones.value_coded) as delayed_milestones,
    max(case when epilepsy_complications.value_coded = 'Side effects of treatment' then epilepsy_complications.value_coded end) as drug_related_complication,
    max(date_of_complication.value_date) as drug_related_complication_date,
    max(highest_level_of_school_completed.value_coded) as education_level,
    max(emotional_stress_anger_boredom.value_coded) as emotional_stress_anger_boredom_trigger,
    max(family_history_of_epilepsy.value_coded) as epilepsy_family_history,
    max(fever_trigger.value_coded) as fever_trigger,
    max(injury_trauma_surgery_of_head.value_coded) as head_trauma_injury_surgery,
    max(history_of_seizure.value_coded) as history_of_seizure,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(case when epilepsy_complications.value_coded = 'Injury' then epilepsy_complications.value_coded end) as injury_complication,
    max(civil_status.value_coded) as marital_status,
    max(medication_history_text.value_text) as medication_history,
    max(menstruation_trigger.value_coded) as menstruation_trigger,
    max(family_history_of_mental_illness.value_coded) as mental_health_family_history,
    max(missed_medication_trigger.value_coded) as missed_medication_trigger,
    max(month_of_onset.value_numeric) as month_of_onset,
    max(neonatal_infection_cerebral_malaria_and_or_meningitis.value_coded) as neonatal_infection_cerebral_malaria_meningitis,
    max(main_activity.value_coded) as occupation,
    max(case when epilepsy_complications.value_coded = 'Other' then epilepsy_complications.value_coded end) as other_complication,
    max(date_of_complication.value_date) as other_complication_date,
    max(date_of_exposure.value_date) as pig_date_of_exposure,
    max(case when exposure.value_coded = 'Pig' then exposure.value_coded end) as pig_exposure,
    max(post_ictal_disorientation.value_coded) as post_ictal_disorientation,
    max(post_ictal_drowsiness.value_coded) as post_ictal_drowsiness,
    max(post_ictal_headache.value_coded) as post_ictal_headache,
    max(post_ictal_hyperactivity.value_coded) as post_ictal_hyperactivity,
    max(post_ictal_memory_loss.value_coded) as post_ictal_memory_loss,
    max(post_ictal_nausea.value_coded) as post_ictal_nausea,
    max(post_ictal_paralysis.value_coded) as post_ictal_paralysis,
    max(post_ictal_poor_concentration.value_coded) as post_ictal_poor_concentration,
    max(post_ictal_poor_verbal_or_cognition.value_coded) as post_ictal_poor_verbal_or_cognition,
    max(pre_ictal_warning.value_coded) as pre_ictal_warning,
    max(case when epilepsy_complications.value_coded = 'Injury' then epilepsy_complications.value_coded end) as psychosis_complication,
    max(absence_seizures.value_coded) as seizure_type_absence,
    max(atonic_seizures.value_coded) as seizure_type_atonic,
    max(clonic_seizures.value_coded) as seizure_type_clonic,
    max(complex_partial_seizure.value_coded) as seizure_type_complex,
    max(myoclonic_seizures.value_coded) as seizure_type_myoclonic,
    max(simple_partial_seizure.value_coded) as seizure_type_simple,
    max(tonic_seizures.value_coded) as seizure_type_tonic,
    max(seizures_grandmal.value_coded) as seizure_type_tonic_clonic,
    max(unclassified_epileptic_seizures.value_coded) as seizure_type_unclassified,
    max(sleep_deprivation_and_overtired.value_coded) as sleep_deprivation_and_overtired_trigger,
    max(date_of_exposure.value_date) as smoking_date_of_exposure,
    max(case when exposure.value_coded = 'Smoking' then exposure.value_coded end) as smoking_exposure,
    max(sound_light_and_touch.value_coded) as sound_light_and_touch_trigger,
    max(case when epilepsy_complications.value_coded = 'Status epilepticus' then epilepsy_complications.value_coded end) as status_epilepticus_complication,
    max(case when epilepsy_complications.value_coded = 'Status epilepticus' then epilepsy_complications.obs_group_id end) as obs_group_epilepticus_complication,
    max(date_of_exposure.value_date) as traditional_medicine_date_of_exposure,
    max(case when exposure.value_coded = 'Traditional medicine' then exposure.value_coded end) as traditional_medicine_exposure,
    max(vdrl.value_coded) as vdrl,
    max(year_of_onset.value_numeric) as year_of_onset
from omrs_encounter e
left join temp_age_of_epilepsy_diagnosis age_of_epilepsy_diagnosis on e.encounter_id = age_of_epilepsy_diagnosis.encounter_id
left join temp_date_of_exposure date_of_exposure on e.encounter_id = date_of_exposure.encounter_id
left join temp_exposure exposure on e.encounter_id = exposure.encounter_id
left join temp_alcohol_trigger alcohol_trigger on e.encounter_id = alcohol_trigger.encounter_id
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_family_history_of_behavioral_problems family_history_of_behavioral_problems on e.encounter_id = family_history_of_behavioral_problems.encounter_id
left join temp_epilepsy_complications epilepsy_complications on e.encounter_id = epilepsy_complications.encounter_id
left join temp_complications_at_birth complications_at_birth on e.encounter_id = complications_at_birth.encounter_id
left join temp_date_of_complication date_of_complication on e.encounter_id = date_of_complication.encounter_id
left join temp_delayed_milestones delayed_milestones on e.encounter_id = delayed_milestones.encounter_id
left join temp_highest_level_of_school_completed highest_level_of_school_completed on e.encounter_id = highest_level_of_school_completed.encounter_id
left join temp_emotional_stress_anger_boredom emotional_stress_anger_boredom on e.encounter_id = emotional_stress_anger_boredom.encounter_id
left join temp_family_history_of_epilepsy family_history_of_epilepsy on e.encounter_id = family_history_of_epilepsy.encounter_id
left join temp_fever_trigger fever_trigger on e.encounter_id = fever_trigger.encounter_id
left join temp_injury_trauma_surgery_of_head injury_trauma_surgery_of_head on e.encounter_id = injury_trauma_surgery_of_head.encounter_id
left join temp_history_of_seizure history_of_seizure on e.encounter_id = history_of_seizure.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_civil_status civil_status on e.encounter_id = civil_status.encounter_id
left join temp_medication_history_text medication_history_text on e.encounter_id = medication_history_text.encounter_id
left join temp_menstruation_trigger menstruation_trigger on e.encounter_id = menstruation_trigger.encounter_id
left join temp_family_history_of_mental_illness family_history_of_mental_illness on e.encounter_id = family_history_of_mental_illness.encounter_id
left join temp_missed_medication_trigger missed_medication_trigger on e.encounter_id = missed_medication_trigger.encounter_id
left join temp_month_of_onset month_of_onset on e.encounter_id = month_of_onset.encounter_id
left join temp_neonatal_infection_cerebral_malaria_and_or neonatal_infection_cerebral_malaria_and_or_meningitis on e.encounter_id = neonatal_infection_cerebral_malaria_and_or_meningitis.encounter_id
left join temp_main_activity main_activity on e.encounter_id = main_activity.encounter_id
left join temp_post_ictal_disorientation post_ictal_disorientation on e.encounter_id = post_ictal_disorientation.encounter_id
left join temp_post_ictal_drowsiness post_ictal_drowsiness on e.encounter_id = post_ictal_drowsiness.encounter_id
left join temp_post_ictal_headache post_ictal_headache on e.encounter_id = post_ictal_headache.encounter_id
left join temp_post_ictal_hyperactivity post_ictal_hyperactivity on e.encounter_id = post_ictal_hyperactivity.encounter_id
left join temp_post_ictal_memory_loss post_ictal_memory_loss on e.encounter_id = post_ictal_memory_loss.encounter_id
left join temp_post_ictal_nausea post_ictal_nausea on e.encounter_id = post_ictal_nausea.encounter_id
left join temp_post_ictal_paralysis post_ictal_paralysis on e.encounter_id = post_ictal_paralysis.encounter_id
left join temp_post_ictal_poor_concentration post_ictal_poor_concentration on e.encounter_id = post_ictal_poor_concentration.encounter_id
left join temp_post_ictal_poor_verbal_or_cognition post_ictal_poor_verbal_or_cognition on e.encounter_id = post_ictal_poor_verbal_or_cognition.encounter_id
left join temp_pre_ictal_warning pre_ictal_warning on e.encounter_id = pre_ictal_warning.encounter_id
left join temp_absence_seizures absence_seizures on e.encounter_id = absence_seizures.encounter_id
left join temp_atonic_seizures atonic_seizures on e.encounter_id = atonic_seizures.encounter_id
left join temp_clonic_seizures clonic_seizures on e.encounter_id = clonic_seizures.encounter_id
left join temp_complex_partial_seizure complex_partial_seizure on e.encounter_id = complex_partial_seizure.encounter_id
left join temp_myoclonic_seizures myoclonic_seizures on e.encounter_id = myoclonic_seizures.encounter_id
left join temp_simple_partial_seizure simple_partial_seizure on e.encounter_id = simple_partial_seizure.encounter_id
left join temp_tonic_seizures tonic_seizures on e.encounter_id = tonic_seizures.encounter_id
left join temp_seizures_grandmal seizures_grandmal on e.encounter_id = seizures_grandmal.encounter_id
left join temp_unclassified_epileptic_seizures unclassified_epileptic_seizures on e.encounter_id = unclassified_epileptic_seizures.encounter_id
left join temp_sleep_deprivation_and_overtired sleep_deprivation_and_overtired on e.encounter_id = sleep_deprivation_and_overtired.encounter_id
left join temp_sound_light_and_touch sound_light_and_touch on e.encounter_id = sound_light_and_touch.encounter_id
left join temp_vdrl vdrl on e.encounter_id = vdrl.encounter_id
left join temp_year_of_onset year_of_onset on e.encounter_id = year_of_onset.encounter_id
where e.encounter_type in ('EPILEPSY_INITIAL')
group by e.patient_id, e.encounter_date, e.location;