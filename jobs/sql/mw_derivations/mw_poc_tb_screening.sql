-- Derivation script for mw_poc_tb_screening
-- Generated from Pentaho transform: import-into-mw-poc-tb-screening.ktr

DROP TABLE IF EXISTS mw_poc_tb_screening;
CREATE TABLE mw_poc_tb_screening (
    poc_tb_screening_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    creator VARCHAR(255),
    symptom_present VARCHAR(255),
    symptom_absent VARCHAR(255),
    PRIMARY KEY (poc_tb_screening_visit_id)
);

INSERT INTO mw_poc_tb_screening
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Symptom absent' THEN o.value_coded END) as symptom_absent,
    MAX(CASE WHEN o.concept = 'Symptom present' THEN o.value_coded END) as symptom_present
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('TB Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;