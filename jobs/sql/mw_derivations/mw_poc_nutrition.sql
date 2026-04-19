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

insert into mw_poc_nutrition
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Middle upper arm circumference (cm)' then o.value_numeric end) as muac,
    max(case when o.concept = 'Is patient pregnant?' then o.value_coded end) as is_patient_preg,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Nutrition Screening')
group by e.patient_id, e.encounter_date, e.location;