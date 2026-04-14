-- Relationships where the patient is person_a
SELECT      r.relationship_id,
            r.uuid,
            p.person_id as patient_id,
            t.a_is_to_b as patient_role,
            t.b_is_to_a as related_person_role,
            CONCAT_WS(' ', rn.given_name, rn.middle_name, rn.family_name_prefix, rn.family_name, rn.family_name2, rn.family_name_suffix) as related_person,
            r.start_date,
            r.end_date,
            DATE(r.date_created) as date_created
FROM        relationship r
INNER JOIN  person p ON p.person_id = r.person_a
INNER JOIN  patient pa ON pa.patient_id = p.person_id
INNER JOIN  person rp ON rp.person_id = r.person_b
INNER JOIN  relationship_type t ON t.relationship_type_id = r.relationship
LEFT JOIN   person_name rn ON rn.person_id = rp.person_id
            AND rn.person_name_id = (
                SELECT  rn2.person_name_id
                FROM    person_name rn2
                WHERE   rn2.voided = 0
                AND     rn2.person_id = rp.person_id
                ORDER BY rn2.preferred DESC, rn2.date_created DESC LIMIT 1
            )
WHERE       t.a_is_to_b IS NOT NULL
AND         r.person_a IS NOT NULL
AND         r.person_b IS NOT NULL
AND         r.voided = 0
AND         p.voided = 0
AND         pa.voided = 0
AND         rp.voided = 0

UNION ALL

-- Relationships where the patient is person_b
SELECT      r.relationship_id,
            r.uuid,
            p.person_id as patient_id,
            t.b_is_to_a as patient_role,
            t.a_is_to_b as related_person_role,
            CONCAT_WS(' ', rn.given_name, rn.middle_name, rn.family_name_prefix, rn.family_name, rn.family_name2, rn.family_name_suffix) as related_person,
            r.start_date,
            r.end_date,
            DATE(r.date_created) as date_created
FROM        relationship r
INNER JOIN  person p ON p.person_id = r.person_b
INNER JOIN  patient pa ON pa.patient_id = p.person_id
INNER JOIN  person rp ON rp.person_id = r.person_a
INNER JOIN  relationship_type t ON t.relationship_type_id = r.relationship
LEFT JOIN   person_name rn ON rn.person_id = rp.person_id
            AND rn.person_name_id = (
                SELECT  rn2.person_name_id
                FROM    person_name rn2
                WHERE   rn2.voided = 0
                AND     rn2.person_id = rp.person_id
                ORDER BY rn2.preferred DESC, rn2.date_created DESC LIMIT 1
            )
WHERE       t.b_is_to_a IS NOT NULL
AND         r.person_a IS NOT NULL
AND         r.person_b IS NOT NULL
AND         r.voided = 0
AND         p.voided = 0
AND         pa.voided = 0
AND         rp.voided = 0
