drop table if exists mw_eid_trace;
create table mw_eid_trace (
  patient_id                              int not null,
  location                                varchar(255),
  eid_number                              varchar(50),
  last_visit_date                         date,
  next_appointment_date                   date,
  birthdate                               date,
  breastfeeding_stopped_over_6_weeks_date date,
  last_pcr_result                         varchar(255),
  last_pcr_result_date                    date,
  second_to_last_pcr_result               varchar(255),
  second_to_last_pcr_result_date          date
);

-- Active EID patients with last visit, PCR results, and breastfeeding info
insert into mw_eid_trace (patient_id, location, eid_number, last_visit_date, next_appointment_date, birthdate, breastfeeding_stopped_over_6_weeks_date, last_pcr_result, last_pcr_result_date, second_to_last_pcr_result, second_to_last_pcr_result_date)
select
    r.patient_id,
    r.location,
    r.eid_number,
    v.visit_date as last_visit_date,
    v.next_appointment_date,
    p.birthdate,
    bf.breastfeeding_stopped_over_6_weeks_date,
    pcr1.last_pcr_result,
    pcr1.last_pcr_result_date,
    pcr2.second_to_last_pcr_result,
    pcr2.second_to_last_pcr_result_date
from mw_eid_register r
inner join mw_patient p on r.patient_id = p.patient_id
left join mw_eid_visits v on v.eid_visit_id = r.last_eid_visit_id
left join (
    -- Date on which patient first stopped breastfeeding over 6 weeks ago,
    -- after any other different breastfeeding status was recorded
    select
        v1.patient_id,
        min(v1.visit_date) as breastfeeding_stopped_over_6_weeks_date
    from mw_eid_visits v1
    left join (
        select v2.patient_id, max(v2.visit_date) as last_non_6_wk_status_date
        from mw_eid_visits v2
        where v2.breastfeeding_status != 'Breastfeeding stopped over 6 weeks ago'
        group by v2.patient_id
    ) ls on v1.patient_id = ls.patient_id
    where v1.breastfeeding_status = 'Breastfeeding stopped over 6 weeks ago'
    and (ls.last_non_6_wk_status_date is null or v1.visit_date >= ls.last_non_6_wk_status_date)
    group by v1.patient_id
) bf on bf.patient_id = r.patient_id
left join (
    -- Most recent PCR result
    select
        t.patient_id,
        t.result_coded as last_pcr_result,
        coalesce(t.date_collected, t.date_result_received, t.date_result_entered) as last_pcr_result_date
    from mw_lab_tests t
    where t.lab_test_id = (
        select t1.lab_test_id
        from mw_lab_tests t1
        where t1.patient_id = t.patient_id
        and t1.test_type = 'HIV DNA polymerase chain reaction'
        and t1.result_coded is not null
        order by coalesce(t1.date_collected, t1.date_result_received, t1.date_result_entered) desc
        limit 1
    )
) pcr1 on pcr1.patient_id = r.patient_id
left join (
    -- Second to last PCR result
    select
        t.patient_id,
        t.result_coded as second_to_last_pcr_result,
        coalesce(t.date_collected, t.date_result_received, t.date_result_entered) as second_to_last_pcr_result_date
    from mw_lab_tests t
    where t.lab_test_id = (
        select t1.lab_test_id
        from mw_lab_tests t1
        where t1.patient_id = t.patient_id
        and t1.test_type = 'HIV DNA polymerase chain reaction'
        and t1.result_coded is not null
        order by coalesce(t1.date_collected, t1.date_result_received, t1.date_result_entered) desc
        limit 1
        offset 1
    )
) pcr2 on pcr2.patient_id = r.patient_id
where r.end_date is null;
