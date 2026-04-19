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

insert into mw_poc_cervical_cancer
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Colposcopy of cervix with acetic acid' then o.value_coded end) as colposcopy_of_cervix_with_acetic_acid
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Cervical Cancer Screening')
group by e.patient_id, e.encounter_date, e.location;