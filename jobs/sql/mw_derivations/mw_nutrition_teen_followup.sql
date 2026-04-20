-- Derivation script for mw_nutrition_teen_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-teen-followup.ktr

drop table if exists mw_nutrition_teen_followup;
create table mw_nutrition_teen_followup (
    nutrition_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    weight decimal(10 , 2 ),
    height decimal(10 , 2 ),
    muac decimal(10 , 2 ),
    oil decimal(10 , 2 ),
    maize decimal(10 , 2 ),
    beans decimal(10 , 2 ),
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

drop temporary table if exists temp_received_beans_kg;
create temporary table temp_received_beans_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Received beans (kg)';
alter table temp_received_beans_kg add index temp_received_beans_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_received_maize_kg;
create temporary table temp_received_maize_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Received maize (kg)';
alter table temp_received_maize_kg add index temp_received_maize_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_oil_given_to_patient_liters;
create temporary table temp_oil_given_to_patient_liters as select encounter_id, value_numeric from omrs_obs where concept = 'Oil given to patient(Liters)';
alter table temp_oil_given_to_patient_liters add index temp_oil_given_to_patient_liters_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_nutrition_teen_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(given_name.value_text) as warehouse_signature,
    max(appointment_date.value_date) as next_appointment,
    max(received_beans_kg.value_numeric) as beans,
    max(clinical_impression_comments.value_text) as comments,
    max(height_cm.value_numeric) as height,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(received_maize_kg.value_numeric) as maize,
    max(oil_given_to_patient_liters.value_numeric) as oil,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_given_name given_name on e.encounter_id = given_name.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_received_beans_kg received_beans_kg on e.encounter_id = received_beans_kg.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_received_maize_kg received_maize_kg on e.encounter_id = received_maize_kg.encounter_id
left join temp_oil_given_to_patient_liters oil_given_to_patient_liters on e.encounter_id = oil_given_to_patient_liters.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('NUTRITION_PREGNANT_TEENS_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;