drop temporary table if exists temp_concept_question;
create temporary table temp_concept_question
(
    concept_id int,
    name varchar(255)
);
insert into temp_concept_question (concept_id) select concept_id from concept;
update temp_concept_question n
set n.name = (
    select cn.name from concept_name cn
    where cn.concept_id = n.concept_id AND cn.voided = 0
    order by if(cn.concept_name_type='FULLY_SPECIFIED', 0, 1), if(cn.locale='en', 0, 1), cn.locale_preferred desc limit 1
);
alter table temp_concept_question add index temp_concept_question_concept_idx (concept_id);

drop temporary table if exists temp_concept_answer;
create temporary table temp_concept_answer as select * from temp_concept_question;
alter table temp_concept_answer add index temp_concept_answer_concept_idx (concept_id);

drop temporary table if exists temp_obs_group;
create temporary table temp_obs_group as select obs_group_id from obs where obs_group_id is not null and voided = 0;
alter table temp_obs_group add index temp_obs_group_idx (obs_group_id);

SELECT      o.obs_id,
            o.uuid,
            p.person_id as patient_id,
            o.encounter_id,
            DATE(o.obs_datetime) as obs_date,
            TIME(o.obs_datetime) as obs_time,
            IF(p.birthdate IS NULL OR o.obs_datetime IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, o.obs_datetime)) as age_years_at_obs,
            IF(p.birthdate IS NULL OR o.obs_datetime IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, o.obs_datetime)) as age_months_at_obs,
            et.name as encounter_type,
            f.name as form,
            l.name as location,
            q.name as concept,
            a.name as value_coded,
            DATE(o.value_datetime) as value_date,
            o.value_numeric,
            o.value_text,
            o.comments,
            o.obs_group_id,
            DATE(o.date_created) as date_created
FROM        obs o
INNER JOIN  person p ON o.person_id = p.person_id
LEFT JOIN   encounter e ON o.encounter_id = e.encounter_id
LEFT JOIN   encounter_type et ON et.encounter_type_id = e.encounter_type
LEFT JOIN   form f ON f.form_id = e.form_id
LEFT JOIN   location l ON l.location_id = e.location_id
LEFT JOIN   temp_concept_question q on o.concept_id = q.concept_id
LEFT JOIN   temp_concept_answer a on o.concept_id = a.concept_id
LEFT JOIN   temp_obs_group g on o.obs_id = g.obs_group_id
WHERE       o.voided = 0
AND         p.voided = 0
AND         g.obs_group_id is null
;