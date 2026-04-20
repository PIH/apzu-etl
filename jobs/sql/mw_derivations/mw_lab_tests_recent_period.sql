drop table if exists mw_lab_tests_recent_period;
create table mw_lab_tests_recent_period (
  lab_test_id          int not null,
  patient_id           int not null,
  encounter_id         int,
  date_collected       date,
  test_type            varchar(100),
  date_result_received date,
  date_result_entered  date,
  result_coded         varchar(100),
  result_numeric       decimal(10,2),
  result_exception     varchar(100),
  end_date             date
);

-- Most recent lab test result per patient per reporting period
insert into mw_lab_tests_recent_period (lab_test_id, patient_id, encounter_id, date_collected, test_type, date_result_received, date_result_entered, result_coded, result_numeric, result_exception, end_date)
select
    t.lab_test_id,
    t.patient_id,
    t.encounter_id,
    t.date_collected,
    t.test_type,
    t.date_result_received,
    t.date_result_entered,
    t.result_coded,
    t.result_numeric,
    t.result_exception,
    p.end_date
from mw_selected_periods p
CROSS join omrs_patient pat
inner join omrs_program_enrollment enr on enr.patient_id = pat.patient_id and enr.program = 'HIV Program'
inner join (
    select
        t1.patient_id,
        p1.end_date,
        min(t1.lab_test_id) as last_test_id
    from (
        select
            t2.patient_id,
            p2.end_date,
            max(t2.date_collected) as last_test_date
        from mw_lab_tests t2
        CROSS join mw_selected_periods p2
        where t2.test_type = 'Viral Load'
        and t2.date_collected <= p2.end_date
        group by t2.patient_id, p2.end_date
    ) latest
    inner join mw_lab_tests t1
        on t1.patient_id = latest.patient_id
        and t1.date_collected = latest.last_test_date
    inner join mw_selected_periods p1
        on p1.end_date = latest.end_date
    where t1.test_type = 'Viral Load'
    group by t1.patient_id, p1.end_date
) most_recent on most_recent.patient_id = pat.patient_id and most_recent.end_date = p.end_date
inner join mw_lab_tests t on t.lab_test_id = most_recent.last_test_id;
