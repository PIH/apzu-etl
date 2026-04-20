-- Derivation script for mw_nutrition_adult_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-adult-initial.ktr

drop table if exists mw_nutrition_adult_initial;
drop table if exists mw_nutrition_adult_initial;
create table mw_nutrition_adult_initial (
    nutrition_initial_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    enrollment_reason_tb varchar(255),
    enrollment_reason_hiv varchar(255),
    enrollment_reason_ncd varchar(255),
    primary key (nutrition_initial_visit_id));

drop temporary table if exists temp_reason_enrolled_in_food_program;
create temporary table temp_reason_enrolled_in_food_program as select encounter_id, value_coded from omrs_obs where concept = 'Reason enrolled in food program';
alter table temp_reason_enrolled_in_food_program add index temp_reason_enrolled_in_food_program_encounter_idx (encounter_id);

insert into mw_nutrition_adult_initial (patient_id, visit_date, location, enrollment_reason_tb, enrollment_reason_hiv, enrollment_reason_ncd)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when reason_enrolled_in_food_program.value_coded = 'Patient in tuberculosis treatment' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_tb,
    max(case when reason_enrolled_in_food_program.value_coded = 'Patient in HIV treatment' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_hiv,
    max(case when reason_enrolled_in_food_program.value_coded = 'Enrolled in NCD' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_ncd
from omrs_encounter e
left join temp_reason_enrolled_in_food_program reason_enrolled_in_food_program on e.encounter_id = reason_enrolled_in_food_program.encounter_id
where e.encounter_type in ('NUTRITION_ADULTS_INITIAL')
group by e.patient_id, e.encounter_date, e.location;