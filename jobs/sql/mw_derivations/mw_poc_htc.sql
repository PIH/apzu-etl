-- Derivation script for mw_poc_htc
-- Generated from Pentaho transform: import-into-mw-poc-htc.ktr

drop table if exists mw_poc_htc;
create table mw_poc_htc (
    poc_htc_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    result_of_hiv_test_htc varchar(255),
    hiv_test_type_htc varchar(255),    
    primary key (poc_htc_visit_id)
);

insert into mw_poc_htc
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'HIV test type' then o.value_coded end) as hiv_test_type_htc,
    max(case when o.concept = 'Result of HIV test' then o.value_coded end) as result_of_hiv_test_htc
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('HTC screening')
group by e.patient_id, e.encounter_date, e.location;