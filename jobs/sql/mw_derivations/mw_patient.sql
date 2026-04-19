-- Derivation script for mw_patient
-- Generated from Pentaho transform: import-into-mw-patient.ktr

drop table if exists mw_patient;
create table mw_patient (
  patient_id            int not null,
  identifier            varchar(50),
  first_name            varchar(50),
  last_name             varchar(50),
  gender                char(1),
  birthdate             date,
  birthdate_estimated   boolean,
  phone_number          varchar(50),
  district              varchar(255),
  traditional_authority varchar(255),
  village               varchar(255),
  chw                   varchar(100),
  dead                  boolean,
  death_date            date,
  patient_uuid	 	 char(38)
);
alter table mw_patient add index mw_patient_id_idx (patient_id);

insert into mw_patient
select
    p.patient_id,
    p.identifier,
    p.first_name,
    p.last_name,
    p.gender,
    p.birthdate,
    p.birthdate_estimated,
    p.phone_number,
    p.state_province as district,
    p.county_district as traditional_authority,
    p.city_village as village,
    chw.related_person as chw,
    p.dead,
    p.death_date,
    p.patient_uuid
from omrs_patient p
left join omrs_relationship chw on chw.relationship_id = (
    select r.relationship_id
    from omrs_relationship r
    where r.patient_id = p.patient_id
    and r.related_person_role = 'Community Health Worker'
    order by if(r.end_date is null, 1, 0) desc,
             if(r.start_date is null, 0, 1) desc,
             r.date_created desc
    limit 1
);
