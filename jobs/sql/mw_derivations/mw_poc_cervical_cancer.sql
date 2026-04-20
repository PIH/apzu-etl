-- Derivation script for mw_poc_cervical_cancer
-- Generated from Pentaho transform: import-into-mw-poc-cervical-cancer.ktr

drop table if exists mw_poc_cervical_cancer;
create table mw_poc_cervical_cancer (
    poc_cervical_cancer_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    colposcopy_of_cervix_with_acetic_acid varchar(255),
    primary key (poc_cervical_cancer_visit_id)
);

drop temporary table if exists temp_colposcopy_of_cervix_with_acetic_acid;
create temporary table temp_colposcopy_of_cervix_with_acetic_acid as select encounter_id, value_coded from omrs_obs where concept = 'Colposcopy of cervix with acetic acid';
alter table temp_colposcopy_of_cervix_with_acetic_acid add index temp_colposcopy_cervix_acetic_acid_encounter_idx (encounter_id);

insert into mw_poc_cervical_cancer (patient_id, visit_date, location, colposcopy_of_cervix_with_acetic_acid)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(colposcopy_of_cervix_with_acetic_acid.value_coded) as colposcopy_of_cervix_with_acetic_acid
from omrs_encounter e
left join temp_colposcopy_of_cervix_with_acetic_acid colposcopy_of_cervix_with_acetic_acid on e.encounter_id = colposcopy_of_cervix_with_acetic_acid.encounter_id
where e.encounter_type in ('Cervical Cancer Screening')
group by e.patient_id, e.encounter_date, e.location;