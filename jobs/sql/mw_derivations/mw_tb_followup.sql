-- Derivation script for mw_tb_followup
-- Generated from Pentaho transform: import-into-mw-tb-followup.ktr

drop table if exists mw_tb_followup;
create table mw_tb_followup (
  tb_followup_visit_id 			int not null auto_increment,
  patient_id    				int not null,
  visit_date            		date,
  location              		varchar(255),
  rhze_regimen 					int,
  rh_regimen 					int,
  meningitis_regimen			int,
  next_appointment_date 		date,
     primary key (tb_followup_visit_id)
);

insert into mw_tb_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'RH Meningitis Tablets' then o.value_numeric end) as meningitis_regimen,
    max(case when o.concept = 'RH Regimen Tablets' then o.value_numeric end) as rh_regimen,
    max(case when o.concept = 'Number of RHZE Tablets' then o.value_numeric end) as rhze_regimen
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('TB_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;