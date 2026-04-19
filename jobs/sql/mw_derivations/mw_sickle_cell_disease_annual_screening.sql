-- Derivation script for mw_sickle_cell_disease_annual_screening
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-annual-screening.ktr

drop table if exists mw_sickle_cell_disease_annual_screening;
create table mw_sickle_cell_disease_annual_screening (
  sickle_cell_disease_annual_screening_visit_id int not null auto_increment,
  patient_id int(11) not null,
  visit_date date null default null,
  location varchar(255) null default null,
  cr int null default null,
  alt int null default null,
  ast int null default null,
  bil int null,
  dir_bil int null,
  in_bili int null,
  primary key (sickle_cell_disease_annual_screening_visit_id));

insert into mw_sickle_cell_disease_annual_screening
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Creatinine' then o.value_numeric end) as cr,
    max(case when o.concept = 'Serum glutamic-pyruvic transaminase' then o.value_numeric end) as alt,
    max(case when o.concept = 'Total bilirubin' then o.value_numeric end) as bil,
    max(case when o.concept = 'Serum glutamic-oxaloacetic transaminase' then o.value_numeric end) as ast,
    max(case when o.concept = 'Direct bilirubin' then o.value_numeric end) as dir_bil,
    max(case when o.concept = 'Indirect bilirubin' then o.value_numeric end) as in_bili
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('SICKLE_CELL_ANNUAL_SCREENING')
group by e.patient_id, e.encounter_date, e.location;