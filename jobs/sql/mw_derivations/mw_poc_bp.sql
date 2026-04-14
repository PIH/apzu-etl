-- Derivation script for mw_poc_bp
-- Generated from Pentaho transform: import-into-mw-poc-bp.ktr

DROP TABLE IF EXISTS mw_poc_bp;
CREATE TABLE mw_poc_bp (
    poc_bp_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    diastolic_blood_pressure DECIMAL(10,2),
    pulse DECIMAL(10,2),
    systolic_blood_pressure DECIMAL(10,2),
    PRIMARY KEY (poc_bp_visit_id)
);

INSERT INTO mw_poc_bp
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Diastolic blood pressure' THEN o.value_numeric END) as diastolic_blood_pressure,
    MAX(CASE WHEN o.concept = 'Pulse' THEN o.value_numeric END) as pulse,
    MAX(CASE WHEN o.concept = 'Systolic blood pressure' THEN o.value_numeric END) as systolic_blood_pressure
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Blood pressure screening')
GROUP BY e.patient_id, e.encounter_date, e.location;