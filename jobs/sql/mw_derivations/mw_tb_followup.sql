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

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_rh_meningitis_tablets;
create temporary table temp_rh_meningitis_tablets as select encounter_id, value_numeric from omrs_obs where concept = 'RH Meningitis Tablets';
alter table temp_rh_meningitis_tablets add index temp_rh_meningitis_tablets_encounter_idx (encounter_id);

drop temporary table if exists temp_rh_regimen_tablets;
create temporary table temp_rh_regimen_tablets as select encounter_id, value_numeric from omrs_obs where concept = 'RH Regimen Tablets';
alter table temp_rh_regimen_tablets add index temp_rh_regimen_tablets_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_rhze_tablets;
create temporary table temp_number_of_rhze_tablets as select encounter_id, value_numeric from omrs_obs where concept = 'Number of RHZE Tablets';
alter table temp_number_of_rhze_tablets add index temp_number_of_rhze_tablets_encounter_idx (encounter_id);

insert into mw_tb_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(appointment_date.value_date) as next_appointment_date,
    max(rh_meningitis_tablets.value_numeric) as meningitis_regimen,
    max(rh_regimen_tablets.value_numeric) as rh_regimen,
    max(number_of_rhze_tablets.value_numeric) as rhze_regimen
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_rh_meningitis_tablets rh_meningitis_tablets on e.encounter_id = rh_meningitis_tablets.encounter_id
left join temp_rh_regimen_tablets rh_regimen_tablets on e.encounter_id = rh_regimen_tablets.encounter_id
left join temp_number_of_rhze_tablets number_of_rhze_tablets on e.encounter_id = number_of_rhze_tablets.encounter_id
where e.encounter_type in ('TB_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;