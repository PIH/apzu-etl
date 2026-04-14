-- Derivation script for mw_poc_clinical_plan
-- Generated from Pentaho transform: import-into-mw-poc-clinical-plan.ktr

DROP TABLE IF EXISTS mw_poc_clinical_plan;
CREATE TABLE mw_poc_clinical_plan (
    poc_clinical_plan_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    appointment_date DATE,
    qualitative_time VARCHAR(255),
    outcome VARCHAR(255),
    clinical_impression_comments VARCHAR(500),
    refer_to_screening_station VARCHAR(255),
    transfer_out_to VARCHAR(255),
    reason_to_stop_care VARCHAR(255),
    PRIMARY KEY (poc_clinical_plan_visit_id)
);

INSERT INTO mw_poc_clinical_plan
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as appointment_date,
    MAX(CASE WHEN o.concept = 'Clinical impression comments' THEN o.value_text END) as clinical_impression_comments,
    MAX(CASE WHEN o.concept = 'Outcome' THEN o.value_coded END) as outcome,
    MAX(CASE WHEN o.concept = 'Qualitative time' THEN o.value_coded END) as qualitative_time,
    MAX(CASE WHEN o.concept = 'Reason to stop care (text)' THEN o.value_text END) as reason_to_stop_care,
    MAX(CASE WHEN o.concept = 'Refer to screening station' THEN o.value_coded END) as refer_to_screening_station,
    MAX(CASE WHEN o.concept = 'Transfer out to' THEN o.value_text END) as transfer_out_to
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Clinical Plan')
GROUP BY e.patient_id, e.encounter_date, e.location;