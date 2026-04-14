SELECT      v.visit_id,
            v.uuid,
            v.patient_id,
            vt.name as visit_type,
            l.name as location,
            DATE(v.date_started) as date_started,
            DATE(v.date_stopped) as date_stopped,
            DATE(v.date_created) as date_created
FROM        visit v
LEFT JOIN   visit_type vt ON vt.visit_type_id = v.visit_type_id
LEFT JOIN   location l ON l.location_id = v.location_id
WHERE       v.voided = 0
