-- Derivation script for mw_nutrition_infant_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-infant-followup.ktr

drop table if exists mw_nutrition_infant_followup;
create table mw_nutrition_infant_followup (
nutrition_infant_followup_id int not null auto_increment,
patient_id int not null,
visit_date date,
location varchar(255),
weight decimal(10,2),
height decimal(10,2),
muac decimal(10,2),
lactogen_tins varchar(255),
next_appointment_date date,
ration varchar(255),
comments varchar(255),
primary key (nutrition_infant_followup_id)
);

insert into mw_nutrition_infant_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Given name' then o.value_text end) as ration,
    max(case when o.concept = 'Clinical impression comments' then o.value_text end) as comments,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Number of lactogen tins' then o.value_numeric end) as lactogen_tins,
    max(case when o.concept = 'muac' then o.value_numeric end) as muac,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('NUTRITION_INFANT_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;