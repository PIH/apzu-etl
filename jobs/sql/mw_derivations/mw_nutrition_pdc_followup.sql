-- Derivation script for mw_nutrition_pdc_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-pdc-followup.ktr

drop table if exists mw_nutrition_pdc_followup;
create table mw_nutrition_pdc_followup (
    nutrition_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    weight decimal(10 , 2 ),
    height decimal(10 , 2 ),
    muac decimal(10 , 2 ),
    lactogen int,
    next_appointment date,
    warehouse_signature varchar(255),
    comments varchar(255),
    primary key (nutrition_followup_visit_id)
);

drop temporary table if exists temp_given_name;
create temporary table temp_given_name as select encounter_id, value_text from omrs_obs where concept = 'Given name';
alter table temp_given_name add index temp_given_name_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_lactogen_tins;
create temporary table temp_number_of_lactogen_tins as select encounter_id, value_numeric from omrs_obs where concept = 'Number of lactogen tins';
alter table temp_number_of_lactogen_tins add index temp_number_of_lactogen_tins_encounter_idx (encounter_id);

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_nutrition_pdc_followup (patient_id, visit_date, location, warehouse_signature, next_appointment, comments, height, lactogen, muac, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(given_name.value_text) as warehouse_signature,
    max(appointment_date.value_date) as next_appointment,
    max(clinical_impression_comments.value_text) as comments,
    max(height_cm.value_numeric) as height,
    max(number_of_lactogen_tins.value_numeric) as lactogen,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_given_name given_name on e.encounter_id = given_name.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_number_of_lactogen_tins number_of_lactogen_tins on e.encounter_id = number_of_lactogen_tins.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('NUTRITION_PDC_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;