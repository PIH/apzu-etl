-- Derivation script for mw_nutrition_adult_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-adult-followup.ktr

drop table if exists mw_nutrition_adult_followup;
create table mw_nutrition_adult_followup (
    nutrition_adult_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    weight decimal(10 , 2 ),
    height decimal(10 , 2 ),
    bmi decimal(10 , 2 ),
    food_likuni_phala decimal(10 , 2 ),
    next_appointment date,
    warehouse_signature varchar(255),
    comments varchar(255),
    primary key (nutrition_adult_followup_visit_id)
);

drop temporary table if exists temp_given_name;
create temporary table temp_given_name as select encounter_id, value_text from omrs_obs where concept = 'Given name';
alter table temp_given_name add index temp_given_name_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_body_mass_index_measured;
create temporary table temp_body_mass_index_measured as select encounter_id, value_numeric from omrs_obs where concept = 'Body mass index, measured';
alter table temp_body_mass_index_measured add index temp_body_mass_index_measured_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_likuni_phala_given_to_patient_kg;
create temporary table temp_likuni_phala_given_to_patient_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Likuni Phala given to patient(Kg)';
alter table temp_likuni_phala_given_to_patient_kg add index temp_likuni_phala_given_patient_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_nutrition_adult_followup (patient_id, visit_date, location, warehouse_signature, next_appointment, bmi, comments, food_likuni_phala, height, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(given_name.value_text) as warehouse_signature,
    max(appointment_date.value_date) as next_appointment,
    max(body_mass_index_measured.value_numeric) as bmi,
    max(clinical_impression_comments.value_text) as comments,
    max(likuni_phala_given_to_patient_kg.value_numeric) as food_likuni_phala,
    max(height_cm.value_numeric) as height,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_given_name given_name on e.encounter_id = given_name.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_body_mass_index_measured body_mass_index_measured on e.encounter_id = body_mass_index_measured.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_likuni_phala_given_to_patient_kg likuni_phala_given_to_patient_kg on e.encounter_id = likuni_phala_given_to_patient_kg.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('NUTRITION_ADULTS_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;