-- Derivation script for mw_poc_cervical_cancer
-- Generated from Pentaho transform: import-into-mw-poc-cervical-cancer.ktr

DROP TABLE IF EXISTS mw_poc_cervical_cancer;
CREATE TABLE mw_poc_cervical_cancer (
    poc_cervical_cancer_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    colposcopy_of_cervix_with_acetic_acid VARCHAR(255),
    PRIMARY KEY (poc_cervical_cancer_visit_id)
);

INSERT INTO mw_poc_cervical_cancer
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Colposcopy of cervix with acetic acid' THEN o.value_coded END) as colposcopy_of_cervix_with_acetic_acid
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('Cervical Cancer Screening')
GROUP BY e.patient_id, e.encounter_date, e.location;