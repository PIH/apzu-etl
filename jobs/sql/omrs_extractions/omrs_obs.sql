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
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = o.concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as concept,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = o.value_coded AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as value_coded,
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
WHERE       o.voided = 0
AND         p.voided = 0
AND         o.obs_id NOT IN (SELECT DISTINCT obs_group_id FROM obs WHERE obs_group_id IS NOT NULL)
