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

drop temporary table if exists temp_anticonvulsant;
create temporary table temp_anticonvulsant as select encounter_id, value_coded from omrs_obs where concept = 'Anticonvulsant';
alter table temp_anticonvulsant add index temp_anticonvulsant_encounter_idx (encounter_id);

drop temporary table if exists temp_continue_followup;
create temporary table temp_continue_followup as select encounter_id, value_coded from omrs_obs where concept = 'Continue followup';
alter table temp_continue_followup add index temp_continue_followup_encounter_idx (encounter_id);

drop temporary table if exists temp_adjust_dose;
create temporary table temp_adjust_dose as select encounter_id, value_coded from omrs_obs where concept = 'Adjust dose';
alter table temp_adjust_dose add index temp_adjust_dose_encounter_idx (encounter_id);

drop temporary table if exists temp_medications_dispensed;
create temporary table temp_medications_dispensed as select encounter_id, value_text from omrs_obs where concept = 'Medications dispensed';
alter table temp_medications_dispensed add index temp_medications_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_cup_feeding;
create temporary table temp_cup_feeding as select encounter_id, value_coded from omrs_obs where concept = 'Cup-feeding';
alter table temp_cup_feeding add index temp_cup_feeding_encounter_idx (encounter_id);

drop temporary table if exists temp_breast_feeding;
create temporary table temp_breast_feeding as select encounter_id, value_coded from omrs_obs where concept = 'Breast feeding';
alter table temp_breast_feeding add index temp_breast_feeding_encounter_idx (encounter_id);

drop temporary table if exists temp_orogastric_tube;
create temporary table temp_orogastric_tube as select encounter_id, value_coded from omrs_obs where concept = 'Orogastric tube';
alter table temp_orogastric_tube add index temp_orogastric_tube_encounter_idx (encounter_id);

drop temporary table if exists temp_food_supplement;
create temporary table temp_food_supplement as select encounter_id, value_coded from omrs_obs where concept = 'Food supplement';
alter table temp_food_supplement add index temp_food_supplement_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_referred_out;
create temporary table temp_referred_out as select encounter_id, value_coded from omrs_obs where concept = 'Referred out';
alter table temp_referred_out add index temp_referred_out_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

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

drop temporary table if exists temp_play_therapy;
create temporary table temp_play_therapy as select encounter_id, value_coded from omrs_obs where concept = 'Play therapy';
alter table temp_play_therapy add index temp_play_therapy_encounter_idx (encounter_id);

drop temporary table if exists temp_poor_growth;
create temporary table temp_poor_growth as select encounter_id, value_coded from omrs_obs where concept = 'Poor Growth';
alter table temp_poor_growth add index temp_poor_growth_encounter_idx (encounter_id);

drop temporary table if exists temp_signs_of_cerebral_palsy;
create temporary table temp_signs_of_cerebral_palsy as select encounter_id, value_coded from omrs_obs where concept = 'Signs of Cerebral Palsy';
alter table temp_signs_of_cerebral_palsy add index temp_signs_of_cerebral_palsy_encounter_idx (encounter_id);

drop temporary table if exists temp_hyper;
create temporary table temp_hyper as select encounter_id, value_coded from omrs_obs where concept = 'Hyper';
alter table temp_hyper add index temp_hyper_encounter_idx (encounter_id);

drop temporary table if exists temp_hypo;
create temporary table temp_hypo as select encounter_id, value_coded from omrs_obs where concept = 'Hypo';
alter table temp_hypo add index temp_hypo_encounter_idx (encounter_id);

drop temporary table if exists temp_normal_generic;
create temporary table temp_normal_generic as select encounter_id, value_coded from omrs_obs where concept = 'Normal(Generic)';
alter table temp_normal_generic add index temp_normal_generic_encounter_idx (encounter_id);

drop temporary table if exists temp_mental_health_referral;
create temporary table temp_mental_health_referral as select encounter_id, value_coded from omrs_obs where concept = 'Mental health referral';
alter table temp_mental_health_referral add index temp_mental_health_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_numeric_value_or_result;
create temporary table temp_numeric_value_or_result as select encounter_id, value_numeric from omrs_obs where concept = 'Numeric value or result';
alter table temp_numeric_value_or_result add index temp_numeric_value_or_result_encounter_idx (encounter_id);

insert into mw_pdc_developmental_delay_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(anticonvulsant.value_coded) as anticonvulsant,
    max(continue_followup.value_coded) as continue_followup,
    max(adjust_dose.value_coded) as dose_adjusted,
    max(medications_dispensed.value_text) as dose_and_drug,
    max(cup_feeding.value_coded) as feeding_cup,
    max(breast_feeding.value_coded) as feeding_sucking,
    max(orogastric_tube.value_coded) as feeding_tube,
    max(food_supplement.value_coded) as feeding_counselling,
    max(height_cm.value_numeric) as height,
    max(referred_out.value_coded) as if_referred_out,
    max(other_non_coded_text.value_text) as if_referred_out_specify,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(malawi_developmental_assessment_tool_summary_normal_coded.value_coded) as mdat,
    max(wasting_malnutrition.value_coded) as malnutrition,
    max(appointment_date.value_date) as next_appointment_date,
    max(play_therapy.value_coded) as group_counselling_and_play_therapy,
    max(referred_out.value_coded) as referred_out,
    max(other_non_coded_text.value_text) as referred_out_specify,
    max(poor_growth.value_coded) as referred_to_poser,
    max(signs_of_cerebral_palsy.value_coded) as signs_of_cerebral_palsy,
    max(hyper.value_coded) as tone_hyper,
    max(hypo.value_coded) as tone_hypo,
    max(normal_generic.value_coded) as tone_normal,
    max(mental_health_referral.value_coded) as under_mental_health_care_program,
    max(weight_kg.value_numeric) as weight,
    max(numeric_value_or_result.value_numeric) as weight_against_age,
    max(numeric_value_or_result.value_numeric) as weight_against_height
from omrs_encounter e
left join temp_anticonvulsant anticonvulsant on e.encounter_id = anticonvulsant.encounter_id
left join temp_continue_followup continue_followup on e.encounter_id = continue_followup.encounter_id
left join temp_adjust_dose adjust_dose on e.encounter_id = adjust_dose.encounter_id
left join temp_medications_dispensed medications_dispensed on e.encounter_id = medications_dispensed.encounter_id
left join temp_cup_feeding cup_feeding on e.encounter_id = cup_feeding.encounter_id
left join temp_breast_feeding breast_feeding on e.encounter_id = breast_feeding.encounter_id
left join temp_orogastric_tube orogastric_tube on e.encounter_id = orogastric_tube.encounter_id
left join temp_food_supplement food_supplement on e.encounter_id = food_supplement.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_referred_out referred_out on e.encounter_id = referred_out.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_malawi_developmental_assessment_tool_summary_normal_coded malawi_developmental_assessment_tool_summary_normal_coded on e.encounter_id = malawi_developmental_assessment_tool_summary_normal_coded.encounter_id
left join temp_wasting_malnutrition wasting_malnutrition on e.encounter_id = wasting_malnutrition.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_play_therapy play_therapy on e.encounter_id = play_therapy.encounter_id
left join temp_poor_growth poor_growth on e.encounter_id = poor_growth.encounter_id
left join temp_signs_of_cerebral_palsy signs_of_cerebral_palsy on e.encounter_id = signs_of_cerebral_palsy.encounter_id
left join temp_hyper hyper on e.encounter_id = hyper.encounter_id
left join temp_hypo hypo on e.encounter_id = hypo.encounter_id
left join temp_normal_generic normal_generic on e.encounter_id = normal_generic.encounter_id
left join temp_mental_health_referral mental_health_referral on e.encounter_id = mental_health_referral.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_numeric_value_or_result numeric_value_or_result on e.encounter_id = numeric_value_or_result.encounter_id
where e.encounter_type in ('PDC_DEVELOPMENTAL_DELAY_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;