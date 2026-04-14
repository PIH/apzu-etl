-- Derivation script for mw_eid_register
-- Generated from Pentaho transform: import-into-mw-eid-register.ktr

DROP TABLE IF EXISTS mw_eid_register;
CREATE TABLE mw_eid_register (
  enrollment_id                    INT NOT NULL,
  patient_id                       INT NOT NULL,
  location                         VARCHAR(255),
  eid_number                       VARCHAR(50),
  mother_art_number				   VARCHAR(100),
  start_date                       DATE,
  end_date                         DATE,
  outcome                          VARCHAR(100),
  last_eid_visit_id                INT
);
alter table mw_eid_register add index mw_eid_register_patient_idx (patient_id);
alter table mw_eid_register add index mw_eid_register_patient_location_idx (patient_id, location);

INSERT INTO mw_eid_register
SELECT
    p.program_enrollment_id AS enrollment_id,
    s.patient_id,
    s.location,
    i.identifier AS eid_number,
    mo.mother_art_number,
    s.start_date,
    IFNULL(s.end_date, p.completion_date) AS end_date,
    IFNULL(nextStateForEnrollment(p.program_enrollment_id, s.end_date), p.outcome) AS outcome,
    lv.last_eid_visit_id
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
    AND i.type = 'HCC Number'
) i ON i.patient_id = s.patient_id AND i.location = s.location
LEFT JOIN (
    SELECT o.patient_id, GROUP_CONCAT(o.value_text) AS mother_art_number
    FROM omrs_obs o
    WHERE o.concept = 'Mother ART registration number'
    GROUP BY o.patient_id
) mo ON mo.patient_id = s.patient_id
LEFT JOIN (
    SELECT v.patient_id, v.eid_visit_id AS last_eid_visit_id
    FROM mw_eid_visits v
    WHERE v.eid_visit_id = (
        SELECT v1.eid_visit_id
        FROM mw_eid_visits v1
        WHERE v1.patient_id = v.patient_id
        ORDER BY v1.visit_date DESC
        LIMIT 1
    )
) lv ON lv.patient_id = s.patient_id
WHERE s.program = 'HIV program'
AND s.workflow = 'Treatment status'
AND s.state = 'Exposed Child (Continue)';
