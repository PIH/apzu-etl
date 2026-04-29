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

drop temporary table if exists temp_symptom_absent;
create temporary table temp_symptom_absent as select encounter_id, value_coded from omrs_obs where concept = 'Symptom absent';
alter table temp_symptom_absent add index temp_symptom_absent_encounter_idx (encounter_id);

drop temporary table if exists temp_symptom_present;
create temporary table temp_symptom_present as select encounter_id, value_coded from omrs_obs where concept = 'Symptom present';
alter table temp_symptom_present add index temp_symptom_present_encounter_idx (encounter_id);

insert into mw_poc_tb_screening (patient_id, visit_date, location, symptom_absent, symptom_present, creator)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(symptom_absent.value_coded) as symptom_absent,
    max(symptom_present.value_coded) as symptom_present,
    max(e.created_by) as creator
from omrs_encounter e
left join temp_symptom_absent symptom_absent on e.encounter_id = symptom_absent.encounter_id
left join temp_symptom_present symptom_present on e.encounter_id = symptom_present.encounter_id
where e.encounter_type in ('TB Screening')
group by e.patient_id, e.encounter_date, e.location;