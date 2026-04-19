-- Derivation script for mw_pre_art_register
-- Generated from Pentaho transform: import-into-mw-pre-art-register.ktr

drop table if exists mw_pre_art_register;
create table mw_pre_art_register (
  enrollment_id  int not null,
  patient_id     int not null,
  location       varchar(255),
  pre_art_number varchar(50),
  start_date     date,
  end_date       date,
  outcome        varchar(100)
);
alter table mw_pre_art_register add index mw_pre_art_register_patient_idx (patient_id);
alter table mw_pre_art_register add index mw_pre_art_register_patient_location_idx (patient_id, location);

insert into mw_pre_art_register
select
    p.program_enrollment_id as enrollment_id,
    s.patient_id,
    s.location,
    i.identifier as pre_art_number,
    s.start_date,
    ifnull(s.end_date, p.completion_date) as end_date,
    ifnull(nextStateForEnrollment(p.program_enrollment_id, s.end_date), p.outcome) as outcome
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
) i on i.patient_id = s.patient_id and i.location = s.location
where s.program = 'HIV program'
and s.workflow = 'Treatment status'
and s.state = 'Pre-ART (Continue)';
