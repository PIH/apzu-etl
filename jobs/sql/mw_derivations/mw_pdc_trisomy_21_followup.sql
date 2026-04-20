-- Derivation script for mw_pdc_trisomy_21_followup
-- Generated from Pentaho transform: import-into-mw-pdc-trisomy-21-followup.ktr

drop table if exists mw_pdc_trisomy_21_followup;
create table mw_pdc_trisomy_21_followup (
  pdc_trisomy_21_visit_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  weight 				int default null,
  height				int default null,
  muac 					int default null,
  malnutrition				varchar(255) default null,
  passage_normal			varchar(255) default null,
  diarrhea_persistent			varchar(255) default null,
  vomiting				varchar(255) default null,
  ear_pain				varchar(255) default null,
  ear_discharge				varchar(255) default null,
  sleep_apnea				varchar(255) default null,
  sleep_chocking			varchar(255) default null,
  extremities_pain			varchar(255) default null,
  extremities_weakness			varchar(255) default null,
  anticonvulsant			varchar(255) default null,
  drug_and_dose				varchar(255) default null,
  adjust_dose				varchar(255) default null,
  individual_counselling		varchar(255) default null,
  feeding_counselling			varchar(255) default null,
  continue_followup			varchar(255) default null,
  physiotherapy				varchar(255) default null,
  group_counselling_and_play_therapy	varchar(255) default null,
  mdat					varchar(255) default null,
  referred_to_poser			varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  next_appointment_date 		date default null,
  primary key (pdc_trisomy_21_visit_id )
) ;

drop temporary table if exists temp_adjust_dose;
create temporary table temp_adjust_dose as select encounter_id, value_coded from omrs_obs where concept = 'Adjust dose';
alter table temp_adjust_dose add index temp_adjust_dose_encounter_idx (encounter_id);

drop temporary table if exists temp_anticonvulsant;
create temporary table temp_anticonvulsant as select encounter_id, value_coded from omrs_obs where concept = 'Anticonvulsant';
alter table temp_anticonvulsant add index temp_anticonvulsant_encounter_idx (encounter_id);

drop temporary table if exists temp_continue_followup;
create temporary table temp_continue_followup as select encounter_id, value_coded from omrs_obs where concept = 'Continue followup';
alter table temp_continue_followup add index temp_continue_followup_encounter_idx (encounter_id);

drop temporary table if exists temp_diarrhea_persistent;
create temporary table temp_diarrhea_persistent as select encounter_id, value_coded from omrs_obs where concept = 'Diarrhea Persistent';
alter table temp_diarrhea_persistent add index temp_diarrhea_persistent_encounter_idx (encounter_id);

drop temporary table if exists temp_medications_dispensed;
create temporary table temp_medications_dispensed as select encounter_id, value_text from omrs_obs where concept = 'Medications dispensed';
alter table temp_medications_dispensed add index temp_medications_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_discharge;
create temporary table temp_discharge as select encounter_id, value_coded from omrs_obs where concept = 'Discharge';
alter table temp_discharge add index temp_discharge_encounter_idx (encounter_id);

drop temporary table if exists temp_pain;
create temporary table temp_pain as select encounter_id, value_coded from omrs_obs where concept = 'Pain';
alter table temp_pain add index temp_pain_encounter_idx (encounter_id);

drop temporary table if exists temp_weak;
create temporary table temp_weak as select encounter_id, value_coded from omrs_obs where concept = 'Weak';
alter table temp_weak add index temp_weak_encounter_idx (encounter_id);

drop temporary table if exists temp_food_supplement;
create temporary table temp_food_supplement as select encounter_id, value_coded from omrs_obs where concept = 'Food supplement';
alter table temp_food_supplement add index temp_food_supplement_encounter_idx (encounter_id);

drop temporary table if exists temp_play_therapy;
create temporary table temp_play_therapy as select encounter_id, value_coded from omrs_obs where concept = 'Play therapy';
alter table temp_play_therapy add index temp_play_therapy_encounter_idx (encounter_id);

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

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter (encounter_id);

drop temporary table if exists temp_malawi_developmental_assessment_tool_summary;
create temporary table temp_malawi_developmental_assessment_tool_summary as select encounter_id, value_coded from omrs_obs where concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)';
alter table temp_malawi_developmental_assessment_tool_summary add index temp_malawi_dev_assessment_tool_summary (encounter_id);

drop temporary table if exists temp_wasting_malnutrition;
create temporary table temp_wasting_malnutrition as select encounter_id, value_coded from omrs_obs where concept = 'Wasting/malnutrition';
alter table temp_wasting_malnutrition add index temp_wasting_malnutrition_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_normal_generic;
create temporary table temp_normal_generic as select encounter_id, value_coded from omrs_obs where concept = 'Normal(Generic)';
alter table temp_normal_generic add index temp_normal_generic_encounter_idx (encounter_id);

drop temporary table if exists temp_physiotherapy;
create temporary table temp_physiotherapy as select encounter_id, value_coded from omrs_obs where concept = 'Physiotherapy';
alter table temp_physiotherapy add index temp_physiotherapy_encounter_idx (encounter_id);

drop temporary table if exists temp_poor_growth;
create temporary table temp_poor_growth as select encounter_id, value_coded from omrs_obs where concept = 'Poor Growth';
alter table temp_poor_growth add index temp_poor_growth_encounter_idx (encounter_id);

drop temporary table if exists temp_apnea;
create temporary table temp_apnea as select encounter_id, value_coded from omrs_obs where concept = 'Apnea';
alter table temp_apnea add index temp_apnea_encounter_idx (encounter_id);

drop temporary table if exists temp_choking;
create temporary table temp_choking as select encounter_id, value_coded from omrs_obs where concept = 'Choking';
alter table temp_choking add index temp_choking_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_vomiting;
create temporary table temp_patient_vomiting as select encounter_id, value_coded from omrs_obs where concept = 'Patient Vomiting';
alter table temp_patient_vomiting add index temp_patient_vomiting_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_pdc_trisomy_21_followup (patient_id, visit_date, location, adjust_dose, anticonvulsant, continue_followup, diarrhea_persistent, drug_and_dose, ear_discharge, ear_pain, extremities_pain, extremities_weakness, feeding_counselling, group_counselling_and_play_therapy, height, if_referred_out, if_referred_out_specify, individual_counselling, muac, mdat, malnutrition, next_appointment_date, passage_normal, physiotherapy, referred_out, referred_out_specify, referred_to_poser, sleep_apnea, sleep_chocking, vomiting, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(adjust_dose.value_coded) as adjust_dose,
    max(anticonvulsant.value_coded) as anticonvulsant,
    max(continue_followup.value_coded) as continue_followup,
    max(diarrhea_persistent.value_coded) as diarrhea_persistent,
    max(medications_dispensed.value_text) as drug_and_dose,
    max(discharge.value_coded) as ear_discharge,
    max(pain.value_coded) as ear_pain,
    max(pain.value_coded) as extremities_pain,
    max(weak.value_coded) as extremities_weakness,
    max(food_supplement.value_coded) as feeding_counselling,
    max(play_therapy.value_coded) as group_counselling_and_play_therapy,
    max(height_cm.value_numeric) as height,
    max(referred_out.value_coded) as if_referred_out,
    max(other_non_coded_text.value_text) as if_referred_out_specify,
    max(counseling.value_coded) as individual_counselling,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(malawi_developmental_assessment_tool_summary_normal_coded.value_coded) as mdat,
    max(wasting_malnutrition.value_coded) as malnutrition,
    max(appointment_date.value_date) as next_appointment_date,
    max(normal_generic.value_coded) as passage_normal,
    max(physiotherapy.value_coded) as physiotherapy,
    max(referred_out.value_coded) as referred_out,
    max(other_non_coded_text.value_text) as referred_out_specify,
    max(poor_growth.value_coded) as referred_to_poser,
    max(apnea.value_coded) as sleep_apnea,
    max(choking.value_coded) as sleep_chocking,
    max(patient_vomiting.value_coded) as vomiting,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_adjust_dose adjust_dose on e.encounter_id = adjust_dose.encounter_id
left join temp_anticonvulsant anticonvulsant on e.encounter_id = anticonvulsant.encounter_id
left join temp_continue_followup continue_followup on e.encounter_id = continue_followup.encounter_id
left join temp_diarrhea_persistent diarrhea_persistent on e.encounter_id = diarrhea_persistent.encounter_id
left join temp_medications_dispensed medications_dispensed on e.encounter_id = medications_dispensed.encounter_id
left join temp_discharge discharge on e.encounter_id = discharge.encounter_id
left join temp_pain pain on e.encounter_id = pain.encounter_id
left join temp_weak weak on e.encounter_id = weak.encounter_id
left join temp_food_supplement food_supplement on e.encounter_id = food_supplement.encounter_id
left join temp_play_therapy play_therapy on e.encounter_id = play_therapy.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_referred_out referred_out on e.encounter_id = referred_out.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_counseling counseling on e.encounter_id = counseling.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_malawi_developmental_assessment_tool_summary malawi_developmental_assessment_tool_summary_normal_coded on e.encounter_id = malawi_developmental_assessment_tool_summary_normal_coded.encounter_id
left join temp_wasting_malnutrition wasting_malnutrition on e.encounter_id = wasting_malnutrition.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_normal_generic normal_generic on e.encounter_id = normal_generic.encounter_id
left join temp_physiotherapy physiotherapy on e.encounter_id = physiotherapy.encounter_id
left join temp_poor_growth poor_growth on e.encounter_id = poor_growth.encounter_id
left join temp_apnea apnea on e.encounter_id = apnea.encounter_id
left join temp_choking choking on e.encounter_id = choking.encounter_id
left join temp_patient_vomiting patient_vomiting on e.encounter_id = patient_vomiting.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('PDC_TRISOMY21_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;