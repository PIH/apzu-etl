-- Derivation script for mw_poc_viral_load_screening
-- Generated from Pentaho transform: import-into-mw-poc-viral-load-screening.ktr

DROP TABLE IF EXISTS mw_poc_viral_load_screening;
CREATE TABLE mw_poc_viral_load_screening (
    poc_viral_load_screening_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    creator VARCHAR(255),
    sample_taken_for_viral_load VARCHAR(255),
    lower_than_detection_limit VARCHAR(255),
    reason_for_testing VARCHAR(255),
    lab_location VARCHAR(255),
    less_than_limit VARCHAR(255),
    reason_for_no_result VARCHAR(255),
    viral_load_sample_id VARCHAR(255),
    reason_for_no_sample VARCHAR(255),
    lab_id VARCHAR(255),
    symptom_present VARCHAR(255),
    symptom_absent VARCHAR(255),
    PRIMARY KEY (poc_viral_load_screening_visit_id)
);

INSERT INTO mw_poc_viral_load_screening
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Sample taken for Viral Load' THEN o.value_coded END) as sample_taken_for_viral_Load,
    MAX(CASE WHEN o.concept = 'Lab ID' THEN o.value_text END) as lab_id,
    MAX(CASE WHEN o.concept = 'Location of laboratory' THEN o.value_coded END) as lab_location,
    MAX(CASE WHEN o.concept = 'Less than limit' THEN o.value_numeric END) as less_than_limit,
    MAX(CASE WHEN o.concept = 'Lower than Detection limit' THEN o.value_coded END) as lower_than_detection_limit,
    MAX(CASE WHEN o.concept = 'Reason for no result' THEN o.value_coded END) as reason_for_no_result,
    MAX(CASE WHEN o.concept = 'Reason for no sample' THEN o.value_coded END) as reason_for_no_sample,
    MAX(CASE WHEN o.concept = 'Reason for testing (coded)' THEN o.value_coded END) as reason_for_testing,
    MAX(CASE WHEN o.concept = 'Viral Load Sample ID' THEN o.value_text END) as viral_load_sample_id,
    MAX(CASE WHEN o.concept = 'Symptom absent' THEN o.value_coded END) as symptom_absent,
    MAX(CASE WHEN o.concept = 'Symptom present' THEN o.value_coded END) as symptom_present
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Viral Load Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;