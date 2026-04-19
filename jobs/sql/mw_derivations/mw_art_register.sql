-- Derivation script for mw_art_register
-- Generated from Pentaho transform: import-into-mw-art-register.ktr

drop table if exists mw_art_register;
create table mw_art_register (
  enrollment_id             int not null,
  patient_id                int not null,
  location                  varchar(255),
  art_number                varchar(50),
  start_date                date,
  end_date                  date,
  outcome                   varchar(100),
  last_art_visit_id         int,
  last_viral_load_test_id   int,
  last_viral_load_result_id int
);
alter table mw_art_register add index mw_art_register_patient_idx (patient_id);
alter table mw_art_register add index mw_art_register_patient_location_idx (patient_id, location);

insert into mw_art_register
select
    p.program_enrollment_id as enrollment_id,
    s.patient_id,
    s.location,
    i.identifier as art_number,
    s.start_date,
    ifnull(s.end_date, p.completion_date) as end_date,
    ifnull(nextStateForEnrollment(p.program_enrollment_id, s.end_date), p.outcome) as outcome,
    lv.last_art_visit_id,
    lt.last_viral_load_test_id,
    lr.last_viral_load_result_id
from omrs_program_state s
inner join omrs_program_enrollment p on p.program_enrollment_id = s.program_enrollment_id
left join (
    select i.patient_id, i.location, i.identifier
    from omrs_patient_identifier i
    where i.patient_identifier_id = (
        select i1.patient_identifier_id
        from omrs_patient_identifier i1
        where i1.patient_id = i.patient_id
        and i1.location = i.location
        and i1.type = 'ARV Number'
        order by i1.date_created desc
        limit 1
    )
) i on i.patient_id = s.patient_id and i.location = s.location
left join (
    select v.patient_id, v.art_visit_id as last_art_visit_id
    from mw_art_visits v
    where v.art_visit_id = (
        select v1.art_visit_id
        from mw_art_visits v1
        where v1.patient_id = v.patient_id
        order by v1.visit_date desc
        limit 1
    )
) lv on lv.patient_id = s.patient_id
left join (
    select t.patient_id, t.lab_test_id as last_viral_load_test_id
    from mw_lab_tests t
    where t.lab_test_id = (
        select t1.lab_test_id
        from mw_lab_tests t1
        where t1.patient_id = t.patient_id
        and t1.test_type = 'Viral Load'
        order by coalesce(t1.date_collected, t1.date_result_received, t1.date_result_entered) desc
        limit 1
    )
) lt on lt.patient_id = s.patient_id
left join (
    select t.patient_id, t.lab_test_id as last_viral_load_result_id
    from mw_lab_tests t
    where t.lab_test_id = (
        select t1.lab_test_id
        from mw_lab_tests t1
        where t1.patient_id = t.patient_id
        and t1.test_type = 'Viral Load'
        and (t1.result_numeric is not null or t1.result_exception is not null)
        order by coalesce(t1.date_collected, t1.date_result_received, t1.date_result_entered) desc
        limit 1
    )
) lr on lr.patient_id = s.patient_id
where s.program = 'HIV program'
and s.workflow = 'Treatment status'
and s.state = 'On antiretrovirals';
