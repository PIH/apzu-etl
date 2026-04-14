SELECT      ep.encounter_provider_id,
            ep.uuid,
            e.encounter_id,
            e.uuid as encounter_uuid,
            COALESCE(CONCAT_WS(' ', n.given_name, n.middle_name, n.family_name_prefix, n.family_name, n.family_name2, n.family_name_suffix), pr.name, pr.identifier, 'Unknown') as provider,
            er.name as provider_role
FROM        encounter_provider ep
INNER JOIN  encounter e ON e.encounter_id = ep.encounter_id
LEFT JOIN   provider pr ON pr.provider_id = ep.provider_id
LEFT JOIN   encounter_role er ON er.encounter_role_id = ep.encounter_role_id
LEFT JOIN   person_name n ON pr.person_id = n.person_id
            AND n.person_name_id = (
                SELECT  n2.person_name_id
                FROM    person_name n2
                WHERE   n2.voided = 0
                AND     n2.person_id = pr.person_id
                ORDER BY n2.preferred DESC, n2.date_created DESC LIMIT 1
            )
WHERE       ep.voided = 0
AND         e.voided = 0
