-- Derivation script for mw_pdc_other_diagnosis_followup
-- Generated from Pentaho transform: import-into-mw-pdc-other-diagnosis-followup.ktr

drop table if exists mw_pdc_other_diagnosis_followup;
create table mw_pdc_other_diagnosis_followup (
  pdc_other_diagnosis_visit_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  age_adjusted				int default null,
  age_non_adjusted			int default null,
  weight 				int default null,
  height				int default null,
  muac 					int default null,
  weight_against_age			int default null,
  weight_against_height			int default null,
  complications_since_last_visit	varchar(255) default null,
  malnutrition				varchar(255) default null,
  head_circumference			int default null,
  convulsions_any_since_last_visit	varchar(255) default null,
  anticonvulsant			varchar(255) default null,
  drug_and_dose				varchar(255) default null,
  adjust_dose				varchar(255) default null,
  poor_suck				varchar(255) default null,
  refs_to_feed				varchar(255) default null,
  less_feed_concerns			varchar(255) default null,
  individual_counseling			varchar(255) default null,
  feeding_counseling			varchar(255) default null,
  group_counselling			varchar(255) default null,
  play_therapy				varchar(255) default null,
  continue_followup			varchar(255) default null,
  physiotherapy				varchar(255) default null,
  poser					varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  mdat					varchar(255) default null,
  clinical_plan			varchar(255) default null,
  next_appointment_date 		date default null,
  primary key (pdc_other_diagnosis_visit_id)
) ;

drop temporary table if exists temp_pdc_other_diagnosis_obs;
create temporary table temp_pdc_other_diagnosis_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'PDC_OTHER_DIAGNOSIS_FOLLOWUP';
alter table temp_pdc_other_diagnosis_obs add index temp_pdc_other_diagnosis_obs_concept_idx (concept);
alter table temp_pdc_other_diagnosis_obs add index temp_pdc_other_diagnosis_obs_encounter_idx (encounter_id);
alter table temp_pdc_other_diagnosis_obs add index temp_pdc_other_diagnosis_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Adjust dose'                                                       then value_coded   end) as adjust_dose,
    max(case when concept = 'Age of child'                                                      then value_numeric end) as age_adjusted,
    max(case when concept = 'Age'                                                               then value_numeric end) as age_non_adjusted,
    max(case when concept = 'Anticonvulsant'                                                    then value_coded   end) as anticonvulsant,
    max(case when concept = 'Any since last visit'                                              then value_coded   end) as convulsions_any_since_last_visit,
    max(case when concept = 'Complications since last visit'                                    then value_coded   end) as complications_since_last_visit,
    max(case when concept = 'Continue followup'                                                 then value_coded   end) as continue_followup,
    max(case when concept = 'Medications dispensed'                                             then value_text    end) as drug_and_dose,
    max(case when concept = 'Food supplement'                                                   then value_coded   end) as feeding_counseling,
    max(case when concept = 'Group Counselling'                                                 then value_coded   end) as group_counselling,
    max(case when concept = 'Head circumference'                                                then value_numeric end) as head_circumference,
    max(case when concept = 'Height (cm)'                                                       then value_numeric end) as height,
    max(case when concept = 'Referred out'                                                      then value_coded   end) as referred_out,
    max(case when concept = 'Other non-coded (text)'                                            then value_text    end) as referred_out_specify,
    max(case when concept = 'Counseling'                                                        then value_coded   end) as individual_counseling,
    max(case when concept = 'Less feed'                                                         then value_coded   end) as less_feed_concerns,
    max(case when concept = 'Middle upper arm circumference (cm)'                               then value_numeric end) as muac,
    max(case when concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)'     then value_coded   end) as mdat,
    max(case when concept = 'Wasting/malnutrition'                                              then value_coded   end) as malnutrition,
    max(case when concept = 'Appointment date'                                                  then value_date    end) as next_appointment_date,
    max(case when concept = 'Poor Growth'                                                       then value_coded   end) as poser,
    max(case when concept = 'Physiotherapy'                                                     then value_coded   end) as physiotherapy,
    max(case when concept = 'Clinical impression comments'                                      then value_text    end) as clinical_plan,
    max(case when concept = 'Play therapy'                                                      then value_coded   end) as play_therapy,
    max(case when concept = 'Poor Suck'                                                         then value_coded   end) as poor_suck,
    max(case when concept = 'Refs to feed'                                                      then value_coded   end) as refs_to_feed,
    max(case when concept = 'Weight (kg)'                                                       then value_numeric end) as weight,
    max(case when concept = 'Numeric value or result'                                           then value_numeric end) as weight_against_age
from temp_pdc_other_diagnosis_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_pdc_other_diagnosis_followup (patient_id, visit_date, location, adjust_dose, age_adjusted, age_non_adjusted, anticonvulsant, convulsions_any_since_last_visit, complications_since_last_visit, continue_followup, drug_and_dose, feeding_counseling, group_counselling, head_circumference, height, if_referred_out, if_referred_out_specify, individual_counseling, less_feed_concerns, muac, mdat, malnutrition, next_appointment_date, poser, physiotherapy, clinical_plan, play_therapy, poor_suck, referred_out, referred_out_specify, refs_to_feed, weight, weight_against_age, weight_against_height)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.adjust_dose,
    sv.age_adjusted,
    sv.age_non_adjusted,
    sv.anticonvulsant,
    sv.convulsions_any_since_last_visit,
    sv.complications_since_last_visit,
    sv.continue_followup,
    sv.drug_and_dose,
    sv.feeding_counseling,
    sv.group_counselling,
    sv.head_circumference,
    sv.height,
    sv.referred_out,
    sv.referred_out_specify,
    sv.individual_counseling,
    sv.less_feed_concerns,
    sv.muac,
    sv.mdat,
    sv.malnutrition,
    sv.next_appointment_date,
    sv.poser,
    sv.physiotherapy,
    sv.clinical_plan,
    sv.play_therapy,
    sv.poor_suck,
    sv.referred_out,
    sv.referred_out_specify,
    sv.refs_to_feed,
    sv.weight,
    sv.weight_against_age,
    sv.weight_against_age
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_OTHER_DIAGNOSIS_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_pdc_other_diagnosis_obs;
drop temporary table if exists temp_single_values;
