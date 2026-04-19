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

insert into mw_nutrition_adult_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Reason enrolled in food program' and o.value_coded = 'Patient in tuberculosis treatment' then o.value_coded end) as enrollment_reason_tb,
    max(case when o.concept = 'Reason enrolled in food program' and o.value_coded = 'Patient in HIV treatment' then o.value_coded end) as enrollment_reason_hiv,
    max(case when o.concept = 'Reason enrolled in food program' and o.value_coded = 'Enrolled in NCD' then o.value_coded end) as enrollment_reason_ncd
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('NUTRITION_ADULTS_INITIAL')
group by e.patient_id, e.encounter_date, e.location;