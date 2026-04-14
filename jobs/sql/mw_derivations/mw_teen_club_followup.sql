-- Derivation script for mw_teen_club_followup
-- Generated from Pentaho transform: import-into-mw-teen-club-followup.ktr

DROP TABLE IF EXISTS mw_teen_club_followup;
CREATE TABLE mw_teen_club_followup (
    teen_club_followup_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    height DECIMAL(10 , 2 ),
    weight DECIMAL(10 , 2 ),
    muac_bmi DECIMAL(10 , 2 ),
    tb_status VARCHAR(255),
    tb_screening_outcome VARCHAR(255),
    sputum_collected VARCHAR(255),
    nutrition_screening_for_normal_muac VARCHAR(255),
    nutrition_referred VARCHAR(255),
    mental_health_screened VARCHAR(255),
    adolescent_referred VARCHAR(255),
    adolescent_registered VARCHAR(255),
    sti_screening_outcome VARCHAR(255),
    referred_to_sti_clinic VARCHAR(255),
    hospitalized VARCHAR(255),
    next_appointment DATE,
    PRIMARY KEY (teen_club_followup_visit_id)
);

INSERT INTO mw_teen_club_followup
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Appointment date' THEN o.value_date END) as next_appointment,
    MAX(CASE WHEN o.concept = 'Height (cm)' THEN o.value_numeric END) as height,
    MAX(CASE WHEN o.concept = 'Sample collected' THEN o.value_coded END) as hospitalized,
    MAX(CASE WHEN o.concept = 'Body mass index, measured' THEN o.value_numeric END) as muac_bmi,
    MAX(CASE WHEN o.concept = 'Normal nutrition screening for MUAC' THEN o.value_coded END) as nutrition_screening_for_normal_muac,
    MAX(CASE WHEN o.concept = 'Nutrition referral' THEN o.value_coded END) as nutrition_referred,
    MAX(CASE WHEN o.concept = 'STI referral' THEN o.value_coded END) as referred_to_sti_clinic,
    MAX(CASE WHEN o.concept = 'STI screening outcome' THEN o.value_coded END) as sti_screening_outcome,
    MAX(CASE WHEN o.concept = 'Sample collected' THEN o.value_coded END) as sputum_collected,
    MAX(CASE WHEN o.concept = 'TB screening outcome' THEN o.value_coded END) as tb_screening_outcome,
    MAX(CASE WHEN o.concept = 'TB status' THEN o.value_coded END) as tb_status,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as weight,
    MAX(CASE WHEN o.concept = 'If yes,Adolescent referred?' THEN o.value_coded END) as adolescent_referred,
    MAX(CASE WHEN o.concept = 'If yes,Adolescent registered?' THEN o.value_coded END) as adolescent_registered,
    MAX(CASE WHEN o.concept = 'Mental health screened' THEN o.value_coded END) as mental_health_screened
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('TEEN_CLUB_FOLLOWUP')
GROUP BY e.patient_id, e.encounter_date, e.location;