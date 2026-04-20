-- Derivation script for mw_nutrition_infant_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-infant-initial.ktr

drop table if exists mw_nutrition_infant_initial;
create table mw_nutrition_infant_initial (
nutrition_initial_visit_id int not null auto_increment,
patient_id int not null,
visit_date date,
location varchar(255),
enrollment_reason_severe_maternal_illness varchar(255),
enrollment_reason_multiple_births varchar(255),
enrollment_reason_maternal_death varchar(255),
enrollment_reason_other varchar(255),
primary key (nutrition_initial_visit_id)
);

drop temporary table if exists temp_reason_enrolled_in_food_program;
create temporary table temp_reason_enrolled_in_food_program as select encounter_id, value_coded from omrs_obs where concept = 'Reason enrolled in food program';
alter table temp_reason_enrolled_in_food_program add index temp_reason_enrolled_in_food_program_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

insert into mw_nutrition_infant_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when reason_enrolled_in_food_program.value_coded = 'Multiple births' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_multiple_births,
    max(other_non_coded_text.value_text) as enrollment_reason_other,
    max(case when reason_enrolled_in_food_program.value_coded = 'Severe Maternal Illness' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_severe_maternal_illness,
    max(case when reason_enrolled_in_food_program.value_coded = 'Maternal Death' then reason_enrolled_in_food_program.value_coded end) as enrollment_reason_severe_maternal_Death
from omrs_encounter e
left join temp_reason_enrolled_in_food_program reason_enrolled_in_food_program on e.encounter_id = reason_enrolled_in_food_program.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
where e.encounter_type in ('NUTRITION_INFANT_INITIAL')
group by e.patient_id, e.encounter_date, e.location;