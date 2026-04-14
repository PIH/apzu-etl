-- Derivation script for mw_art_register
-- Generated from Pentaho transform: import-into-mw-art-register.ktr

DROP TABLE IF EXISTS mw_art_register;
CREATE TABLE mw_art_register (
  enrollment_id             INT NOT NULL,
  patient_id                INT NOT NULL,
  location                  VARCHAR(255),
  art_number                VARCHAR(50),
  start_date                DATE,
  end_date                  DATE,
  outcome                   VARCHAR(100),
  last_art_visit_id         INT,
  last_viral_load_test_id   INT,
  last_viral_load_result_id INT
);
alter table mw_art_register add index mw_art_register_patient_idx (patient_id);
alter table mw_art_register add index mw_art_register_patient_location_idx (patient_id, location);

INSERT INTO mw_art_register
SELECT
    p.program_enrollment_id AS enrollment_id,
    s.patient_id,
    s.location,
    i.identifier AS art_number,
    s.start_date,
    IFNULL(s.end_date, p.completion_date) AS end_date,
    IFNULL(nextStateForEnrollment(p.program_enrollment_id, s.end_date), p.outcome) AS outcome,
    lv.last_art_visit_id,
    lt.last_viral_load_test_id,
    lr.last_viral_load_result_id
FROM omrs_program_state s
INNER JOIN omrs_program_enrollment p ON p.program_enrollment_id = s.program_enrollment_id
LEFT JOIN (
    SELECT i.patient_id, i.location, i.identifier
    FROM omrs_patient_identifier i
    WHERE i.patient_identifier_id = (
        SELECT i1.patient_identifier_id
        FROM omrs_patient_identifier i1
        WHERE i1.patient_id = i.patient_id
        AND i1.location = i.location
        AND i1.type = 'ARV Number'
        ORDER BY i1.date_created DESC
        LIMIT 1
    )
) i ON i.patient_id = s.patient_id AND i.location = s.location
LEFT JOIN (
    SELECT v.patient_id, v.art_visit_id AS last_art_visit_id
    FROM mw_art_visits v
    WHERE v.art_visit_id = (
        SELECT v1.art_visit_id
        FROM mw_art_visits v1
        WHERE v1.patient_id = v.patient_id
        ORDER BY v1.visit_date DESC
        LIMIT 1
    )
) lv ON lv.patient_id = s.patient_id
LEFT JOIN (
    SELECT t.patient_id, t.lab_test_id AS last_viral_load_test_id
    FROM mw_lab_tests t
    WHERE t.lab_test_id = (
        SELECT t1.lab_test_id
        FROM mw_lab_tests t1
        WHERE t1.patient_id = t.patient_id
        AND t1.test_type = 'Viral Load'
        ORDER BY COALESCE(t1.date_collected, t1.date_result_received, t1.date_result_entered) DESC
        LIMIT 1
    )
) lt ON lt.patient_id = s.patient_id
LEFT JOIN (
    SELECT t.patient_id, t.lab_test_id AS last_viral_load_result_id
    FROM mw_lab_tests t
    WHERE t.lab_test_id = (
        SELECT t1.lab_test_id
        FROM mw_lab_tests t1
        WHERE t1.patient_id = t.patient_id
        AND t1.test_type = 'Viral Load'
        AND (t1.result_numeric IS NOT NULL OR t1.result_exception IS NOT NULL)
        ORDER BY COALESCE(t1.date_collected, t1.date_result_received, t1.date_result_entered) DESC
        LIMIT 1
    )
) lr ON lr.patient_id = s.patient_id
WHERE s.program = 'HIV program'
AND s.workflow = 'Treatment status'
AND s.state = 'On antiretrovirals';
