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

drop temporary table if exists temp_continue_followup;
create temporary table temp_continue_followup as select encounter_id, value_coded from omrs_obs where concept = 'Continue followup';
alter table temp_continue_followup add index temp_continue_followup_encounter_idx (encounter_id);

drop temporary table if exists temp_difficult_breathing;
create temporary table temp_difficult_breathing as select encounter_id, value_coded from omrs_obs where concept = 'Difficult breathing';
alter table temp_difficult_breathing add index temp_difficult_breathing_encounter_idx (encounter_id);

drop temporary table if exists temp_discharge;
create temporary table temp_discharge as select encounter_id, value_coded from omrs_obs where concept = 'Discharge';
alter table temp_discharge add index temp_discharge_encounter_idx (encounter_id);

drop temporary table if exists temp_pain;
create temporary table temp_pain as select encounter_id, value_coded from omrs_obs where concept = 'Pain';
alter table temp_pain add index temp_pain_encounter_idx (encounter_id);

drop temporary table if exists temp_counseling;
create temporary table temp_counseling as select encounter_id, value_coded from omrs_obs where concept = 'Counseling';
alter table temp_counseling add index temp_counseling_encounter_idx (encounter_id);

drop temporary table if exists temp_feeding_issues;
create temporary table temp_feeding_issues as select encounter_id, value_coded from omrs_obs where concept = 'Feeding issues';
alter table temp_feeding_issues add index temp_feeding_issues_encounter_idx (encounter_id);

drop temporary table if exists temp_food_supplement;
create temporary table temp_food_supplement as select encounter_id, value_coded from omrs_obs where concept = 'Food supplement';
alter table temp_food_supplement add index temp_food_supplement_encounter_idx (encounter_id);

drop temporary table if exists temp_support_group;
create temporary table temp_support_group as select encounter_id, value_coded from omrs_obs where concept = 'Support group';
alter table temp_support_group add index temp_support_group_encounter_idx (encounter_id);

drop temporary table if exists temp_heart_murmur;
create temporary table temp_heart_murmur as select encounter_id, value_coded from omrs_obs where concept = 'Heart murmur';
alter table temp_heart_murmur add index temp_heart_murmur_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_height_for_age_percent_of_median;
create temporary table temp_height_for_age_percent_of_median as select encounter_id, value_numeric from omrs_obs where concept = 'Height for age percent of median';
alter table temp_height_for_age_percent_of_median add index temp_height_for_age_percent_of_median_encounter_idx (encounter_id);

drop temporary table if exists temp_referred_out;
create temporary table temp_referred_out as select encounter_id, value_coded from omrs_obs where concept = 'Referred out';
alter table temp_referred_out add index temp_referred_out_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

drop temporary table if exists temp_group_counselling;
create temporary table temp_group_counselling as select encounter_id, value_coded from omrs_obs where concept = 'Group Counselling';
alter table temp_group_counselling add index temp_group_counselling_encounter_idx (encounter_id);

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

drop temporary table if exists temp_other_assessments;
create temporary table temp_other_assessments as select encounter_id, value_coded from omrs_obs where concept = 'Other assessments';
alter table temp_other_assessments add index temp_other_assessments_encounter_idx (encounter_id);

drop temporary table if exists temp_poser_support;
create temporary table temp_poser_support as select encounter_id, value_coded from omrs_obs where concept = 'Poser Support';
alter table temp_poser_support add index temp_poser_support_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_surgery;
create temporary table temp_date_of_surgery as select encounter_id, value_date from omrs_obs where concept = 'Date of surgery';
alter table temp_date_of_surgery add index temp_date_of_surgery_encounter_idx (encounter_id);

drop temporary table if exists temp_scheduled;
create temporary table temp_scheduled as select encounter_id, value_coded from omrs_obs where concept = 'Scheduled';
alter table temp_scheduled add index temp_scheduled_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_for_age_percent_of_median;
create temporary table temp_weight_for_age_percent_of_median as select encounter_id, value_numeric from omrs_obs where concept = 'Weight for age percent of median';
alter table temp_weight_for_age_percent_of_median add index temp_weight_for_age_percent_of_median_encounter_idx (encounter_id);

insert into mw_pdc_cleft_lip_palate_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(continue_followup.value_coded) as continue_followup,
    max(difficult_breathing.value_coded) as difficult_breathing,
    max(discharge.value_coded) as ear_discharge,
    max(pain.value_coded) as ear_pain,
    max(counseling.value_coded) as feeding_counseling,
    max(feeding_issues.value_coded) as feeding_problems,
    max(food_supplement.value_coded) as food_supplement,
    max(support_group.value_coded) as group_therapy,
    max(heart_murmur.value_coded) as heart_murmur,
    max(height_cm.value_numeric) as height,
    max(height_for_age_percent_of_median.value_numeric) as height_for_age,
    max(referred_out.value_coded) as if_referred_out,
    max(other_non_coded_text.value_text) as if_referred_out_specify,
    max(group_counselling.value_coded) as individual_counselling,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(malawi_developmental_assessment_tool_summary_normal_coded.value_coded) as mdat,
    max(wasting_malnutrition.value_coded) as malnutrition,
    max(appointment_date.value_date) as next_appointment_date,
    max(other_assessments.value_coded) as other,
    max(poser_support.value_coded) as poser,
    max(clinical_impression_comments.value_text) as clinical_plan,
    max(referred_out.value_coded) as referred_out,
    max(other_non_coded_text.value_text) as referred_out_specify,
    max(date_of_surgery.value_date) as surgery_date,
    max(scheduled.value_coded) as surgery_scheduled,
    max(weight_kg.value_numeric) as weight,
    max(weight_for_age_percent_of_median.value_numeric) as weight_for_age
from omrs_encounter e
left join temp_continue_followup continue_followup on e.encounter_id = continue_followup.encounter_id
left join temp_difficult_breathing difficult_breathing on e.encounter_id = difficult_breathing.encounter_id
left join temp_discharge discharge on e.encounter_id = discharge.encounter_id
left join temp_pain pain on e.encounter_id = pain.encounter_id
left join temp_counseling counseling on e.encounter_id = counseling.encounter_id
left join temp_feeding_issues feeding_issues on e.encounter_id = feeding_issues.encounter_id
left join temp_food_supplement food_supplement on e.encounter_id = food_supplement.encounter_id
left join temp_support_group support_group on e.encounter_id = support_group.encounter_id
left join temp_heart_murmur heart_murmur on e.encounter_id = heart_murmur.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_height_for_age_percent_of_median height_for_age_percent_of_median on e.encounter_id = height_for_age_percent_of_median.encounter_id
left join temp_referred_out referred_out on e.encounter_id = referred_out.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_group_counselling group_counselling on e.encounter_id = group_counselling.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_malawi_developmental_assessment_tool_summary_normal_coded malawi_developmental_assessment_tool_summary_normal_coded on e.encounter_id = malawi_developmental_assessment_tool_summary_normal_coded.encounter_id
left join temp_wasting_malnutrition wasting_malnutrition on e.encounter_id = wasting_malnutrition.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_other_assessments other_assessments on e.encounter_id = other_assessments.encounter_id
left join temp_poser_support poser_support on e.encounter_id = poser_support.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_date_of_surgery date_of_surgery on e.encounter_id = date_of_surgery.encounter_id
left join temp_scheduled scheduled on e.encounter_id = scheduled.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_weight_for_age_percent_of_median weight_for_age_percent_of_median on e.encounter_id = weight_for_age_percent_of_median.encounter_id
where e.encounter_type in ('PDC_CLEFT_CLIP_PALLET_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;