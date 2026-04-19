-- Derivation script for mw_poc_bp
-- Generated from Pentaho transform: import-into-mw-poc-bp.ktr

drop table if exists mw_poc_bp;
create table mw_poc_bp (
    poc_bp_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    diastolic_blood_pressure decimal(10,2),
    pulse decimal(10,2),
    systolic_blood_pressure decimal(10,2),
    primary key (poc_bp_visit_id)
);

insert into mw_poc_bp
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Diastolic blood pressure' then o.value_numeric end) as diastolic_blood_pressure,
    max(case when o.concept = 'Pulse' then o.value_numeric end) as pulse,
    max(case when o.concept = 'Systolic blood pressure' then o.value_numeric end) as systolic_blood_pressure
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Blood pressure screening')
group by e.patient_id, e.encounter_date, e.location;