-- Derivation script for mw_art_followup_testing
-- Generated from Pentaho transform: import-into-mw-art-followup-testing.ktr

DROP TABLE IF EXISTS mw_art_followup_testing;
CREATE TABLE mw_art_followup_testing (
  art_followup_testing_visit_id INT NOT NULL AUTO_INCREMENT,
  patient_id INT(11) NOT NULL,
  visit_date DATE NULL DEFAULT NULL,
  location VARCHAR(255) NULL DEFAULT NULL,
  cd4_count INT NULL DEFAULT NULL,
  cd4_pct INT NULL DEFAULT NULL,
  serum_glucose INT NULL DEFAULT NULL,
  phq_nine_score INT NULL,
  test_type VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (art_followup_testing_visit_id));

INSERT INTO mw_art_followup_testing
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'CD4 count' THEN o.value_numeric END) as cd4_count,
    MAX(CASE WHEN o.concept = 'Cd4%' THEN o.value_numeric END) as cd4_pct,
    MAX(CASE WHEN o.concept = 'PHQ 9 Score' THEN o.value_numeric END) as phq_nine_score,
    MAX(CASE WHEN o.concept = 'Serum glucose' THEN o.value_numeric END) as serum_glucose,
    MAX(CASE WHEN o.concept = 'Blood sugar test type' THEN o.value_coded END) as test_type
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
GROUP BY e.patient_id, e.encounter_date, e.location;