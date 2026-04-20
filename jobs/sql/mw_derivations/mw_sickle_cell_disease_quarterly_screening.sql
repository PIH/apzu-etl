-- Derivation script for mw_sickle_cell_disease_quarterly_screening
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-quarterly-screening.ktr

drop table if exists mw_sickle_cell_disease_quarterly_screening;
create table mw_sickle_cell_disease_quarterly_screening (
  sickle_cell_disease_quarterly_screening_visit_id int not null auto_increment,
  patient_id int(11) not null,
  visit_date date null default null,
  location varchar(255) null default null,
  hiv_status varchar(255) null default null,
  fcb varchar(255) null default null,
  primary key (sickle_cell_disease_quarterly_screening_visit_id));

drop temporary table if exists temp_blood_typing;
create temporary table temp_blood_typing as select encounter_id, value_coded from omrs_obs where concept = 'Blood typing';
alter table temp_blood_typing add index temp_blood_typing_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

insert into mw_sickle_cell_disease_quarterly_screening
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(blood_typing.value_coded) as fcb,
    max(hiv_status.value_coded) as hiv_status
from omrs_encounter e
left join temp_blood_typing blood_typing on e.encounter_id = blood_typing.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
where e.encounter_type in ('SICKLE_CELL_QUARTERLY_SCREENING')
group by e.patient_id, e.encounter_date, e.location;