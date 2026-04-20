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

drop temporary table if exists temp_creatinine;
create temporary table temp_creatinine as select encounter_id, value_numeric from omrs_obs where concept = 'Creatinine';
alter table temp_creatinine add index temp_creatinine_encounter_idx (encounter_id);

drop temporary table if exists temp_serum_glutamic_pyruvic_transaminase;
create temporary table temp_serum_glutamic_pyruvic_transaminase as select encounter_id, value_numeric from omrs_obs where concept = 'Serum glutamic-pyruvic transaminase';
alter table temp_serum_glutamic_pyruvic_transaminase add index temp_serum_glutamic_pyruvic_transaminase_encounter_idx (encounter_id);

drop temporary table if exists temp_total_bilirubin;
create temporary table temp_total_bilirubin as select encounter_id, value_numeric from omrs_obs where concept = 'Total bilirubin';
alter table temp_total_bilirubin add index temp_total_bilirubin_encounter_idx (encounter_id);

drop temporary table if exists temp_serum_glutamic_oxaloacetic_transaminase;
create temporary table temp_serum_glutamic_oxaloacetic_transaminase as select encounter_id, value_numeric from omrs_obs where concept = 'Serum glutamic-oxaloacetic transaminase';
alter table temp_serum_glutamic_oxaloacetic_transaminase add index temp_serum_glutamic_oxaloacetic_transaminase_encounter_idx (encounter_id);

drop temporary table if exists temp_direct_bilirubin;
create temporary table temp_direct_bilirubin as select encounter_id, value_numeric from omrs_obs where concept = 'Direct bilirubin';
alter table temp_direct_bilirubin add index temp_direct_bilirubin_encounter_idx (encounter_id);

drop temporary table if exists temp_indirect_bilirubin;
create temporary table temp_indirect_bilirubin as select encounter_id, value_numeric from omrs_obs where concept = 'Indirect bilirubin';
alter table temp_indirect_bilirubin add index temp_indirect_bilirubin_encounter_idx (encounter_id);

insert into mw_sickle_cell_disease_annual_screening
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(creatinine.value_numeric) as cr,
    max(serum_glutamic_pyruvic_transaminase.value_numeric) as alt,
    max(total_bilirubin.value_numeric) as bil,
    max(serum_glutamic_oxaloacetic_transaminase.value_numeric) as ast,
    max(direct_bilirubin.value_numeric) as dir_bil,
    max(indirect_bilirubin.value_numeric) as in_bili
from omrs_encounter e
left join temp_creatinine creatinine on e.encounter_id = creatinine.encounter_id
left join temp_serum_glutamic_pyruvic_transaminase serum_glutamic_pyruvic_transaminase on e.encounter_id = serum_glutamic_pyruvic_transaminase.encounter_id
left join temp_total_bilirubin total_bilirubin on e.encounter_id = total_bilirubin.encounter_id
left join temp_serum_glutamic_oxaloacetic_transaminase serum_glutamic_oxaloacetic_transaminase on e.encounter_id = serum_glutamic_oxaloacetic_transaminase.encounter_id
left join temp_direct_bilirubin direct_bilirubin on e.encounter_id = direct_bilirubin.encounter_id
left join temp_indirect_bilirubin indirect_bilirubin on e.encounter_id = indirect_bilirubin.encounter_id
where e.encounter_type in ('SICKLE_CELL_ANNUAL_SCREENING')
group by e.patient_id, e.encounter_date, e.location;