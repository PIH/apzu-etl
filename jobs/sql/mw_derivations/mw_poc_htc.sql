-- Derivation script for mw_poc_htc
-- Generated from Pentaho transform: import-into-mw-poc-htc.ktr

DROP TABLE IF EXISTS mw_poc_htc;
CREATE TABLE mw_poc_htc (
    poc_htc_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    result_of_hiv_test_htc VARCHAR(255),
    hiv_test_type_htc VARCHAR(255),    
    PRIMARY KEY (poc_htc_visit_id)
);

INSERT INTO mw_poc_htc
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'HIV test type' THEN o.value_coded END) as hiv_test_type_htc,
    MAX(CASE WHEN o.concept = 'Result of HIV test' THEN o.value_coded END) as result_of_hiv_test_htc
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('HTC screening')
GROUP BY e.patient_id, e.encounter_date, e.location;