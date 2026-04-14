-- Derivation script for mw_poc_adherence_counseling
-- Generated from Pentaho transform: import-into-mw-poc-adherence-counseling.ktr

DROP TABLE IF EXISTS mw_poc_adherence_counseling;
CREATE TABLE mw_poc_adherence_counseling (
    poc_adherence_counseling_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    adherence_session_number VARCHAR(255),
    name_of_support_provider VARCHAR(255),
    number_of_missed_medication_doses_in_past_week VARCHAR(255),
    viral_load_counseling VARCHAR(255),
    medication_adherence_percent VARCHAR(255),
    adherence_counselling VARCHAR(255),
    PRIMARY KEY (poc_adherence_counseling_visit_id)
);

INSERT INTO mw_poc_adherence_counseling
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Adherence counseling (coded)' THEN o.value_coded END) as adherence_counselling,
    MAX(CASE WHEN o.concept = 'Adherence session number' THEN o.value_coded END) as adherence_session_number,
    MAX(CASE WHEN o.concept = 'Medication Adherence percent' THEN o.value_numeric END) as medication_adherence_percent,
    MAX(CASE WHEN o.concept = 'Name of support provider' THEN o.value_text END) as name_of_support_provider,
    MAX(CASE WHEN o.concept = 'Number of missed medication doses in past 7 days' THEN o.value_numeric END) as number_of_missed_medication_doses_in_past_week,
    MAX(CASE WHEN o.concept = 'Viral load counseling' THEN o.value_coded END) as viral_load_counseling
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Adherence Counseling')
GROUP BY e.patient_id, e.encounter_date, e.location;