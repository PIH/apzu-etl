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

drop temporary table if exists temp_adjust_dose;
create temporary table temp_adjust_dose as select encounter_id, value_coded from omrs_obs where concept = 'Adjust dose';
alter table temp_adjust_dose add index temp_adjust_dose_encounter_idx (encounter_id);

drop temporary table if exists temp_age_of_child;
create temporary table temp_age_of_child as select encounter_id, value_numeric from omrs_obs where concept = 'Age of child';
alter table temp_age_of_child add index temp_age_of_child_encounter_idx (encounter_id);

drop temporary table if exists temp_age;
create temporary table temp_age as select encounter_id, value_numeric from omrs_obs where concept = 'Age';
alter table temp_age add index temp_age_encounter_idx (encounter_id);

drop temporary table if exists temp_anticonvulsant;
create temporary table temp_anticonvulsant as select encounter_id, value_coded from omrs_obs where concept = 'Anticonvulsant';
alter table temp_anticonvulsant add index temp_anticonvulsant_encounter_idx (encounter_id);

drop temporary table if exists temp_any_since_last_visit;
create temporary table temp_any_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Any since last visit';
alter table temp_any_since_last_visit add index temp_any_since_last_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_complications_since_last_visit;
create temporary table temp_complications_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Complications since last visit';
alter table temp_complications_since_last_visit add index temp_complications_since_last_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_continue_followup;
create temporary table temp_continue_followup as select encounter_id, value_coded from omrs_obs where concept = 'Continue followup';
alter table temp_continue_followup add index temp_continue_followup_encounter_idx (encounter_id);

drop temporary table if exists temp_medications_dispensed;
create temporary table temp_medications_dispensed as select encounter_id, value_text from omrs_obs where concept = 'Medications dispensed';
alter table temp_medications_dispensed add index temp_medications_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_food_supplement;
create temporary table temp_food_supplement as select encounter_id, value_coded from omrs_obs where concept = 'Food supplement';
alter table temp_food_supplement add index temp_food_supplement_encounter_idx (encounter_id);

drop temporary table if exists temp_group_counselling;
create temporary table temp_group_counselling as select encounter_id, value_coded from omrs_obs where concept = 'Group Counselling';
alter table temp_group_counselling add index temp_group_counselling_encounter_idx (encounter_id);

drop temporary table if exists temp_head_circumference;
create temporary table temp_head_circumference as select encounter_id, value_numeric from omrs_obs where concept = 'Head circumference';
alter table temp_head_circumference add index temp_head_circumference_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_referred_out;
create temporary table temp_referred_out as select encounter_id, value_coded from omrs_obs where concept = 'Referred out';
alter table temp_referred_out add index temp_referred_out_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

drop temporary table if exists temp_counseling;
create temporary table temp_counseling as select encounter_id, value_coded from omrs_obs where concept = 'Counseling';
alter table temp_counseling add index temp_counseling_encounter_idx (encounter_id);

drop temporary table if exists temp_less_feed;
create temporary table temp_less_feed as select encounter_id, value_coded from omrs_obs where concept = 'Less feed';
alter table temp_less_feed add index temp_less_feed_encounter_idx (encounter_id);

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_malawi_developmental_assessment_tool_summary_normal_coded;
create temporary table temp_malawi_developmental_assessment_tool_summary_normal_coded as select encounter_id, value_coded from omrs_obs where concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)';
alter table temp_malawi_developmental_assessment_tool_summary_normal_coded add index temp_malawi_developmental_assessment_tool_summary_normal_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_wasting_malnutrition;
create temporary table temp_wasting_malnutrition as select encounter_id, value_coded from omrs_obs where concept = 'Wasting/malnutrition';
alter table temp_wasting_malnutrition add index temp_wasting_malnutrition_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_poor_growth;
create temporary table temp_poor_growth as select encounter_id, value_coded from omrs_obs where concept = 'Poor Growth';
alter table temp_poor_growth add index temp_poor_growth_encounter_idx (encounter_id);

drop temporary table if exists temp_physiotherapy;
create temporary table temp_physiotherapy as select encounter_id, value_coded from omrs_obs where concept = 'Physiotherapy';
alter table temp_physiotherapy add index temp_physiotherapy_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_play_therapy;
create temporary table temp_play_therapy as select encounter_id, value_coded from omrs_obs where concept = 'Play therapy';
alter table temp_play_therapy add index temp_play_therapy_encounter_idx (encounter_id);

drop temporary table if exists temp_poor_suck;
create temporary table temp_poor_suck as select encounter_id, value_coded from omrs_obs where concept = 'Poor Suck';
alter table temp_poor_suck add index temp_poor_suck_encounter_idx (encounter_id);

drop temporary table if exists temp_refs_to_feed;
create temporary table temp_refs_to_feed as select encounter_id, value_coded from omrs_obs where concept = 'Refs to feed';
alter table temp_refs_to_feed add index temp_refs_to_feed_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_numeric_value_or_result;
create temporary table temp_numeric_value_or_result as select encounter_id, value_numeric from omrs_obs where concept = 'Numeric value or result';
alter table temp_numeric_value_or_result add index temp_numeric_value_or_result_encounter_idx (encounter_id);

insert into mw_pdc_other_diagnosis_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(adjust_dose.value_coded) as adjust_dose,
    max(age_of_child.value_numeric) as age_adjusted,
    max(age.value_numeric) as age_non_adjusted,
    max(anticonvulsant.value_coded) as anticonvulsant,
    max(any_since_last_visit.value_coded) as convulsions_any_since_last_visit,
    max(complications_since_last_visit.value_coded) as complications_since_last_visit,
    max(continue_followup.value_coded) as continue_followup,
    max(medications_dispensed.value_text) as drug_and_dose,
    max(food_supplement.value_coded) as feeding_Counseling,
    max(group_counselling.value_coded) as group_counselling,
    max(head_circumference.value_numeric) as head_circumference,
    max(height_cm.value_numeric) as height,
    max(referred_out.value_coded) as if_referred_out,
    max(other_non_coded_text.value_text) as if_referred_out_specify,
    max(counseling.value_coded) as individual_counseling,
    max(less_feed.value_coded) as less_feed_concerns,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(malawi_developmental_assessment_tool_summary_normal_coded.value_coded) as mdat,
    max(wasting_malnutrition.value_coded) as malnutrition,
    max(appointment_date.value_date) as next_appointment_date,
    max(poor_growth.value_coded) as poser,
    max(physiotherapy.value_coded) as physiotherapy,
    max(clinical_impression_comments.value_text) as clinical_plan,
    max(play_therapy.value_coded) as play_therapy,
    max(poor_suck.value_coded) as poor_suck,
    max(referred_out.value_coded) as referred_out,
    max(other_non_coded_text.value_text) as referred_out_specify,
    max(refs_to_feed.value_coded) as refs_to_feed,
    max(weight_kg.value_numeric) as weight,
    max(numeric_value_or_result.value_numeric) as weight_against_age,
    max(numeric_value_or_result.value_numeric) as weight_against_height
from omrs_encounter e
left join temp_adjust_dose adjust_dose on e.encounter_id = adjust_dose.encounter_id
left join temp_age_of_child age_of_child on e.encounter_id = age_of_child.encounter_id
left join temp_age age on e.encounter_id = age.encounter_id
left join temp_anticonvulsant anticonvulsant on e.encounter_id = anticonvulsant.encounter_id
left join temp_any_since_last_visit any_since_last_visit on e.encounter_id = any_since_last_visit.encounter_id
left join temp_complications_since_last_visit complications_since_last_visit on e.encounter_id = complications_since_last_visit.encounter_id
left join temp_continue_followup continue_followup on e.encounter_id = continue_followup.encounter_id
left join temp_medications_dispensed medications_dispensed on e.encounter_id = medications_dispensed.encounter_id
left join temp_food_supplement food_supplement on e.encounter_id = food_supplement.encounter_id
left join temp_group_counselling group_counselling on e.encounter_id = group_counselling.encounter_id
left join temp_head_circumference head_circumference on e.encounter_id = head_circumference.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_referred_out referred_out on e.encounter_id = referred_out.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_counseling counseling on e.encounter_id = counseling.encounter_id
left join temp_less_feed less_feed on e.encounter_id = less_feed.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_malawi_developmental_assessment_tool_summary_normal_coded malawi_developmental_assessment_tool_summary_normal_coded on e.encounter_id = malawi_developmental_assessment_tool_summary_normal_coded.encounter_id
left join temp_wasting_malnutrition wasting_malnutrition on e.encounter_id = wasting_malnutrition.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_poor_growth poor_growth on e.encounter_id = poor_growth.encounter_id
left join temp_physiotherapy physiotherapy on e.encounter_id = physiotherapy.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_play_therapy play_therapy on e.encounter_id = play_therapy.encounter_id
left join temp_poor_suck poor_suck on e.encounter_id = poor_suck.encounter_id
left join temp_refs_to_feed refs_to_feed on e.encounter_id = refs_to_feed.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_numeric_value_or_result numeric_value_or_result on e.encounter_id = numeric_value_or_result.encounter_id
where e.encounter_type in ('PDC_OTHER_DIAGNOSIS_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;