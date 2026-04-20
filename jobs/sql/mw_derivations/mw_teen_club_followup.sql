-- Derivation script for mw_teen_club_followup
-- Generated from Pentaho transform: import-into-mw-teen-club-followup.ktr

drop table if exists mw_teen_club_followup;
create table mw_teen_club_followup (
    teen_club_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    height decimal(10 , 2 ),
    weight decimal(10 , 2 ),
    muac_bmi decimal(10 , 2 ),
    tb_status varchar(255),
    tb_screening_outcome varchar(255),
    sputum_collected varchar(255),
    nutrition_screening_for_normal_muac varchar(255),
    nutrition_referred varchar(255),
    mental_health_screened varchar(255),
    adolescent_referred varchar(255),
    adolescent_registered varchar(255),
    sti_screening_outcome varchar(255),
    referred_to_sti_clinic varchar(255),
    hospitalized varchar(255),
    next_appointment date,
    primary key (teen_club_followup_visit_id)
);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_sample_collected;
create temporary table temp_sample_collected as select encounter_id, value_coded from omrs_obs where concept = 'Sample collected';
alter table temp_sample_collected add index temp_sample_collected_encounter_idx (encounter_id);

drop temporary table if exists temp_body_mass_index_measured;
create temporary table temp_body_mass_index_measured as select encounter_id, value_numeric from omrs_obs where concept = 'Body mass index, measured';
alter table temp_body_mass_index_measured add index temp_body_mass_index_measured_encounter_idx (encounter_id);

drop temporary table if exists temp_normal_nutrition_screening_for_muac;
create temporary table temp_normal_nutrition_screening_for_muac as select encounter_id, value_coded from omrs_obs where concept = 'Normal nutrition screening for MUAC';
alter table temp_normal_nutrition_screening_for_muac add index temp_normal_nutrition_screening_for_muac_encounter_idx (encounter_id);

drop temporary table if exists temp_nutrition_referral;
create temporary table temp_nutrition_referral as select encounter_id, value_coded from omrs_obs where concept = 'Nutrition referral';
alter table temp_nutrition_referral add index temp_nutrition_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_sti_referral;
create temporary table temp_sti_referral as select encounter_id, value_coded from omrs_obs where concept = 'STI referral';
alter table temp_sti_referral add index temp_sti_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_sti_screening_outcome;
create temporary table temp_sti_screening_outcome as select encounter_id, value_coded from omrs_obs where concept = 'STI screening outcome';
alter table temp_sti_screening_outcome add index temp_sti_screening_outcome_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_screening_outcome;
create temporary table temp_tb_screening_outcome as select encounter_id, value_coded from omrs_obs where concept = 'TB screening outcome';
alter table temp_tb_screening_outcome add index temp_tb_screening_outcome_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from omrs_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_if_yes_adolescent_referred;
create temporary table temp_if_yes_adolescent_referred as select encounter_id, value_coded from omrs_obs where concept = 'If yes,Adolescent referred?';
alter table temp_if_yes_adolescent_referred add index temp_if_yes_adolescent_referred_encounter_idx (encounter_id);

drop temporary table if exists temp_if_yes_adolescent_registered;
create temporary table temp_if_yes_adolescent_registered as select encounter_id, value_coded from omrs_obs where concept = 'If yes,Adolescent registered?';
alter table temp_if_yes_adolescent_registered add index temp_if_yes_adolescent_registered_encounter_idx (encounter_id);

drop temporary table if exists temp_mental_health_screened;
create temporary table temp_mental_health_screened as select encounter_id, value_coded from omrs_obs where concept = 'Mental health screened';
alter table temp_mental_health_screened add index temp_mental_health_screened_encounter_idx (encounter_id);

insert into mw_teen_club_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(appointment_date.value_date) as next_appointment,
    max(height_cm.value_numeric) as height,
    max(sample_collected.value_coded) as hospitalized,
    max(body_mass_index_measured.value_numeric) as muac_bmi,
    max(normal_nutrition_screening_for_muac.value_coded) as nutrition_screening_for_normal_muac,
    max(nutrition_referral.value_coded) as nutrition_referred,
    max(sti_referral.value_coded) as referred_to_sti_clinic,
    max(sti_screening_outcome.value_coded) as sti_screening_outcome,
    max(sample_collected.value_coded) as sputum_collected,
    max(tb_screening_outcome.value_coded) as tb_screening_outcome,
    max(tb_status.value_coded) as tb_status,
    max(weight_kg.value_numeric) as weight,
    max(if_yes_adolescent_referred.value_coded) as adolescent_referred,
    max(if_yes_adolescent_registered.value_coded) as adolescent_registered,
    max(mental_health_screened.value_coded) as mental_health_screened
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_sample_collected sample_collected on e.encounter_id = sample_collected.encounter_id
left join temp_body_mass_index_measured body_mass_index_measured on e.encounter_id = body_mass_index_measured.encounter_id
left join temp_normal_nutrition_screening_for_muac normal_nutrition_screening_for_muac on e.encounter_id = normal_nutrition_screening_for_muac.encounter_id
left join temp_nutrition_referral nutrition_referral on e.encounter_id = nutrition_referral.encounter_id
left join temp_sti_referral sti_referral on e.encounter_id = sti_referral.encounter_id
left join temp_sti_screening_outcome sti_screening_outcome on e.encounter_id = sti_screening_outcome.encounter_id
left join temp_tb_screening_outcome tb_screening_outcome on e.encounter_id = tb_screening_outcome.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_if_yes_adolescent_referred if_yes_adolescent_referred on e.encounter_id = if_yes_adolescent_referred.encounter_id
left join temp_if_yes_adolescent_registered if_yes_adolescent_registered on e.encounter_id = if_yes_adolescent_registered.encounter_id
left join temp_mental_health_screened mental_health_screened on e.encounter_id = mental_health_screened.encounter_id
where e.encounter_type in ('TEEN_CLUB_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;