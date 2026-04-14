-- Derivation script for mw_poc_nutrition
-- Generated from Pentaho transform: import-into-mw-poc-nutrition.ktr

DROP TABLE IF EXISTS mw_poc_nutrition;
CREATE TABLE mw_poc_nutrition (
    poc_nutrition_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    height DECIMAL(10,2),
    weight DECIMAL(10,2),
    is_patient_preg VARCHAR(255),
    muac VARCHAR(255),
    PRIMARY KEY (poc_nutrition_visit_id)
);

INSERT INTO mw_poc_nutrition
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Middle upper arm circumference (cm)' THEN o.value_numeric END) as muac,
    MAX(CASE WHEN o.concept = 'Is patient pregnant?' THEN o.value_coded END) as is_patient_preg,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Nutrition Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;