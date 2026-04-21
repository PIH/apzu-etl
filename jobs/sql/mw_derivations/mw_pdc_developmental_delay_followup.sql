-- Derivation script for mw_pdc_developmental_delay_followup
-- Generated from Pentaho transform: import-into-mw-pdc-developmental-delay-followup.ktr

drop table if exists mw_pdc_developmental_delay_followup;
create table mw_pdc_developmental_delay_followup (
  pdc_developmenta_delay_visit_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  height				int default null,
  weight 				int default null,
  muac 					int default null,
  weight_against_age			int default null,
  weight_against_height			int default null,
  malnutrition				varchar(255) default null,
  mdat					varchar(255) default null,
  tone_normal				varchar(255) default null,
  tone_hypo				varchar(255) default null,
  tone_hyper				varchar(255) default null,
  feeding_sucking			varchar(255) default null,
  feeding_cup				varchar(255) default null,
  feeding_tube				varchar(255) default null,
  signs_of_cerebral_palsy		varchar(255) default null,
  under_mental_health_care_program	varchar(255) default null,
  anticonvulsant			varchar(255) default null,
  dose_and_drug				varchar(255) default null,
  dose_adjusted				varchar(255) default null,
  continue_followup			varchar(255) default null,
  feeding_counselling			varchar(255) default null,
  group_counselling_and_play_therapy	varchar(255) default null,
  referred_to_poser			varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  next_appointment_date 		date default null,
  primary key (pdc_developmenta_delay_visit_id)
) ;

drop temporary table if exists temp_pdc_dev_delay_obs;
create temporary table temp_pdc_dev_delay_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'PDC_DEVELOPMENTAL_DELAY_FOLLOWUP';
alter table temp_pdc_dev_delay_obs add index temp_pdc_dev_delay_obs_concept_idx (concept);
alter table temp_pdc_dev_delay_obs add index temp_pdc_dev_delay_obs_encounter_idx (encounter_id);
alter table temp_pdc_dev_delay_obs add index temp_pdc_dev_delay_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Adjust dose'                                                       then value_coded   end) as dose_adjusted,
    max(case when concept = 'Anticonvulsant'                                                    then value_coded   end) as anticonvulsant,
    max(case when concept = 'Appointment date'                                                  then value_date    end) as next_appointment_date,
    max(case when concept = 'Breast feeding'                                                    then value_coded   end) as feeding_sucking,
    max(case when concept = 'Continue followup'                                                 then value_coded   end) as continue_followup,
    max(case when concept = 'Cup-feeding'                                                       then value_coded   end) as feeding_cup,
    max(case when concept = 'Food supplement'                                                   then value_coded   end) as feeding_counselling,
    max(case when concept = 'Height (cm)'                                                       then value_numeric end) as height,
    max(case when concept = 'Hyper'                                                             then value_coded   end) as tone_hyper,
    max(case when concept = 'Hypo'                                                              then value_coded   end) as tone_hypo,
    max(case when concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)'     then value_coded   end) as mdat,
    max(case when concept = 'Medications dispensed'                                             then value_text    end) as dose_and_drug,
    max(case when concept = 'Mental health referral'                                            then value_coded   end) as under_mental_health_care_program,
    max(case when concept = 'Middle upper arm circumference (cm)'                               then value_numeric end) as muac,
    max(case when concept = 'Normal(Generic)'                                                   then value_coded   end) as tone_normal,
    max(case when concept = 'Numeric value or result'                                           then value_numeric end) as weight_against_age,
    max(case when concept = 'Orogastric tube'                                                   then value_coded   end) as feeding_tube,
    max(case when concept = 'Other non-coded (text)'                                            then value_text    end) as referred_out_specify,
    max(case when concept = 'Play therapy'                                                      then value_coded   end) as group_counselling_and_play_therapy,
    max(case when concept = 'Poor Growth'                                                       then value_coded   end) as referred_to_poser,
    max(case when concept = 'Referred out'                                                      then value_coded   end) as referred_out,
    max(case when concept = 'Signs of Cerebral Palsy'                                           then value_coded   end) as signs_of_cerebral_palsy,
    max(case when concept = 'Wasting/malnutrition'                                              then value_coded   end) as malnutrition,
    max(case when concept = 'Weight (kg)'                                                       then value_numeric end) as weight
from temp_pdc_dev_delay_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_pdc_developmental_delay_followup (patient_id, visit_date, location, anticonvulsant, continue_followup, dose_adjusted, dose_and_drug, feeding_cup, feeding_sucking, feeding_tube, feeding_counselling, height, if_referred_out, if_referred_out_specify, muac, mdat, malnutrition, next_appointment_date, group_counselling_and_play_therapy, referred_out, referred_out_specify, referred_to_poser, signs_of_cerebral_palsy, tone_hyper, tone_hypo, tone_normal, under_mental_health_care_program, weight, weight_against_age, weight_against_height)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.anticonvulsant,
    sv.continue_followup,
    sv.dose_adjusted,
    sv.dose_and_drug,
    sv.feeding_cup,
    sv.feeding_sucking,
    sv.feeding_tube,
    sv.feeding_counselling,
    sv.height,
    sv.referred_out,
    sv.referred_out_specify,
    sv.muac,
    sv.mdat,
    sv.malnutrition,
    sv.next_appointment_date,
    sv.group_counselling_and_play_therapy,
    sv.referred_out,
    sv.referred_out_specify,
    sv.referred_to_poser,
    sv.signs_of_cerebral_palsy,
    sv.tone_hyper,
    sv.tone_hypo,
    sv.tone_normal,
    sv.under_mental_health_care_program,
    sv.weight,
    sv.weight_against_age,
    sv.weight_against_age
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_DEVELOPMENTAL_DELAY_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_pdc_dev_delay_obs;
drop temporary table if exists temp_single_values;
