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

drop temporary table if exists temp_pdc_trisomy_obs;
create temporary table temp_pdc_trisomy_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'PDC_TRISOMY21_FOLLOWUP';
alter table temp_pdc_trisomy_obs add index temp_pdc_trisomy_obs_concept_idx (concept);
alter table temp_pdc_trisomy_obs add index temp_pdc_trisomy_obs_encounter_idx (encounter_id);
alter table temp_pdc_trisomy_obs add index temp_pdc_trisomy_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Adjust dose'                                                       then value_coded   end) as adjust_dose,
    max(case when concept = 'Anticonvulsant'                                                    then value_coded   end) as anticonvulsant,
    max(case when concept = 'Continue followup'                                                 then value_coded   end) as continue_followup,
    max(case when concept = 'Diarrhea Persistent'                                               then value_coded   end) as diarrhea_persistent,
    max(case when concept = 'Medications dispensed'                                             then value_text    end) as drug_and_dose,
    max(case when concept = 'Discharge'                                                         then value_coded   end) as ear_discharge,
    max(case when concept = 'Pain'                                                              then value_coded   end) as ear_pain,
    max(case when concept = 'Weak'                                                              then value_coded   end) as extremities_weakness,
    max(case when concept = 'Food supplement'                                                   then value_coded   end) as feeding_counselling,
    max(case when concept = 'Play therapy'                                                      then value_coded   end) as group_counselling_and_play_therapy,
    max(case when concept = 'Height (cm)'                                                       then value_numeric end) as height,
    max(case when concept = 'Referred out'                                                      then value_coded   end) as referred_out,
    max(case when concept = 'Other non-coded (text)'                                            then value_text    end) as referred_out_specify,
    max(case when concept = 'Counseling'                                                        then value_coded   end) as individual_counselling,
    max(case when concept = 'Middle upper arm circumference (cm)'                               then value_numeric end) as muac,
    max(case when concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)'     then value_coded   end) as mdat,
    max(case when concept = 'Wasting/malnutrition'                                              then value_coded   end) as malnutrition,
    max(case when concept = 'Appointment date'                                                  then value_date    end) as next_appointment_date,
    max(case when concept = 'Normal(Generic)'                                                   then value_coded   end) as passage_normal,
    max(case when concept = 'Physiotherapy'                                                     then value_coded   end) as physiotherapy,
    max(case when concept = 'Poor Growth'                                                       then value_coded   end) as referred_to_poser,
    max(case when concept = 'Apnea'                                                             then value_coded   end) as sleep_apnea,
    max(case when concept = 'Choking'                                                           then value_coded   end) as sleep_chocking,
    max(case when concept = 'Patient Vomiting'                                                  then value_coded   end) as vomiting,
    max(case when concept = 'Weight (kg)'                                                       then value_numeric end) as weight
from temp_pdc_trisomy_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_pdc_trisomy_21_followup (patient_id, visit_date, location, adjust_dose, anticonvulsant, continue_followup, diarrhea_persistent, drug_and_dose, ear_discharge, ear_pain, extremities_pain, extremities_weakness, feeding_counselling, group_counselling_and_play_therapy, height, if_referred_out, if_referred_out_specify, individual_counselling, muac, mdat, malnutrition, next_appointment_date, passage_normal, physiotherapy, referred_out, referred_out_specify, referred_to_poser, sleep_apnea, sleep_chocking, vomiting, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.adjust_dose,
    sv.anticonvulsant,
    sv.continue_followup,
    sv.diarrhea_persistent,
    sv.drug_and_dose,
    sv.ear_discharge,
    sv.ear_pain,
    sv.ear_pain,
    sv.extremities_weakness,
    sv.feeding_counselling,
    sv.group_counselling_and_play_therapy,
    sv.height,
    sv.referred_out,
    sv.referred_out_specify,
    sv.individual_counselling,
    sv.muac,
    sv.mdat,
    sv.malnutrition,
    sv.next_appointment_date,
    sv.passage_normal,
    sv.physiotherapy,
    sv.referred_out,
    sv.referred_out_specify,
    sv.referred_to_poser,
    sv.sleep_apnea,
    sv.sleep_chocking,
    sv.vomiting,
    sv.weight
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_TRISOMY21_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_pdc_trisomy_obs;
drop temporary table if exists temp_single_values;
