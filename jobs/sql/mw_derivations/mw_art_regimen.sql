DROP TABLE IF EXISTS mw_art_regimen;
CREATE TABLE mw_art_regimen (
  patient_id           INT NOT NULL,
  regimen              VARCHAR(255),
  regimen_init_date    DATE,
  num_of_prev_regimens INT,
  regimen_end_date     DATE,
  line                 VARCHAR(100)
);

-- First ART regimen (Malawi Antiretroviral drugs change 1)
INSERT INTO mw_art_regimen (patient_id, regimen, regimen_init_date, num_of_prev_regimens)
SELECT
    o.patient_id,
    o.value_coded,
    initdate.value_date AS regimen_init_date,
    NULL AS num_of_prev_regimens
FROM omrs_obs o
LEFT JOIN (
    SELECT encounter_id, value_date
    FROM omrs_obs
    WHERE concept = 'Start date 1st line ARV'
) initdate ON initdate.encounter_id = o.encounter_id
WHERE o.concept = 'Malawi Antiretroviral drugs change 1';

-- Second ART regimen (Malawi Antiretroviral drugs change 2)
INSERT INTO mw_art_regimen (patient_id, regimen, regimen_init_date, num_of_prev_regimens)
SELECT
    o.patient_id,
    o.value_coded,
    initdate.value_date AS regimen_init_date,
    NULL AS num_of_prev_regimens
FROM omrs_obs o
LEFT JOIN (
    SELECT encounter_id, value_date
    FROM omrs_obs
    WHERE concept = 'Date of starting alternative 1st line ARV regimen'
) initdate ON initdate.encounter_id = o.encounter_id
WHERE o.concept = 'Malawi Antiretroviral drugs change 2';

-- Third ART regimen (Malawi Antiretroviral drugs change 3)
INSERT INTO mw_art_regimen (patient_id, regimen, regimen_init_date, num_of_prev_regimens)
SELECT
    o.patient_id,
    o.value_coded,
    initdate.value_date AS regimen_init_date,
    NULL AS num_of_prev_regimens
FROM omrs_obs o
LEFT JOIN (
    SELECT encounter_id, value_date
    FROM omrs_obs
    WHERE concept = 'Date of starting 2nd line ARV regimen'
) initdate ON initdate.encounter_id = o.encounter_id
WHERE o.concept = 'Malawi Antiretroviral drugs change 3';
