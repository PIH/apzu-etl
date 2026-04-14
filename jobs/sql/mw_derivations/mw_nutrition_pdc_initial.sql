-- Derivation script for mw_nutrition_pdc_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-pdc-initial.ktr

DROP TABLE IF EXISTS mw_nutrition_pdc_initial;
CREATE TABLE mw_nutrition_pdc_initial (
    nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    enrollment_reason_martenal_death VARCHAR(255),
    enrollment_reason_malnutrition VARCHAR(255),
    enrollment_reason_poser_support VARCHAR(255),
    enrollment_reason_other VARCHAR(255),
    PRIMARY KEY (nutrition_initial_visit_id)
);

INSERT INTO mw_nutrition_pdc_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Maternal Death' THEN o.value_coded END) as enrollment_reason_martenal_death,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Malnutrition' THEN o.value_coded END) as enrollment_reason_malnutrition,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Other non-coded (text)' THEN o.value_coded END) as enrollment_reason_other,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Poser Support' THEN o.value_coded END) as enrollment_reason_poser_support
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_PDC_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;