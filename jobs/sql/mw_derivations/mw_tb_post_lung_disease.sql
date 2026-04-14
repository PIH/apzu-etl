-- Derivation script for mw_tb_post_lung_disease
-- Generated from Pentaho transform: import-into-mw-tb-post-lung-disease.ktr

DROP TABLE IF EXISTS mw_tb_post_lung_disease;
CREATE TABLE mw_tb_post_lung_disease (
  tb_post_lung_disease_visit_id 		INT NOT NULL AUTO_INCREMENT,
  patient_id    				INT NOT NULL,
  visit_date            		DATE,
  location              		VARCHAR(255),
  number_of_weeks 					INT,
  second_visit_date 		DATE,
     PRIMARY KEY (tb_post_lung_disease_visit_id)
);

INSERT INTO mw_tb_post_lung_disease
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date registered in Post TB Lung Disease (PTLD)' THEN o.value_date END) as second_visit_date,
    MAX(CASE WHEN o.concept = 'Number of weeks on treatment' THEN o.value_numeric END) as number_of_weeks
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('TB_POST_LUNG_DISEASE')
GROUP BY e.patient_id, e.encounter_date, e.location;