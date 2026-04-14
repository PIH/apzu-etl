-- Derivation script for mw_nutrition_infant_followup
-- Generated from Pentaho transform: import-into-mw-nutrition-infant-followup.ktr

DROP TABLE IF EXISTS mw_nutrition_infant_followup;
CREATE TABLE mw_nutrition_infant_followup (
nutrition_infant_followup_id INT NOT NULL AUTO_INCREMENT,
patient_id INT NOT NULL,
visit_date DATE,
location VARCHAR(255),
weight DECIMAL(10,2),
height DECIMAL(10,2),
muac DECIMAL(10,2),
lactogen_tins VARCHAR(255),
next_appointment_date DATE,
ration VARCHAR(255),
comments VARCHAR(255),
PRIMARY KEY (nutrition_infant_followup_id)
);

INSERT INTO mw_nutrition_infant_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Given name' THEN o.value_text END) as ration,
    MAX(CASE WHEN o.concept = 'Clinical impression comments' THEN o.value_text END) as comments,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Number of lactogen tins' THEN o.value_numeric END) as lactogen_tins,
    MAX(CASE WHEN o.concept = 'muac' THEN o.value_numeric END) as muac,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment_date,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('NUTRITION_INFANT_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;