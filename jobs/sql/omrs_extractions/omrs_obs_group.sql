SELECT      o.obs_id as obs_group_id,
            o.uuid,
            p.person_id as patient_id,
            o.encounter_id,
            DATE(o.obs_datetime) as obs_group_date,
            TIME(o.obs_datetime) as obs_group_time,
            et.name as encounter_type,
            l.name as location,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = o.concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as concept,
            DATE(o.date_created) as date_created
FROM        obs o
INNER JOIN  person p ON o.person_id = p.person_id
LEFT JOIN   encounter e ON o.encounter_id = e.encounter_id
LEFT JOIN   encounter_type et ON et.encounter_type_id = e.encounter_type
LEFT JOIN   location l ON l.location_id = e.location_id
WHERE       o.voided = 0
AND         p.voided = 0
AND         o.obs_id IN (SELECT DISTINCT obs_group_id FROM obs WHERE obs_group_id IS NOT NULL)
