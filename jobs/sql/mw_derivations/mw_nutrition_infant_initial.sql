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

insert into mw_nutrition_infant_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Reason enrolled in food program' and o.value_coded = 'Multiple births' then o.value_coded end) as enrollment_reason_multiple_births,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as enrollment_reason_other,
    max(case when o.concept = 'Reason enrolled in food program' and o.value_coded = 'Severe Maternal Illness' then o.value_coded end) as enrollment_reason_severe_maternal_illness,
    max(case when o.concept = 'Reason enrolled in food program' and o.value_coded = 'Maternal Death' then o.value_coded end) as enrollment_reason_severe_maternal_Death
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('NUTRITION_INFANT_INITIAL')
group by e.patient_id, e.encounter_date, e.location;