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

insert into mw_nutrition_adult_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Given name' then o.value_text end) as warehouse_signature,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment,
    max(case when o.concept = 'Body mass index, measured' then o.value_numeric end) as bmi,
    max(case when o.concept = 'Clinical impression comments' then o.value_text end) as comments,
    max(case when o.concept = 'Likuni Phala given to patient(Kg)' then o.value_numeric end) as food_likuni_phala,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('NUTRITION_ADULTS_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;