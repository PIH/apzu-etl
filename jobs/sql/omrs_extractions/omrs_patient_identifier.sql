SELECT      i.patient_identifier_id,
            i.uuid,
            p.patient_id,
            pit.name as type,
            i.identifier,
            l.name as location,
            DATE(i.date_created) as date_created
FROM        patient p
INNER JOIN  patient_identifier i ON i.patient_id = p.patient_id
LEFT JOIN   patient_identifier_type pit ON pit.patient_identifier_type_id = i.identifier_type
LEFT JOIN   location l ON l.location_id = i.location_id
WHERE       i.voided = 0
AND         p.voided = 0
AND         i.identifier IS NOT NULL
AND         i.identifier != ''
