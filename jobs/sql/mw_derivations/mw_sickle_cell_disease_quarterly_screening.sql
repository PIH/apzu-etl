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

insert into mw_sickle_cell_disease_quarterly_screening
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Blood typing' then o.value_coded end) as fcb,
    max(case when o.concept = 'HIV status' then o.value_coded end) as hiv_status
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('SICKLE_CELL_QUARTERLY_SCREENING')
group by e.patient_id, e.encounter_date, e.location;