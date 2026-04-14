-- Derivation script for mw_pdc_register
-- Generated from Pentaho transform: import-into-mw-pdc-register.ktr

DROP TABLE IF EXISTS mw_pdc_register;
create table mw_pdc_register (
  enrollment_id INT NOT NULL,
  patient_id    INT NOT NULL,
  location      VARCHAR(255),
  pdc_number    VARCHAR(50),
  start_date    DATE,
  end_date      DATE,
  outcome       VARCHAR(100)
);
alter table mw_pdc_register add index mw_pdc_register_patient_idx (patient_id);
alter table mw_pdc_register add index mw_pdc_register_patient_location_idx (patient_id, location);

INSERT INTO mw_pdc_register
SELECT
    p.program_enrollment_id AS enrollment_id,
    p.patient_id,
    p.location,
    i.identifier AS pdc_number,
    p.enrollment_date AS start_date,
    p.completion_date AS end_date,
    IF(p.completion_date IS NULL, NULL, IFNULL(latest_state.state, p.outcome)) AS outcome
FROM omrs_program_enrollment p
LEFT JOIN (
    SELECT i.patient_id, i.location, i.identifier
    FROM omrs_patient_identifier i
    WHERE i.patient_identifier_id = (
        SELECT i1.patient_identifier_id
        FROM omrs_patient_identifier i1
        WHERE i1.patient_id = i.patient_id
        AND i1.location = i.location
        AND i1.type = 'PDC Identifier'
        ORDER BY i1.date_created DESC
        LIMIT 1
    )
) i ON i.patient_id = p.patient_id AND i.location = p.location
LEFT JOIN (
    SELECT s.program_enrollment_id, s.state
    FROM omrs_program_state s
    WHERE s.program_state_id = (
        SELECT s1.program_state_id
        FROM omrs_program_state s1
        WHERE s1.program_enrollment_id = s.program_enrollment_id
        AND s1.program = 'Pediatric Development Clinic Program'
        AND s1.workflow = 'Chronic care treatment status'
        ORDER BY s1.start_date DESC
        LIMIT 1
    )
) latest_state ON latest_state.program_enrollment_id = p.program_enrollment_id
WHERE p.program = 'Pediatric Development Clinic Program';
