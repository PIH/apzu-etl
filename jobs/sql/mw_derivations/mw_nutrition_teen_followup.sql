-- Derivation script for mw_nutrition_teen_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-teen-followup.ktr

DROP TABLE IF EXISTS mw_nutrition_teen_followup;
CREATE TABLE mw_nutrition_teen_followup (
    nutrition_followup_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    weight DECIMAL(10 , 2 ),
    height DECIMAL(10 , 2 ),
    muac DECIMAL(10 , 2 ),
    oil DECIMAL(10 , 2 ),
    maize DECIMAL(10 , 2 ),
    beans DECIMAL(10 , 2 ),
    next_appointment DATE,
    warehouse_signature VARCHAR(255),
    comments VARCHAR(255),
    PRIMARY KEY (nutrition_followup_visit_id)
);

INSERT INTO mw_nutrition_teen_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Given name' THEN o.value_text END) as warehouse_signature,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment,
    MAX(CASE WHEN o.concept = 'Received beans (kg)' THEN o.value_numeric END) as beans,
    MAX(CASE WHEN o.concept = 'Clinical impression comments' THEN o.value_text END) as comments,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Middle upper arm circumference (cm)' THEN o.value_numeric END) as muac,
    MAX(CASE WHEN o.concept = 'Received maize (kg)' THEN o.value_numeric END) as maize,
    MAX(CASE WHEN o.concept = 'Oil given to patient(Liters)' THEN o.value_numeric END) as oil,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_PREGNANT_TEENS_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;