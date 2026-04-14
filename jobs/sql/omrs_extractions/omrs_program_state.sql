SELECT      ps.patient_state_id as program_state_id,
            ps.uuid,
            pp.patient_program_id as program_enrollment_id,
            p.person_id as patient_id,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = pg.concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as program,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = pw.concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as workflow,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = pws.concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as state,
            ps.start_date,
            IF(p.birthdate IS NULL OR ps.start_date IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, ps.start_date)) as age_years_at_start,
            IF(p.birthdate IS NULL OR ps.start_date IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, ps.start_date)) as age_months_at_start,
            ps.end_date,
            IF(p.birthdate IS NULL OR ps.start_date IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, ps.end_date)) as age_years_at_end,
            IF(p.birthdate IS NULL OR ps.start_date IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, ps.end_date)) as age_months_at_end,
            l.name as location
FROM        person p
INNER JOIN  patient_program pp ON p.person_id = pp.patient_id
INNER JOIN  patient_state ps ON ps.patient_program_id = pp.patient_program_id
INNER JOIN  program_workflow_state pws ON ps.state = pws.program_workflow_state_id
INNER JOIN  program_workflow pw ON pws.program_workflow_id = pw.program_workflow_id
INNER JOIN  program pg ON pp.program_id = pg.program_id
LEFT JOIN   location l ON l.location_id = pp.location_id
WHERE       pp.voided = 0
AND         p.voided = 0
AND         ps.voided = 0
AND         pp.date_enrolled IS NOT NULL
AND         ps.start_date IS NOT NULL
