drop temporary table if exists temp_patient;
create temporary table temp_patient (
  patient_id            INT NOT NULL PRIMARY KEY,
  patient_uuid	 	    CHAR(38),
  first_name            VARCHAR(50),
  last_name             VARCHAR(50),
  gender                CHAR(1),
  birthdate             DATE,
  birthdate_estimated   BOOLEAN,
  phone_number          VARCHAR(50),
  district              VARCHAR(255),
  traditional_authority VARCHAR(255),
  village               VARCHAR(255),
  chw_person_id         INT,
  chw                   VARCHAR(100),
  dead                  BOOLEAN,
  death_date            DATE
);

insert into temp_patient (patient_id, patient_uuid, gender, birthdate, birthdate_estimated, dead, death_date)
select      n.person_id as patient_id,
            n.uuid as patient_uuid,
            n.gender,
            n.birthdate,
            n.birthdate_estimated,
            n.dead,
            n.death_date
from        patient p
inner join  person n on p.patient_id = n.person_id
where       p.voided = 0
  and       n.voided = 0
;

update temp_patient set first_name = person_given_name(patient_id);
update temp_patient set last_name = person_family_name(patient_id);
update temp_patient set phone_number = phone_number(patient_id);
update temp_patient set district = person_address_state_province(patient_id);
update temp_patient set traditional_authority = person_address_county_district(patient_id);
update temp_patient set village = person_address_city_village(patient_id);

select relationship_type_id into @chwRelationshipType from relationship_type where a_is_to_b = 'Community Health Worker';

update temp_patient p set chw_person_id = (
    select r.person_a
    from relationship r
    where r.person_b = p.patient_id
    and r.voided = 0
    and r.relationship = @chwRelationshipType
    order by if(r.end_date is null, 1, 0) desc, if(r.start_date is null, 0, 1) desc, r.date_created desc
    limit 1
);

update temp_patient set chw = person_name(chw_person_id);

select
    patient_id,
    patient_uuid,
    first_name,
    last_name,
    gender,
    birthdate,
    birthdate_estimated,
    phone_number,
    district,
    traditional_authority,
    village,
    chw,
    dead,
    death_date
from temp_patient;