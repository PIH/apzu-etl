-- Derivation script for mw_ncd_register
-- Generated from Pentaho transform: import-into-mw-ncd-register.ktr

drop table if exists mw_ncd_register;
create table mw_ncd_register (
  enrollment_id int not null,
  patient_id    int not null,
  location      varchar(255),
  ncd_number    varchar(50),
  start_date    date,
  end_date      date,
  outcome       varchar(100),
  cv_disease    boolean
);
alter table mw_ncd_register add index mw_ncd_register_patient_idx (patient_id);
alter table mw_ncd_register add index mw_ncd_register_patient_location_idx (patient_id, location);

insert into mw_ncd_register (enrollment_id, patient_id, location, ncd_number, start_date, end_date, outcome, cv_disease)
select
    p.program_enrollment_id as enrollment_id,
    p.patient_id,
    p.location,
    i.identifier as ncd_number,
    p.enrollment_date as start_date,
    p.completion_date as end_date,
    if(p.completion_date is null, null, ifnull(latest_state.state, p.outcome)) as outcome,
    max(case when o.value_coded = 'Cardiovascular disease' then TRUE else FALSE end) as cv_disease
from omrs_program_enrollment p
left join (
    select i.patient_id, i.location, i.identifier
    from omrs_patient_identifier i
    where i.patient_identifier_id = (
        select i1.patient_identifier_id
        from omrs_patient_identifier i1
        where i1.patient_id = i.patient_id
        and i1.location = i.location
        and i1.type = 'Chronic Care Number'
        order by i1.date_created desc
        limit 1
    )
) i on i.patient_id = p.patient_id and i.location = p.location
left join (
    select s.program_enrollment_id, s.state
    from omrs_program_state s
    where s.program_state_id = (
        select s1.program_state_id
        from omrs_program_state s1
        where s1.program_enrollment_id = s.program_enrollment_id
        and s1.program = 'Chronic care program'
        and s1.workflow = 'Chronic care treatment status'
        order by s1.start_date desc
        limit 1
    )
) latest_state on latest_state.program_enrollment_id = p.program_enrollment_id
left join omrs_obs o on o.patient_id = p.patient_id
where p.program = 'Chronic care program'
group by p.program_enrollment_id, p.patient_id, p.location, p.enrollment_date, p.completion_date, p.outcome, i.identifier, latest_state.state;
