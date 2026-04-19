drop temporary table if exists temp_concept_name;
create temporary table temp_concept_name
(
    concept_id int,
    name varchar(255)
);
alter table temp_concept_name add index temp_concept_name_concept_idx (concept_id);
insert into temp_concept_name (concept_id) select concept_id from concept;
update temp_concept_name n
set n.name = (
    select cn.name from concept_name cn
    where cn.concept_id = n.concept_id AND cn.voided = 0
    order by if(cn.concept_name_type='FULLY_SPECIFIED', 0, 1), if(cn.locale='en', 0, 1), cn.locale_preferred desc limit 1
);

drop temporary table if exists temp_obs_group;
create temporary table temp_obs_group as select obs_group_id from obs where obs_group_id is not null and voided = 0;
alter table temp_obs_group add index temp_obs_group_idx (obs_group_id);

SELECT      o.obs_id as obs_group_id,
            o.uuid,
            p.person_id as patient_id,
            o.encounter_id,
            DATE(o.obs_datetime) as obs_group_date,
            TIME(o.obs_datetime) as obs_group_time,
            et.name as encounter_type,
            l.name as location,
            n.name as concept,
            DATE(o.date_created) as date_created
FROM        obs o
INNER JOIN  temp_obs_group g on o.obs_id = g.obs_group_id
INNER JOIN  person p ON o.person_id = p.person_id
LEFT JOIN   encounter e ON o.encounter_id = e.encounter_id
LEFT JOIN   encounter_type et ON et.encounter_type_id = e.encounter_type
LEFT JOIN   location l ON l.location_id = e.location_id
LEFT JOIN   temp_concept_name n on o.concept_id = n.concept_id
WHERE       o.voided = 0
AND         p.voided = 0
;