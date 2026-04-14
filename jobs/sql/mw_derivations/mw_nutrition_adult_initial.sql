-- Derivation script for mw_nutrition_adult_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-adult-initial.ktr

DROP TABLE IF EXISTS mw_nutrition_adult_initial;
DROP TABLE IF EXISTS mw_nutrition_adult_initial;
CREATE TABLE mw_nutrition_adult_initial (
    nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    enrollment_reason_tb VARCHAR(255),
    enrollment_reason_hiv VARCHAR(255),
    enrollment_reason_ncd VARCHAR(255),
    PRIMARY KEY (nutrition_initial_visit_id));

INSERT INTO mw_nutrition_adult_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Patient in tuberculosis treatment' THEN o.value_coded END) as enrollment_reason_tb,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Patient in HIV treatment' THEN o.value_coded END) as enrollment_reason_hiv,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Enrolled in NCD' THEN o.value_coded END) as enrollment_reason_ncd
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_ADULTS_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;