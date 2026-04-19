-- Derivation script for mw_eid_register
-- Generated from Pentaho transform: import-into-mw-eid-register.ktr

drop table if exists mw_eid_register;
create table mw_eid_register (
  enrollment_id                    int not null,
  patient_id                       int not null,
  location                         varchar(255),
  eid_number                       varchar(50),
  mother_art_number				   varchar(100),
  start_date                       date,
  end_date                         date,
  outcome                          varchar(100),
  last_eid_visit_id                int
);
alter table mw_eid_register add index mw_eid_register_patient_idx (patient_id);
alter table mw_eid_register add index mw_eid_register_patient_location_idx (patient_id, location);

insert into mw_eid_register
select
    p.program_enrollment_id as enrollment_id,
    s.patient_id,
    s.location,
    i.identifier as eid_number,
    mo.mother_art_number,
    s.start_date,
    ifnull(s.end_date, p.completion_date) as end_date,
    ifnull(nextStateForEnrollment(p.program_enrollment_id, s.end_date), p.outcome) as outcome,
    lv.last_eid_visit_id
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
        and i1.type = 'HCC Number'
        order by i1.date_created desc
        limit 1
    )
    and i.type = 'HCC Number'
) i on i.patient_id = s.patient_id and i.location = s.location
left join (
    select o.patient_id, group_concat(o.value_text) as mother_art_number
    from omrs_obs o
    where o.concept = 'Mother ART registration number'
    group by o.patient_id
) mo on mo.patient_id = s.patient_id
left join (
    select v.patient_id, v.eid_visit_id as last_eid_visit_id
    from mw_eid_visits v
    where v.eid_visit_id = (
        select v1.eid_visit_id
        from mw_eid_visits v1
        where v1.patient_id = v.patient_id
        order by v1.visit_date desc
        limit 1
    )
) lv on lv.patient_id = s.patient_id
where s.program = 'HIV program'
and s.workflow = 'Treatment status'
and s.state = 'Exposed Child (Continue)';
