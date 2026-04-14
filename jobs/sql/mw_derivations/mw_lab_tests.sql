DROP TABLE IF EXISTS mw_lab_tests;
CREATE TABLE mw_lab_tests (
  lab_test_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id           INT NOT NULL,
  encounter_id         INT,
  date_collected       DATE,
  test_type            VARCHAR(100),
  date_result_received DATE,
  date_result_entered  DATE,
  result_coded         VARCHAR(100),
  result_numeric       DECIMAL(10,2),
  result_exception     VARCHAR(100)
);
ALTER TABLE mw_lab_tests ADD INDEX mw_lab_tests_patient_idx (patient_id);
ALTER TABLE mw_lab_tests ADD INDEX mw_lab_tests_patient_type_idx (patient_id, test_type);

-- HIV test results (grouped by obs_group from omrs_obs_group with concept 'Child HIV serology construct')
INSERT INTO mw_lab_tests (patient_id, encounter_id, date_collected, test_type, date_result_received, date_result_entered, result_coded)
SELECT
    g.patient_id,
    g.encounter_id,
    MAX(CASE WHEN o.concept = 'Date of blood sample' THEN o.value_date END) as date_collected,
    MAX(CASE WHEN o.concept = 'HIV test type' THEN o.value_coded END) as test_type,
    MAX(CASE WHEN o.concept = 'Date of returned result' THEN o.value_date END) as date_result_received,
    MAX(CASE WHEN o.concept = 'Result of HIV test' THEN DATE(o.date_created) END) as date_result_entered,
    MAX(CASE WHEN o.concept = 'Result of HIV test' THEN o.value_coded END) as result_coded
FROM omrs_obs_group g
INNER JOIN omrs_obs o ON o.obs_group_id = g.obs_group_id
WHERE g.concept = 'Child HIV serology construct'
GROUP BY g.patient_id, g.encounter_id, g.obs_group_id;

-- Viral load results
INSERT INTO mw_lab_tests (patient_id, encounter_id, date_collected, test_type, date_result_received, date_result_entered, result_numeric, result_exception)
SELECT
    o.patient_id,
    o.encounter_id,
    MAX(CASE WHEN o.concept = 'Sample taken for Viral Load' AND o.value_coded = 'True' THEN o.obs_date END) as date_collected,
    'Viral Load' as test_type,
    NULL as date_result_received,
    MAX(CASE WHEN o.concept = 'HIV viral load' THEN DATE(o.date_created) END) as date_result_entered,
    MAX(CASE WHEN o.concept = 'HIV viral load' THEN o.value_numeric END) as result_numeric,
    MAX(CASE WHEN o.concept = 'Lower than Detection Limit' AND o.value_coded = 'True' THEN o.concept
             WHEN o.concept = 'Less than limit' THEN CONCAT('<', o.value_numeric) END) as result_exception
FROM omrs_obs o
WHERE o.concept IN ('Sample taken for Viral Load', 'HIV viral load', 'Lower than Detection Limit', 'Less than limit')
GROUP BY o.patient_id, o.encounter_id
HAVING MAX(CASE WHEN o.concept IN ('HIV viral load', 'Lower than Detection Limit', 'Less than limit') THEN 1 END) = 1;
