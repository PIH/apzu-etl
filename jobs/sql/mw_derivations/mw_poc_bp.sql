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

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

insert into mw_poc_bp
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(diastolic_blood_pressure.value_numeric) as diastolic_blood_pressure,
    max(pulse.value_numeric) as pulse,
    max(systolic_blood_pressure.value_numeric) as systolic_blood_pressure
from omrs_encounter e
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
where e.encounter_type in ('Blood pressure screening')
group by e.patient_id, e.encounter_date, e.location;