-- Derivation script for mw_nutrition_teen_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-teen-initial.ktr

DROP TABLE IF EXISTS mw_nutrition_teen_initial;
CREATE TABLE mw_nutrition_teen_initial (
    nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    enrollment_reason_hiv VARCHAR(255),
    enrollment_reason_tb VARCHAR(255),
    enrollment_reason_ncd VARCHAR(255),
    enrolling_nurse_or_clinician VARCHAR(255),
    PRIMARY KEY (nutrition_initial_visit_id)
);

INSERT INTO mw_nutrition_teen_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as enrolling_nurse_or_clinician,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'HIV program' THEN o.value_coded END) as enrollment_reason_hiv,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Enrolled in NCD' THEN o.value_coded END) as enrollment_reason_ncd,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Tuberculosis program' THEN o.value_coded END) as enrollment_reason_tb
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_PREGNANT_TEENS_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;