-- Derivation script for mw_pdc_cleft_lip_palate_followup
-- Generated from Pentaho transform: import-into-mw-pdc-cleft-lip-palate-followup.ktr

drop table if exists mw_pdc_cleft_lip_palate_followup;
create table mw_pdc_cleft_lip_palate_followup (
  pdc_cleft_lip_palate_visit_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  weight 				int default null,
  height				int default null,
  muac 				int default null,
  weight_for_age			int default null,
  height_for_age			int default null,
  malnutrition				varchar(255) default null,
  feeding_problems			varchar(255) default null,
  difficult_breathing			varchar(255) default null,
  heart_murmur				varchar(255) default null,
  ear_pain				varchar(255) default null,
  ear_discharge			varchar(255) default null,
  other			        varchar(255) default null,
  surgery_scheduled			varchar(255) default null,
  surgery_date				date default null,
  continue_followup			varchar(255) default null,
  group_therapy			varchar(255) default null,
  food_supplement			varchar(255) default null,
  individual_counselling		varchar(255) default null,
  feeding_counseling			varchar(255) default null,
  mdat					varchar(255) default null,
  poser				varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  clinical_plan			varchar(255) default null,
  next_appointment_date		date default null,
  primary key (pdc_cleft_lip_palate_visit_id)
) ;

drop temporary table if exists temp_pdc_cleft_obs;
create temporary table temp_pdc_cleft_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'PDC_CLEFT_CLIP_PALLET_FOLLOWUP';
alter table temp_pdc_cleft_obs add index temp_pdc_cleft_obs_concept_idx (concept);
alter table temp_pdc_cleft_obs add index temp_pdc_cleft_obs_encounter_idx (encounter_id);
alter table temp_pdc_cleft_obs add index temp_pdc_cleft_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Appointment date'                                              then value_date    end) as next_appointment_date,
    max(case when concept = 'Clinical impression comments'                                  then value_text    end) as clinical_plan,
    max(case when concept = 'Continue followup'                                             then value_coded   end) as continue_followup,
    max(case when concept = 'Counseling'                                                    then value_coded   end) as feeding_counseling,
    max(case when concept = 'Date of surgery'                                               then value_date    end) as surgery_date,
    max(case when concept = 'Difficult breathing'                                           then value_coded   end) as difficult_breathing,
    max(case when concept = 'Discharge'                                                     then value_coded   end) as ear_discharge,
    max(case when concept = 'Feeding issues'                                                then value_coded   end) as feeding_problems,
    max(case when concept = 'Food supplement'                                               then value_coded   end) as food_supplement,
    max(case when concept = 'Group Counselling'                                             then value_coded   end) as individual_counselling,
    max(case when concept = 'Heart murmur'                                                  then value_coded   end) as heart_murmur,
    max(case when concept = 'Height (cm)'                                                   then value_numeric end) as height,
    max(case when concept = 'Height for age percent of median'                              then value_numeric end) as height_for_age,
    max(case when concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' then value_coded   end) as mdat,
    max(case when concept = 'Middle upper arm circumference (cm)'                           then value_numeric end) as muac,
    max(case when concept = 'Other assessments'                                             then value_coded   end) as other,
    max(case when concept = 'Other non-coded (text)'                                        then value_text    end) as referred_out_specify,
    max(case when concept = 'Pain'                                                          then value_coded   end) as ear_pain,
    max(case when concept = 'Poser Support'                                                 then value_coded   end) as poser,
    max(case when concept = 'Referred out'                                                  then value_coded   end) as referred_out,
    max(case when concept = 'Scheduled'                                                     then value_coded   end) as surgery_scheduled,
    max(case when concept = 'Support group'                                                 then value_coded   end) as group_therapy,
    max(case when concept = 'Wasting/malnutrition'                                          then value_coded   end) as malnutrition,
    max(case when concept = 'Weight (kg)'                                                   then value_numeric end) as weight,
    max(case when concept = 'Weight for age percent of median'                              then value_numeric end) as weight_for_age
from temp_pdc_cleft_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_pdc_cleft_lip_palate_followup (patient_id, visit_date, location, continue_followup, difficult_breathing, ear_discharge, ear_pain, feeding_counseling, feeding_problems, food_supplement, group_therapy, heart_murmur, height, height_for_age, if_referred_out, if_referred_out_specify, individual_counselling, muac, mdat, malnutrition, next_appointment_date, other, poser, clinical_plan, referred_out, referred_out_specify, surgery_date, surgery_scheduled, weight, weight_for_age)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sv.continue_followup) as continue_followup,
    max(sv.difficult_breathing) as difficult_breathing,
    max(sv.ear_discharge) as ear_discharge,
    max(sv.ear_pain) as ear_pain,
    max(sv.feeding_counseling) as feeding_counseling,
    max(sv.feeding_problems) as feeding_problems,
    max(sv.food_supplement) as food_supplement,
    max(sv.group_therapy) as group_therapy,
    max(sv.heart_murmur) as heart_murmur,
    max(sv.height) as height,
    max(sv.height_for_age) as height_for_age,
    max(sv.referred_out) as referred_out,
    max(sv.referred_out_specify) as referred_out_specify,
    max(sv.individual_counselling) as individual_counselling,
    max(sv.muac) as muac,
    max(sv.mdat) as mdat,
    max(sv.malnutrition) as malnutrition,
    max(sv.next_appointment_date) as next_appointment_date,
    max(sv.other) as other,
    max(sv.poser) as poser,
    max(sv.clinical_plan) as clinical_plan,
    max(sv.referred_out) as referred_out,
    max(sv.referred_out_specify) as referred_out_specify,
    max(sv.surgery_date) as surgery_date,
    max(sv.surgery_scheduled) as surgery_scheduled,
    max(sv.weight) as weight,
    max(sv.weight_for_age) as weight_for_age
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_CLEFT_CLIP_PALLET_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_pdc_cleft_obs;
drop temporary table if exists temp_single_values;
