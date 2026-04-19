drop table if exists mw_lab_tests;
create table mw_lab_tests (
  lab_test_id          int not null auto_increment primary key,
  patient_id           int not null,
  encounter_id         int,
  date_collected       date,
  test_type            varchar(100),
  date_result_received date,
  date_result_entered  date,
  result_coded         varchar(100),
  result_numeric       decimal(10,2),
  result_exception     varchar(100)
);
alter table mw_lab_tests add index mw_lab_tests_patient_idx (patient_id);
alter table mw_lab_tests add index mw_lab_tests_patient_type_idx (patient_id, test_type);

-- HIV test results (grouped by obs_group from omrs_obs_group with concept 'Child HIV serology construct')
insert into mw_lab_tests (patient_id, encounter_id, date_collected, test_type, date_result_received, date_result_entered, result_coded)
select
    g.patient_id,
    g.encounter_id,
    max(case when o.concept = 'Date of blood sample' then o.value_date end) as date_collected,
    max(case when o.concept = 'HIV test type' then o.value_coded end) as test_type,
    max(case when o.concept = 'Date of returned result' then o.value_date end) as date_result_received,
    max(case when o.concept = 'Result of HIV test' then date(o.date_created) end) as date_result_entered,
    max(case when o.concept = 'Result of HIV test' then o.value_coded end) as result_coded
from omrs_obs_group g
inner join omrs_obs o on o.obs_group_id = g.obs_group_id
where g.concept = 'Child HIV serology construct'
group by g.patient_id, g.encounter_id, g.obs_group_id;

-- Viral load results
insert into mw_lab_tests (patient_id, encounter_id, date_collected, test_type, date_result_received, date_result_entered, result_numeric, result_exception)
select
    o.patient_id,
    o.encounter_id,
    max(case when o.concept = 'Sample taken for Viral Load' and o.value_coded = 'True' then o.obs_date end) as date_collected,
    'Viral Load' as test_type,
    null as date_result_received,
    max(case when o.concept = 'HIV viral load' then date(o.date_created) end) as date_result_entered,
    max(case when o.concept = 'HIV viral load' then o.value_numeric end) as result_numeric,
    max(case when o.concept = 'Lower than Detection Limit' and o.value_coded = 'True' then o.concept
             when o.concept = 'Less than limit' then concat('<', o.value_numeric) end) as result_exception
from omrs_obs o
where o.concept in ('Sample taken for Viral Load', 'HIV viral load', 'Lower than Detection Limit', 'Less than limit')
group by o.patient_id, o.encounter_id
having max(case when o.concept in ('HIV viral load', 'Lower than Detection Limit', 'Less than limit') then 1 end) = 1;
