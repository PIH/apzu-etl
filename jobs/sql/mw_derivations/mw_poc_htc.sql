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

drop temporary table if exists temp_hiv_test_type;
create temporary table temp_hiv_test_type as select encounter_id, value_coded from omrs_obs where concept = 'HIV test type';
alter table temp_hiv_test_type add index temp_hiv_test_type_encounter_idx (encounter_id);

drop temporary table if exists temp_result_of_hiv_test;
create temporary table temp_result_of_hiv_test as select encounter_id, value_coded from omrs_obs where concept = 'Result of HIV test';
alter table temp_result_of_hiv_test add index temp_result_of_hiv_test_encounter_idx (encounter_id);

insert into mw_poc_htc
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(hiv_test_type.value_coded) as hiv_test_type_htc,
    max(result_of_hiv_test.value_coded) as result_of_hiv_test_htc
from omrs_encounter e
left join temp_hiv_test_type hiv_test_type on e.encounter_id = hiv_test_type.encounter_id
left join temp_result_of_hiv_test result_of_hiv_test on e.encounter_id = result_of_hiv_test.encounter_id
where e.encounter_type in ('HTC screening')
group by e.patient_id, e.encounter_date, e.location;