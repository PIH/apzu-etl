-- Derivation script for mw_tb_post_lung_disease
-- Generated from Pentaho transform: import-into-mw-tb-post-lung-disease.ktr

drop table if exists mw_tb_post_lung_disease;
create table mw_tb_post_lung_disease (
  tb_post_lung_disease_visit_id 		int not null auto_increment,
  patient_id    				int not null,
  visit_date            		date,
  location              		varchar(255),
  number_of_weeks 					int,
  second_visit_date 		date,
     primary key (tb_post_lung_disease_visit_id)
);

drop temporary table if exists temp_date_registered_in_post_tb_lung_disease_ptld;
create temporary table temp_date_registered_in_post_tb_lung_disease_ptld as select encounter_id, value_date from omrs_obs where concept = 'Date registered in Post TB Lung Disease (PTLD)';
alter table temp_date_registered_in_post_tb_lung_disease_ptld add index temp_date_registered_in_post_tb_lung_disease_ptld_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_weeks_on_treatment;
create temporary table temp_number_of_weeks_on_treatment as select encounter_id, value_numeric from omrs_obs where concept = 'Number of weeks on treatment';
alter table temp_number_of_weeks_on_treatment add index temp_number_of_weeks_on_treatment_encounter_idx (encounter_id);

insert into mw_tb_post_lung_disease
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_registered_in_post_tb_lung_disease_ptld.value_date) as second_visit_date,
    max(number_of_weeks_on_treatment.value_numeric) as number_of_weeks
from omrs_encounter e
left join temp_date_registered_in_post_tb_lung_disease_ptld date_registered_in_post_tb_lung_disease_ptld on e.encounter_id = date_registered_in_post_tb_lung_disease_ptld.encounter_id
left join temp_number_of_weeks_on_treatment number_of_weeks_on_treatment on e.encounter_id = number_of_weeks_on_treatment.encounter_id
where e.encounter_type in ('TB_POST_LUNG_DISEASE')
group by e.patient_id, e.encounter_date, e.location;