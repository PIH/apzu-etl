-- Derivation script for mw_poc_tb_screening
-- Generated from Pentaho transform: import-into-mw-poc-tb-screening.ktr

drop table if exists mw_poc_tb_screening;
create table mw_poc_tb_screening (
    poc_tb_screening_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    creator varchar(255),
    symptom_present varchar(255),
    symptom_absent varchar(255),
    primary key (poc_tb_screening_visit_id)
);

insert into mw_poc_tb_screening
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Symptom absent' then o.value_coded end) as symptom_absent,
    max(case when o.concept = 'Symptom present' then o.value_coded end) as symptom_present
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('TB Screening')
group by e.patient_id, e.encounter_date, e.location;