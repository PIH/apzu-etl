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

insert into mw_tb_post_lung_disease
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date registered in Post TB Lung Disease (PTLD)' then o.value_date end) as second_visit_date,
    max(case when o.concept = 'Number of weeks on treatment' then o.value_numeric end) as number_of_weeks
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('TB_POST_LUNG_DISEASE')
group by e.patient_id, e.encounter_date, e.location;