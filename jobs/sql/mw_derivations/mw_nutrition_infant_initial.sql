-- Derivation script for mw_nutrition_infant_initial
-- Generated from Pentaho transform: import-into-mw-nutrition-infant-initial.ktr

DROP TABLE IF EXISTS mw_nutrition_infant_initial;
CREATE TABLE mw_nutrition_infant_initial (
nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
patient_id INT NOT NULL,
visit_date DATE,
location VARCHAR(255),
enrollment_reason_severe_maternal_illness VARCHAR(255),
enrollment_reason_multiple_births VARCHAR(255),
enrollment_reason_maternal_death VARCHAR(255),
enrollment_reason_other VARCHAR(255),
PRIMARY KEY (nutrition_initial_visit_id)
);

INSERT INTO mw_nutrition_infant_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Multiple births' THEN o.value_coded END) as enrollment_reason_multiple_births,
    MAX(CASE WHEN o.concept = 'Other non-coded (text)' THEN o.value_text END) as enrollment_reason_other,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Severe Maternal Illness' THEN o.value_coded END) as enrollment_reason_severe_maternal_illness,
    MAX(CASE WHEN o.concept = 'Reason enrolled in food program' AND o.value_coded = 'Maternal Death' THEN o.value_coded END) as enrollment_reason_severe_maternal_Death
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_INFANT_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;