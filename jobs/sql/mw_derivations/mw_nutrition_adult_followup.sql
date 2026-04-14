-- Derivation script for mw_nutrition_adult_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-adult-followup.ktr

DROP TABLE IF EXISTS mw_nutrition_adult_followup;
CREATE TABLE mw_nutrition_adult_followup (
    nutrition_adult_followup_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    weight DECIMAL(10 , 2 ),
    height DECIMAL(10 , 2 ),
    bmi DECIMAL(10 , 2 ),
    food_likuni_phala DECIMAL(10 , 2 ),
    next_appointment DATE,
    warehouse_signature VARCHAR(255),
    comments VARCHAR(255),
    PRIMARY KEY (nutrition_adult_followup_visit_id)
);

INSERT INTO mw_nutrition_adult_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Given name' THEN o.value_text END) as warehouse_signature,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment,
    MAX(CASE WHEN o.concept = 'Body mass index, measured' THEN o.value_numeric END) as bmi,
    MAX(CASE WHEN o.concept = 'Clinical impression comments' THEN o.value_text END) as comments,
    MAX(CASE WHEN o.concept = 'Likuni Phala given to patient(Kg)' THEN o.value_numeric END) as food_likuni_phala,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_ADULTS_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;