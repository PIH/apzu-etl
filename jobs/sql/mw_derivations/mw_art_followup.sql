-- Derivation script for mw_art_followup
-- Generated from Pentaho transform: import-into-mw-art-followup.ktr

drop table if exists mw_art_followup;
create table mw_art_followup (
  art_followup_visit_id 			int not null auto_increment,
  patient_id    				int not null,
  visit_date            			date,
  location              			varchar(255),
  next_appointment_date 			date,
  art_drugs_received 				varchar(255),
  pregnant_or_lactating			varchar(255),
  tb_status 					varchar(255),
  doses_missed					decimal(10,2),
  pill_count					int,
  no_side_effect				varchar(255),
  peripheral_neuropathy_side_effect		varchar(255),
  hepatitis_side_effect			varchar(255),
  skin_rash_side_effect			varchar(255),
  lipodystrophy_side_effect			varchar(255),
  other_side_effect				varchar(255),
  art_regimen					varchar(255),
  height					decimal(10,2),
  weight					decimal(10,2),
  arvs_given					int,
  arvs_given_to				varchar(255),
  ctx_960					varchar(255),
  ctx_960_pills		     		decimal(10,2),
  inh_300					varchar(255),
  inh_300_pills		     		decimal(10,2),
  rfp_150					varchar(255),
  rfp_150_pills		     		decimal(10,2),
  rfp_inh					varchar(255),
  rfp_inh_pills				decimal(10,2),
  pyridoxine					varchar(255),
  pyridoxine_pills		     		decimal(10,2),
  depo_given					varchar(255),
  systolic_bp		 			varchar(255),
  diastolic_bp					varchar(255),
  condoms_given				varchar(255),
     primary key (art_followup_visit_id)
);

drop temporary table if exists temp_art_followup_obs;
create temporary table temp_art_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'ART_FOLLOWUP';
alter table temp_art_followup_obs add index temp_art_followup_obs_concept_idx (concept);
alter table temp_art_followup_obs add index temp_art_followup_obs_encounter_idx (encounter_id);
alter table temp_art_followup_obs add index temp_art_followup_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Amount Dispensed'                                                               then value_numeric end) as amount_dispensed,
    max(case when concept = 'Amount of drug brought to clinic'                                               then value_numeric end) as pill_count,
    max(case when concept = 'Appointment date'                                                               then value_date    end) as next_appointment_date,
    max(case when concept = 'Depo-Provera given'                                                             then value_coded   end) as depo_given,
    max(case when concept = 'Diastolic blood pressure'                                                       then value_numeric end) as diastolic_bp,
    max(case when concept = 'Height (cm)'                                                                    then value_numeric end) as height,
    max(case when concept = 'HIV Preventive Therapy' and value_coded = '3HP (Rifapentine and Isoniazid)'     then value_coded   end) as rfp_inh,
    max(case when concept = 'HIV Preventive Therapy' and value_coded = 'Isoniazid'                           then value_coded   end) as inh_300,
    max(case when concept = 'HIV Preventive Therapy' and value_coded = 'Pyridoxine'                          then value_coded   end) as pyridoxine,
    max(case when concept = 'HIV Preventive Therapy' and value_coded = 'Rifapentine'                         then value_coded   end) as rfp_150,
    max(case when concept = 'HIV Preventive Therapy' and value_coded = 'Trimethoprim and sulfamethoxazole'   then value_coded   end) as ctx_960,
    max(case when concept = 'Malawi Antiretroviral drugs received'                                           then value_coded   end) as art_regimen,
    max(case when concept = 'Malawi ART side effects' and value_coded = 'Hepatitis'                          then value_coded   end) as hepatitis_side_effect,
    max(case when concept = 'Malawi ART side effects' and value_coded = 'Lipodystrophy'                      then value_coded   end) as lipodystrophy_side_effect,
    max(case when concept = 'Malawi ART side effects' and value_coded = 'No'                                 then value_coded   end) as no_side_effect,
    max(case when concept = 'Malawi ART side effects' and value_coded = 'Other'                              then value_coded   end) as other_side_effect,
    max(case when concept = 'Malawi ART side effects' and value_coded = 'Peripheral neuropathy'              then value_coded   end) as peripheral_neuropathy_side_effect,
    max(case when concept = 'Malawi ART side effects' and value_coded = 'Skin rash'                          then value_coded   end) as skin_rash_side_effect,
    max(case when concept = 'Number of antiretrovirals given'                                                then value_numeric end) as arvs_given,
    max(case when concept = 'Number of Condoms dispensed'                                                    then value_numeric end) as condoms_given,
    max(case when concept = 'Number of HIV drug doses missed'                                                then value_numeric end) as doses_missed,
    max(case when concept = 'Pregnant/Lactating'                                                             then value_coded   end) as pregnant_or_lactating,
    max(case when concept = 'Responsible person present'                                                     then value_coded   end) as arvs_given_to,
    max(case when concept = 'Systolic blood pressure'                                                        then value_numeric end) as systolic_bp,
    max(case when concept = 'TB status'                                                                      then value_coded   end) as tb_status,
    max(case when concept = 'Weight (kg)'                                                                    then value_numeric end) as weight
from temp_art_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_art_followup (patient_id, visit_date, location, art_regimen, arvs_given_to, next_appointment_date, ctx_960, ctx_960_pills, condoms_given, depo_given, diastolic_bp, doses_missed, height, inh_300, inh_300_pills, art_drugs_received, arvs_given, pill_count, pregnant_or_lactating, pyridoxine, pyridoxine_pills, rfp_150, rfp_150_pills, rfp_inh, rfp_inh_pills, no_side_effect, peripheral_neuropathy_side_effect, hepatitis_side_effect, skin_rash_side_effect, lipodystrophy_side_effect, other_side_effect, systolic_bp, tb_status, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.art_regimen,
    sv.arvs_given_to,
    sv.next_appointment_date,
    sv.ctx_960,
    sv.amount_dispensed,
    sv.condoms_given,
    sv.depo_given,
    sv.diastolic_bp,
    sv.doses_missed,
    sv.height,
    sv.inh_300,
    sv.amount_dispensed,
    sv.art_regimen,
    sv.arvs_given,
    sv.pill_count,
    sv.pregnant_or_lactating,
    sv.pyridoxine,
    sv.amount_dispensed,
    sv.rfp_150,
    sv.amount_dispensed,
    sv.rfp_inh,
    sv.amount_dispensed,
    sv.no_side_effect,
    sv.peripheral_neuropathy_side_effect,
    sv.hepatitis_side_effect,
    sv.skin_rash_side_effect,
    sv.lipodystrophy_side_effect,
    sv.other_side_effect,
    sv.systolic_bp,
    sv.tb_status,
    sv.weight
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('ART_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_art_followup_obs;
drop temporary table if exists temp_single_values;
