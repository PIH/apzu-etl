SELECT      pp.patient_program_id as program_enrollment_id,
            pp.uuid,
            p.person_id as patient_id,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = pg.concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as program,
            pp.date_enrolled as enrollment_date,
            IF(p.birthdate IS NULL OR pp.date_enrolled IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, pp.date_enrolled)) as age_years_at_enrollment,
            IF(p.birthdate IS NULL OR pp.date_enrolled IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, pp.date_enrolled)) as age_months_at_enrollment,
            l.name as location,
            pp.date_completed as completion_date,
            IF(p.birthdate IS NULL OR pp.date_completed IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, pp.date_completed)) as age_years_at_completion,
            IF(p.birthdate IS NULL OR pp.date_completed IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, pp.date_completed)) as age_months_at_completion,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = pp.outcome_concept_id AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as outcome
FROM        person p
INNER JOIN  patient_program pp ON p.person_id = pp.patient_id
INNER JOIN  program pg ON pp.program_id = pg.program_id
LEFT JOIN   location l ON l.location_id = pp.location_id
WHERE       pp.voided = 0
AND         p.voided = 0
AND         pp.date_enrolled IS NOT NULL
