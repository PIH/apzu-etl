-- Derivation script for mw_nutrition_pdc_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-pdc-initial.ktr

drop table if exists mw_nutrition_pdc_initial;
create table mw_nutrition_pdc_initial (
    nutrition_initial_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    enrollment_reason_martenal_death varchar(255),
    enrollment_reason_malnutrition varchar(255),
    enrollment_reason_poser_support varchar(255),
    enrollment_reason_other varchar(255),
    primary key (nutrition_initial_visit_id)
);

drop temporary table if exists temp_reason_enrolled_in_food_program;
create temporary table temp_reason_enrolled_in_food_program as select encounter_id, value_coded from omrs_obs where concept = 'Reason enrolled in food program';
alter table temp_reason_enrolled_in_food_program add index temp_reason_enrolled_in_food_program_encounter_idx (encounter_id);

insert into mw_nutrition_pdc_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when reason_enrolled_in_food_program.value_coded = 'Maternal Death' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_martenal_death,
    max(case when reason_enrolled_in_food_program.value_coded = 'Malnutrition' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_malnutrition,
    max(case when reason_enrolled_in_food_program.value_coded = 'Other non-coded (text)' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_other,
    max(case when reason_enrolled_in_food_program.value_coded = 'Poser Support' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_poser_support
from omrs_encounter e
left join temp_reason_enrolled_in_food_program reason_enrolled_in_food_program on e.encounter_id = reason_enrolled_in_food_program.encounter_id
where e.encounter_type in ('NUTRITION_PDC_INITIAL')
group by e.patient_id, e.encounter_date, e.location;