SELECT      e.encounter_id,
            e.uuid,
            e.patient_id,
            et.name as encounter_type,
            f.name as form,
            l.name as location,
            DATE(e.encounter_datetime) as encounter_date,
            TIME(e.encounter_datetime) as encounter_time,
            COALESCE(CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name_prefix, pn.family_name, pn.family_name2, pn.family_name_suffix), pr.name, pr.identifier, 'Unknown') as provider,
            er.name as provider_role,
            e.visit_id,
            IF(p.birthdate IS NULL OR e.encounter_datetime IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, e.encounter_datetime)) as age_years_at_encounter,
            IF(p.birthdate IS NULL OR e.encounter_datetime IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, e.encounter_datetime)) as age_months_at_encounter,
            DATE(e.date_created) as date_created,
            COALESCE(u.username, u.system_id) as created_by
FROM        encounter e
INNER JOIN  person p ON e.patient_id = p.person_id
LEFT JOIN   encounter_type et ON et.encounter_type_id = e.encounter_type
LEFT JOIN   form f ON f.form_id = e.form_id
LEFT JOIN   location l ON l.location_id = e.location_id
LEFT JOIN   users u ON u.user_id = e.creator
LEFT JOIN   encounter_provider ep ON ep.encounter_id = e.encounter_id
            AND ep.encounter_provider_id = (
                SELECT  ep2.encounter_provider_id
                FROM    encounter_provider ep2
                WHERE   ep2.encounter_id = e.encounter_id
                AND     ep2.voided = 0
                ORDER BY ep2.encounter_provider_id LIMIT 1
            )
LEFT JOIN   provider pr ON pr.provider_id = ep.provider_id
LEFT JOIN   encounter_role er ON er.encounter_role_id = ep.encounter_role_id
LEFT JOIN   person_name pn ON pn.person_id = pr.person_id
            AND pn.person_name_id = (
                SELECT  pn2.person_name_id
                FROM    person_name pn2
                WHERE   pn2.voided = 0
                AND     pn2.person_id = pr.person_id
                ORDER BY pn2.preferred DESC, pn2.date_created DESC LIMIT 1
            )
WHERE       e.voided = 0
AND         p.voided = 0
