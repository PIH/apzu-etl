-- Derivation script for mw_pre_art_register
-- Generated from Pentaho transform: import-into-mw-pre-art-register.ktr

DROP TABLE IF EXISTS mw_pre_art_register;
CREATE TABLE mw_pre_art_register (
  enrollment_id  INT NOT NULL,
  patient_id     INT NOT NULL,
  location       VARCHAR(255),
  pre_art_number VARCHAR(50),
  start_date     DATE,
  end_date       DATE,
  outcome        VARCHAR(100)
);
alter table mw_pre_art_register add index mw_pre_art_register_patient_idx (patient_id);
alter table mw_pre_art_register add index mw_pre_art_register_patient_location_idx (patient_id, location);

INSERT INTO mw_pre_art_register
SELECT
    p.program_enrollment_id AS enrollment_id,
    s.patient_id,
    s.location,
    i.identifier AS pre_art_number,
    s.start_date,
    IFNULL(s.end_date, p.completion_date) AS end_date,
    IFNULL(nextStateForEnrollment(p.program_enrollment_id, s.end_date), p.outcome) AS outcome
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
        AND i1.type = 'HCC Number'
        ORDER BY i1.date_created DESC
        LIMIT 1
    )
) i ON i.patient_id = s.patient_id AND i.location = s.location
WHERE s.program = 'HIV program'
AND s.workflow = 'Treatment status'
AND s.state = 'Pre-ART (Continue)';
