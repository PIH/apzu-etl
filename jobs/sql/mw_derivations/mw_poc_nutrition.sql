-- Derivation script for mw_poc_nutrition
-- Generated from Pentaho transform: import-into-mw-poc-nutrition.ktr

drop table if exists mw_poc_nutrition;
create table mw_poc_nutrition (
    poc_nutrition_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    height decimal(10,2),
    weight decimal(10,2),
    is_patient_preg varchar(255),
    muac varchar(255),
    primary key (poc_nutrition_visit_id)
);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter (encounter_id);

drop temporary table if exists temp_is_patient_pregnant;
create temporary table temp_is_patient_pregnant as select encounter_id, value_coded from omrs_obs where concept = 'Is patient pregnant?';
alter table temp_is_patient_pregnant add index temp_is_patient_pregnant_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_poc_nutrition (patient_id, visit_date, location, height, muac, is_patient_preg, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(height_cm.value_numeric) as height,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(is_patient_pregnant.value_coded) as is_patient_preg,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_is_patient_pregnant is_patient_pregnant on e.encounter_id = is_patient_pregnant.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('Nutrition Screening')
group by e.patient_id, e.encounter_date, e.location;