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


drop temporary table if exists temp_malawi_antiretroviral_drugs_received;
create temporary table temp_malawi_antiretroviral_drugs_received as select encounter_id, value_coded from temp_art_followup_obs where concept = 'Malawi Antiretroviral drugs received';
alter table temp_malawi_antiretroviral_drugs_received add index temp_malawi_arv_drugs_received_encounter_idx (encounter_id);

drop temporary table if exists temp_responsible_person_present;
create temporary table temp_responsible_person_present as select encounter_id, value_coded from temp_art_followup_obs where concept = 'Responsible person present';
alter table temp_responsible_person_present add index temp_responsible_person_present_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from temp_art_followup_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_preventive_therapy;
create temporary table temp_hiv_preventive_therapy as select encounter_id, value_coded from temp_art_followup_obs where concept = 'HIV Preventive Therapy';
alter table temp_hiv_preventive_therapy add index temp_hiv_preventive_therapy_encounter_idx (encounter_id);

drop temporary table if exists temp_amount_dispensed;
create temporary table temp_amount_dispensed as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Amount Dispensed';
alter table temp_amount_dispensed add index temp_amount_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_condoms_dispensed;
create temporary table temp_number_of_condoms_dispensed as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Number of Condoms dispensed';
alter table temp_number_of_condoms_dispensed add index temp_number_of_condoms_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_depo_provera_given;
create temporary table temp_depo_provera_given as select encounter_id, value_coded from temp_art_followup_obs where concept = 'Depo-Provera given';
alter table temp_depo_provera_given add index temp_depo_provera_given_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_hiv_drug_doses_missed;
create temporary table temp_number_of_hiv_drug_doses_missed as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Number of HIV drug doses missed';
alter table temp_number_of_hiv_drug_doses_missed add index temp_number_of_hiv_drug_doses_missed_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_antiretrovirals_given;
create temporary table temp_number_of_antiretrovirals_given as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Number of antiretrovirals given';
alter table temp_number_of_antiretrovirals_given add index temp_number_of_antiretrovirals_given_encounter_idx (encounter_id);

drop temporary table if exists temp_amount_of_drug_brought_to_clinic;
create temporary table temp_amount_of_drug_brought_to_clinic as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Amount of drug brought to clinic';
alter table temp_amount_of_drug_brought_to_clinic add index temp_amount_drug_brought_clinic_encounter_idx (encounter_id);

drop temporary table if exists temp_pregnant_lactating;
create temporary table temp_pregnant_lactating as select encounter_id, value_coded from temp_art_followup_obs where concept = 'Pregnant/Lactating';
alter table temp_pregnant_lactating add index temp_pregnant_lactating_encounter_idx (encounter_id);

drop temporary table if exists temp_malawi_art_side_effects;
create temporary table temp_malawi_art_side_effects as select encounter_id, value_coded from temp_art_followup_obs where concept = 'Malawi ART side effects';
alter table temp_malawi_art_side_effects add index temp_malawi_art_side_effects_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from temp_art_followup_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from temp_art_followup_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_art_followup (patient_id, visit_date, location, art_regimen, arvs_given_to, next_appointment_date, ctx_960, ctx_960_pills, condoms_given, depo_given, diastolic_bp, doses_missed, height, inh_300, inh_300_pills, art_drugs_received, arvs_given, pill_count, pregnant_or_lactating, pyridoxine, pyridoxine_pills, rfp_150, rfp_150_pills, rfp_inh, rfp_inh_pills, no_side_effect, peripheral_neuropathy_side_effect, hepatitis_side_effect, skin_rash_side_effect, lipodystrophy_side_effect, other_side_effect, systolic_bp, tb_status, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(malawi_antiretroviral_drugs_received.value_coded) as art_regimen,
    max(responsible_person_present.value_coded) as arvs_given_to,
    max(appointment_date.value_date) as next_appointment_date,
    max(case when hiv_preventive_therapy.value_coded = 'Trimethoprim and sulfamethoxazole' then hiv_preventive_therapy.value_coded end) as ctx_960,
    max(amount_dispensed.value_numeric) as ctx_960_pills,
    max(number_of_condoms_dispensed.value_numeric) as condoms_given,
    max(depo_provera_given.value_coded) as depo_given,
    max(diastolic_blood_pressure.value_numeric) as diastolic_bp,
    max(number_of_hiv_drug_doses_missed.value_numeric) as doses_missed,
    max(height_cm.value_numeric) as height,
    max(case when hiv_preventive_therapy.value_coded = 'Isoniazid' then hiv_preventive_therapy.value_coded end) as inh_300,
    max(amount_dispensed.value_numeric) as inh_300_pills,
    max(malawi_antiretroviral_drugs_received.value_coded) as art_drugs_received,
    max(number_of_antiretrovirals_given.value_numeric) as arvs_given,
    max(amount_of_drug_brought_to_clinic.value_numeric) as pill_count,
    max(pregnant_lactating.value_coded) as pregnant_or_lactating,
    max(case when hiv_preventive_therapy.value_coded = 'Pyridoxine' then hiv_preventive_therapy.value_coded end) as pyridoxine,
    max(amount_dispensed.value_numeric) as pyridoxine_pills,
    max(case when hiv_preventive_therapy.value_coded = 'Rifapentine' then hiv_preventive_therapy.value_coded end) as rfp_150,
    max(amount_dispensed.value_numeric) as rfp_150_pills,
    max(case when hiv_preventive_therapy.value_coded = '3HP (Rifapentine and Isoniazid)' then hiv_preventive_therapy.value_coded end) as rfp_inh,
    max(amount_dispensed.value_numeric) as rfp_inh_pills,
    max(case when malawi_art_side_effects.value_coded = 'No' then malawi_art_side_effects.value_coded end) as no_side_effect,
    max(case when malawi_art_side_effects.value_coded = 'Peripheral neuropathy' then malawi_art_side_effects.value_coded end) as peripheral_neuropathy_side_effect,
    max(case when malawi_art_side_effects.value_coded = 'Hepatitis' then malawi_art_side_effects.value_coded end) as hepatitis_side_effect,
    max(case when malawi_art_side_effects.value_coded = 'Skin rash' then malawi_art_side_effects.value_coded end) as skin_rash_side_effect,
    max(case when malawi_art_side_effects.value_coded = 'Lipodystrophy' then malawi_art_side_effects.value_coded end) as lipodystrophy_side_effect,
    max(case when malawi_art_side_effects.value_coded = 'Other' then malawi_art_side_effects.value_coded end) as other_side_effect,
    max(systolic_blood_pressure.value_numeric) as systolic_bp,
    max(tb_status.value_coded) as tb_status,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_malawi_antiretroviral_drugs_received malawi_antiretroviral_drugs_received on e.encounter_id = malawi_antiretroviral_drugs_received.encounter_id
left join temp_responsible_person_present responsible_person_present on e.encounter_id = responsible_person_present.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_hiv_preventive_therapy hiv_preventive_therapy on e.encounter_id = hiv_preventive_therapy.encounter_id
left join temp_amount_dispensed amount_dispensed on e.encounter_id = amount_dispensed.encounter_id
left join temp_number_of_condoms_dispensed number_of_condoms_dispensed on e.encounter_id = number_of_condoms_dispensed.encounter_id
left join temp_depo_provera_given depo_provera_given on e.encounter_id = depo_provera_given.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_number_of_hiv_drug_doses_missed number_of_hiv_drug_doses_missed on e.encounter_id = number_of_hiv_drug_doses_missed.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_number_of_antiretrovirals_given number_of_antiretrovirals_given on e.encounter_id = number_of_antiretrovirals_given.encounter_id
left join temp_amount_of_drug_brought_to_clinic amount_of_drug_brought_to_clinic on e.encounter_id = amount_of_drug_brought_to_clinic.encounter_id
left join temp_pregnant_lactating pregnant_lactating on e.encounter_id = pregnant_lactating.encounter_id
left join temp_malawi_art_side_effects malawi_art_side_effects on e.encounter_id = malawi_art_side_effects.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('ART_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;