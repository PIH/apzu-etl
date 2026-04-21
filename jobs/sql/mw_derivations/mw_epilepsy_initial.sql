-- Derivation script for mw_epilepsy_initial
-- Generated from Pentaho transform: import-into-mw-epilepsy-initial.ktr

drop table if exists mw_epilepsy_initial;
create table mw_epilepsy_initial (
    epilepsy_initial_visit_id int not null auto_increment,
    encounter_id int not null,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    seizure_type_tonic_clonic varchar(255) default null,
    seizure_type_clonic varchar(255) default null,
    seizure_type_simple varchar(255) default null,
    seizure_type_absence varchar(255) default null,
    seizure_type_tonic varchar(255) default null,
    seizure_type_complex varchar(255) default null,
    seizure_type_myoclonic varchar(255) default null,
    seizure_type_atonic varchar(255) default null,
    seizure_type_unclassified varchar(255) default null,
    epilepsy_family_history varchar(255) default null,
    mental_health_family_history varchar(255) default null,
    behavioral_family_history varchar(255) default null,
    hiv_status varchar(255) default null,
    hiv_test_date date default null,
    art_start_date date default null,
    vdrl varchar(255) default null,
    month_of_onset int(11) default null,
    year_of_onset int(11) default null,
    age_at_onset int default null,
    marital_status varchar(255) default null,
    occupation varchar(255) default null,
    education_level varchar(255) default null,
    medication_history varchar(255) default null,
    pre_ictal_warning varchar(255) default null,
    post_ictal_headache varchar(255) default null,
    post_ictal_drowsiness varchar(255) default null,
    post_ictal_poor_concentration varchar(255) default null,
    post_ictal_poor_verbal_or_cognition varchar(255) default null,
    post_ictal_paralysis varchar(255) default null,
    post_ictal_disorientation varchar(255) default null,
    post_ictal_nausea varchar(255) default null,
    post_ictal_memory_loss varchar(255) default null,
    post_ictal_hyperactivity varchar(255) default null,
    head_trauma_injury_surgery varchar(255) default null,
    history_of_seizure varchar(255) default null,
    complications_at_birth varchar(255) default null,
    neonatal_infection_cerebral_malaria_meningitis varchar(255) default null,
    delayed_milestones varchar(255) default null,
    alcohol_trigger varchar(255) default null,
    fever_trigger varchar(255) default null,
    sound_light_and_touch_trigger varchar(255) default null,
    emotional_stress_anger_boredom_trigger varchar(255) default null,
    sleep_deprivation_and_overtired_trigger varchar(255) default null,
    missed_medication_trigger varchar(255) default null,
    menstruation_trigger varchar(255) default null,
    smoking_exposure varchar(255) default null,
    smoking_date_of_exposure date default null,
    alcohol_exposure varchar(255) default null,
    alcohol_date_of_exposure date default null,
    pig_exposure varchar(255) default null,
    pig_date_of_exposure date default null,
    traditional_medicine_exposure varchar(255) default null,
    traditional_medicine_date_of_exposure date default null,
    injury_complication varchar(255) default null,
    date_of_injury_complication date default null,
    burn_complication varchar(255) default null,
    date_of_burn_complication date default null,
    status_epilepticus_complication varchar(255) default null,
    date_of_status_epilepticus_complication date default null,
    psychosis_complication varchar(255) default null,
    date_of_psychosis_complication date default null,
    drug_related_complication varchar(255) default null,
    drug_related_complication_date date default null,
    other_complication varchar(255) default null,
    other_complication_date date default null,
    primary key (epilepsy_initial_visit_id),
    unique key uq_mw_epilepsy_initial_encounter (encounter_id)
) ;

drop temporary table if exists temp_epilepsy_obs;
create temporary table temp_epilepsy_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'EPILEPSY_INITIAL';
alter table temp_epilepsy_obs add index temp_epilepsy_obs_concept_idx (concept);
alter table temp_epilepsy_obs add index temp_epilepsy_obs_encounter_idx (encounter_id);
alter table temp_epilepsy_obs add index temp_epilepsy_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Age of epilepsy diagnosis' then value_numeric end) as age_at_onset,
    max(case when concept = 'Alcohol trigger' then value_coded end) as alcohol_trigger,
    max(case when concept = 'Date antiretrovirals started' then value_date end) as art_start_date,
    max(case when concept = 'Family history of behavioral problems' then value_coded end) as behavioral_family_history,
    max(case when concept = 'Complications at birth' then value_coded end) as complications_at_birth,
    max(case when concept = 'Delayed milestones' then value_coded end) as delayed_milestones,
    max(case when concept = 'Highest level of school completed' then value_coded end) as education_level,
    max(case when concept = 'Emotional stress, anger, boredom' then value_coded end) as emotional_stress_anger_boredom_trigger,
    max(case when concept = 'Family history of epilepsy' then value_coded end) as epilepsy_family_history,
    max(case when concept = 'Fever trigger' then value_coded end) as fever_trigger,
    max(case when concept = 'Injury, trauma, surgery of head' then value_coded end) as head_trauma_injury_surgery,
    max(case when concept = 'History of seizure' then value_coded end) as history_of_seizure,
    max(case when concept = 'HIV status' then value_coded end) as hiv_status,
    max(case when concept = 'HIV test date' then value_date end) as hiv_test_date,
    max(case when concept = 'Civil status' then value_coded end) as marital_status,
    max(case when concept = 'Medication history (text)' then value_text end) as medication_history,
    max(case when concept = 'Menstruation trigger' then value_coded end) as menstruation_trigger,
    max(case when concept = 'Family history of mental illness' then value_coded end) as mental_health_family_history,
    max(case when concept = 'Missed medication trigger' then value_coded end) as missed_medication_trigger,
    max(case when concept = 'Month of onset' then value_numeric end) as month_of_onset,
    max(case when concept = 'Neonatal infection, Cerebral Malaria, and/or Meningitis' then value_coded end) as neonatal_infection_cerebral_malaria_meningitis,
    max(case when concept = 'Main activity' then value_coded end) as occupation,
    max(case when concept = 'Post-ictal disorientation' then value_coded end) as post_ictal_disorientation,
    max(case when concept = 'Post-ictal drowsiness' then value_coded end) as post_ictal_drowsiness,
    max(case when concept = 'Post-ictal headache' then value_coded end) as post_ictal_headache,
    max(case when concept = 'Post-ictal hyperactivity' then value_coded end) as post_ictal_hyperactivity,
    max(case when concept = 'Post-ictal memory loss' then value_coded end) as post_ictal_memory_loss,
    max(case when concept = 'Post-ictal nausea' then value_coded end) as post_ictal_nausea,
    max(case when concept = 'Post-ictal paralysis' then value_coded end) as post_ictal_paralysis,
    max(case when concept = 'Post-ictal poor concentration' then value_coded end) as post_ictal_poor_concentration,
    max(case when concept = 'Post-ictal poor verbal or cognition' then value_coded end) as post_ictal_poor_verbal_or_cognition,
    max(case when concept = 'Pre-ictal warning' then value_coded end) as pre_ictal_warning,
    max(case when concept = 'Vdrl' then value_coded end) as vdrl,
    max(case when concept = 'Year of onset' then value_numeric end) as year_of_onset
from temp_epilepsy_obs
where concept in (
                  'Age of epilepsy diagnosis',
                  'Alcohol trigger',
                  'Date antiretrovirals started',
                  'Family history of behavioral problems',
                  'Complications at birth',
                  'Delayed milestones',
                  'Highest level of school completed',
                  'Emotional stress, anger, boredom',
                  'Family history of epilepsy',
                  'Fever trigger',
                  'Injury, trauma, surgery of head',
                  'History of seizure',
                  'HIV status',
                  'HIV test date',
                  'Civil status',
                  'Medication history (text)',
                  'Menstruation trigger',
                  'Family history of mental illness',
                  'Missed medication trigger',
                  'Month of onset',
                  'Neonatal infection, Cerebral Malaria, and/or Meningitis',
                  'Main activity',
                  'Post-ictal disorientation',
                  'Post-ictal drowsiness',
                  'Post-ictal headache',
                  'Post-ictal hyperactivity',
                  'Post-ictal memory loss',
                  'Post-ictal nausea',
                  'Post-ictal paralysis',
                  'Post-ictal poor concentration',
                  'Post-ictal poor verbal or cognition',
                  'Pre-ictal warning',
                  'Vdrl',
                  'Year of onset'
    )
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

drop temporary table if exists temp_exposure_name_obs;
create temporary table temp_exposure_name_obs as
select encounter_id, obs_group_id, value_coded as exposure_name
from temp_epilepsy_obs
where concept = 'Exposure';
alter table temp_exposure_name_obs add index temp_exposure_name_obs_group_idx (obs_group_id);
alter table temp_exposure_name_obs add index temp_exposure_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_exposure_date_obs;
create temporary table temp_exposure_date_obs as
select encounter_id, obs_group_id, value_date as exposure_date
from temp_epilepsy_obs
where concept = 'Date of exposure';
alter table temp_exposure_date_obs add index temp_exposure_date_obs_group_idx (obs_group_id);
alter table temp_exposure_date_obs add index temp_exposure_date_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_exposures;
create temporary table temp_exposures as
select
    n.encounter_id,
    max(case when n.exposure_name = 'Smoking' then n.exposure_name end) as smoking_exposure,
    max(case when n.exposure_name = 'Smoking' then d.exposure_date end) as smoking_date_of_exposure,
    max(case when n.exposure_name = 'Alcohol' then n.exposure_name end) as alcohol_exposure,
    max(case when n.exposure_name = 'Alcohol' then d.exposure_date end) as alcohol_date_of_exposure,
    max(case when n.exposure_name = 'Pig' then n.exposure_name end) as pig_exposure,
    max(case when n.exposure_name = 'Pig' then d.exposure_date end) as pig_date_of_exposure,
    max(case when n.exposure_name = 'Traditional medicine' then n.exposure_name end) as traditional_medicine_exposure,
    max(case when n.exposure_name = 'Traditional medicine' then d.exposure_date end) as traditional_medicine_date_of_exposure
from temp_exposure_name_obs n
         left join temp_exposure_date_obs d
                   on d.encounter_id = n.encounter_id
                       and d.obs_group_id = n.obs_group_id
group by n.encounter_id;
alter table temp_exposures add index temp_exposures_encounter_idx (encounter_id);

drop temporary table if exists temp_complication_name_obs;
create temporary table temp_complication_name_obs as
select encounter_id, obs_group_id, value_coded as complication_name
from temp_epilepsy_obs
where concept = 'Epilepsy complications';
alter table temp_complication_name_obs add index temp_complication_name_obs_group_idx (obs_group_id);
alter table temp_complication_name_obs add index temp_complication_name_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_complication_date_obs;
create temporary table temp_complication_date_obs as
select encounter_id, obs_group_id, value_date as complication_date
from temp_epilepsy_obs
where concept = 'Date of complication';
alter table temp_complication_date_obs add index temp_complication_date_obs_group_idx (obs_group_id);
alter table temp_complication_date_obs add index temp_complication_date_obs_encounter_idx (encounter_id);

drop temporary table if exists temp_complications;
create temporary table temp_complications as
select
    n.encounter_id,
    max(case when n.complication_name = 'Injury' then n.complication_name end) as injury_complication,
    max(case when n.complication_name = 'Injury' then d.complication_date end) as date_of_injury_complication,
    max(case when n.complication_name = 'Burn' then n.complication_name end) as burn_complication,
    max(case when n.complication_name = 'Burn' then d.complication_date end) as date_of_burn_complication,
    max(case when n.complication_name = 'Status epilepticus' then n.complication_name end) as status_epilepticus_complication,
    max(case when n.complication_name = 'Status epilepticus' then d.complication_date end) as date_of_status_epilepticus_complication,
    max(case when n.complication_name = 'Psychosis' then n.complication_name end) as psychosis_complication,
    max(case when n.complication_name = 'Psychosis' then d.complication_date end) as date_of_psychosis_complication,
    max(case when n.complication_name = 'Side effects of treatment' then n.complication_name end) as drug_related_complication,
    max(case when n.complication_name = 'Side effects of treatment' then d.complication_date end) as drug_related_complication_date,
    max(case when n.complication_name = 'Other' then n.complication_name end) as other_complication,
    max(case when n.complication_name = 'Other' then d.complication_date end) as other_complication_date
from temp_complication_name_obs n
         left join temp_complication_date_obs d
                   on d.encounter_id = n.encounter_id
                       and d.obs_group_id = n.obs_group_id
group by n.encounter_id;
alter table temp_complications add index temp_complications_encounter_idx (encounter_id);

drop temporary table if exists temp_seizure_types;
create temporary table temp_seizure_types as
select
    encounter_id,
    max(case when concept = 'Absence seizures' then value_coded end) as seizure_type_absence,
    max(case when concept = 'Atonic seizures' then value_coded end) as seizure_type_atonic,
    max(case when concept = 'Clonic seizures' then value_coded end) as seizure_type_clonic,
    max(case when concept = 'Complex partial seizure' then value_coded end) as seizure_type_complex,
    max(case when concept = 'Myoclonic seizures' then value_coded end) as seizure_type_myoclonic,
    max(case when concept = 'Simple partial seizure' then value_coded end) as seizure_type_simple,
    max(case when concept = 'Tonic seizures' then value_coded end) as seizure_type_tonic,
    max(case when concept = 'Seizures grandmal' then value_coded end) as seizure_type_tonic_clonic,
    max(case when concept = 'Unclassified epileptic seizures' then value_coded end) as seizure_type_unclassified,
    max(case when concept = 'Sleep deprivation and overtired' then value_coded end) as sleep_deprivation_and_overtired_trigger,
    max(case when concept = 'Sound, light, and touch' then value_coded end) as sound_light_and_touch_trigger
from temp_epilepsy_obs
where concept in (
    'Absence seizures',
    'Atonic seizures',
    'Clonic seizures',
    'Complex partial seizure',
    'Myoclonic seizures',
    'Simple partial seizure',
    'Tonic seizures',
    'Seizures grandmal',
    'Unclassified epileptic seizures',
    'Sleep deprivation and overtired',
    'Sound, light, and touch'
    )
group by encounter_id;
alter table temp_seizure_types add index temp_seizure_types_encounter_idx (encounter_id);

insert into mw_epilepsy_initial (encounter_id, patient_id, visit_date, location)
select
    e.encounter_id,
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location
from omrs_encounter e
where e.encounter_type in ('EPILEPSY_INITIAL')
group by e.encounter_id, e.patient_id, e.encounter_date, e.location;

update mw_epilepsy_initial m
    left join temp_single_values s on s.encounter_id = m.encounter_id
set
    m.age_at_onset = s.age_at_onset,
    m.alcohol_trigger = s.alcohol_trigger,
    m.art_start_date = s.art_start_date,
    m.behavioral_family_history = s.behavioral_family_history,
    m.complications_at_birth = s.complications_at_birth,
    m.delayed_milestones = s.delayed_milestones,
    m.education_level = s.education_level,
    m.emotional_stress_anger_boredom_trigger = s.emotional_stress_anger_boredom_trigger,
    m.epilepsy_family_history = s.epilepsy_family_history,
    m.fever_trigger = s.fever_trigger,
    m.head_trauma_injury_surgery = s.head_trauma_injury_surgery,
    m.history_of_seizure = s.history_of_seizure,
    m.hiv_status = s.hiv_status,
    m.hiv_test_date = s.hiv_test_date,
    m.marital_status = s.marital_status,
    m.medication_history = s.medication_history,
    m.menstruation_trigger = s.menstruation_trigger,
    m.mental_health_family_history = s.mental_health_family_history,
    m.missed_medication_trigger = s.missed_medication_trigger,
    m.month_of_onset = s.month_of_onset,
    m.neonatal_infection_cerebral_malaria_meningitis = s.neonatal_infection_cerebral_malaria_meningitis,
    m.occupation = s.occupation,
    m.post_ictal_disorientation = s.post_ictal_disorientation,
    m.post_ictal_drowsiness = s.post_ictal_drowsiness,
    m.post_ictal_headache = s.post_ictal_headache,
    m.post_ictal_hyperactivity = s.post_ictal_hyperactivity,
    m.post_ictal_memory_loss = s.post_ictal_memory_loss,
    m.post_ictal_nausea = s.post_ictal_nausea,
    m.post_ictal_paralysis = s.post_ictal_paralysis,
    m.post_ictal_poor_concentration = s.post_ictal_poor_concentration,
    m.post_ictal_poor_verbal_or_cognition = s.post_ictal_poor_verbal_or_cognition,
    m.pre_ictal_warning = s.pre_ictal_warning,
    m.vdrl = s.vdrl,
    m.year_of_onset = s.year_of_onset;

update mw_epilepsy_initial m
    left join temp_exposures e on e.encounter_id = m.encounter_id
set
    m.smoking_exposure = e.smoking_exposure,
    m.smoking_date_of_exposure = e.smoking_date_of_exposure,
    m.alcohol_exposure = e.alcohol_exposure,
    m.alcohol_date_of_exposure = e.alcohol_date_of_exposure,
    m.pig_exposure = e.pig_exposure,
    m.pig_date_of_exposure = e.pig_date_of_exposure,
    m.traditional_medicine_exposure = e.traditional_medicine_exposure,
    m.traditional_medicine_date_of_exposure = e.traditional_medicine_date_of_exposure;

update mw_epilepsy_initial m
    left join temp_complications c on c.encounter_id = m.encounter_id
set
    m.injury_complication = c.injury_complication,
    m.date_of_injury_complication = c.date_of_injury_complication,
    m.burn_complication = c.burn_complication,
    m.date_of_burn_complication = c.date_of_burn_complication,
    m.status_epilepticus_complication = c.status_epilepticus_complication,
    m.date_of_status_epilepticus_complication = c.date_of_status_epilepticus_complication,
    m.psychosis_complication = c.psychosis_complication,
    m.date_of_psychosis_complication = c.date_of_psychosis_complication,
    m.drug_related_complication = c.drug_related_complication,
    m.drug_related_complication_date = c.drug_related_complication_date,
    m.other_complication = c.other_complication,
    m.other_complication_date = c.other_complication_date;

update mw_epilepsy_initial m
    left join temp_seizure_types t on t.encounter_id = m.encounter_id
set
    m.seizure_type_absence = t.seizure_type_absence,
    m.seizure_type_atonic = t.seizure_type_atonic,
    m.seizure_type_clonic = t.seizure_type_clonic,
    m.seizure_type_complex = t.seizure_type_complex,
    m.seizure_type_myoclonic = t.seizure_type_myoclonic,
    m.seizure_type_simple = t.seizure_type_simple,
    m.seizure_type_tonic = t.seizure_type_tonic,
    m.seizure_type_tonic_clonic = t.seizure_type_tonic_clonic,
    m.seizure_type_unclassified = t.seizure_type_unclassified,
    m.sleep_deprivation_and_overtired_trigger = t.sleep_deprivation_and_overtired_trigger,
    m.sound_light_and_touch_trigger = t.sound_light_and_touch_trigger;

drop temporary table if exists temp_epilepsy_obs;
drop temporary table if exists temp_single_values;
drop temporary table if exists temp_exposure_name_obs;
drop temporary table if exists temp_exposure_date_obs;
drop temporary table if exists temp_exposures;
drop temporary table if exists temp_complication_name_obs;
drop temporary table if exists temp_complication_date_obs;
drop temporary table if exists temp_complications;
drop temporary table if exists temp_seizure_types;