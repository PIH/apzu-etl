-- Derivation script for mw_tb_test_results
-- Generated from Pentaho transform: import-into-mw-tb-test-results.ktr

DROP TABLE IF EXISTS mw_tb_test_results;
CREATE TABLE mw_tb_test_results (
  tb_test_results_id 					INT NOT NULL AUTO_INCREMENT,
  patient_id    						INT NOT NULL,
  visit_date            				DATE,
  location              				VARCHAR(255),
  initiation_month_smear_test	varchar(255),
  initiation_month_smear_test_date	date,
  initiation_month_smaer_lab_serial_number	varchar(255),
  initiation_month_smear_result	varchar(255),
  initiation_month_culture_test	varchar(255),
  initiation_month_culture_test_date	date,
  initiation_month_culture_lab_serial_number	varchar(255),
  initiation_month_culture_result	varchar(255),
  initiation_month_xpert_test	varchar(255),
  initiation_month_xpert_test_date	date,
  initiation_month_xpert_lab_serial_number	varchar(255),
  initiation_month_xpert_result	varchar(255),
  initiation_month_lam_test	varchar(255),
  initiation_month_lam_test_date	date,
  initiation_month_lam_lab_serial_number	varchar(255),
  initiation_month_lam_result	varchar(255),
  month_two_test	varchar(255),
  month_two_test_date	date,
  month_two_lab_serial_number	varchar(255),
  month_two_result	varchar(255),
  month_two_weight	int(11),
  month_three_test	varchar(255),
  month_three_test_date	date,
  month_three_lab_serial_number	varchar(255),
  month_three_result	varchar(255),
  month_three_weight	int(11),
  month_five_test	varchar(255),
  month_five_test_date	date,
  month_five_lab_serial_number	varchar(255),
  month_five_result	varchar(255),
  month_five_weight	int(11),
  month_six_test	varchar(255),
  month_six_test_date	date,
  month_six_lab_serial_number	varchar(255),
  month_six_result	varchar(255),
  month_six_weight	int(11),
   PRIMARY KEY (tb_test_results_id )
);

-- Each TB test is stored in a 'Tuberculosis test set' obs group with:
--   'TB Test time' obs identifying the period (Initiation, Month 2, Month 3, Month 5, Month 6)
--   'Tuberculosis test type' obs identifying the test type (smear, culture, xpert, lam)
-- The subquery pivots each obs_group into a single row, then the outer query
-- pivots across time + test type dimensions into columns.
INSERT INTO mw_tb_test_results
SELECT
    e.patient_id,
    DATE(e.encounter_date) AS visit_date,
    e.location,
    -- Initiation month tests
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis smear microscopy method' THEN tbs.test_type END) AS initiation_month_smear_test,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis smear microscopy method' THEN tbs.test_date END) AS initiation_month_smear_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis smear microscopy method' THEN tbs.serial_number END) AS initiation_month_smaer_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis smear microscopy method' THEN tbs.test_result END) AS initiation_month_smear_result,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis culture method' THEN tbs.test_type END) AS initiation_month_culture_test,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis culture method' THEN tbs.test_date END) AS initiation_month_culture_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis culture method' THEN tbs.serial_number END) AS initiation_month_culture_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis culture method' THEN tbs.test_result END) AS initiation_month_culture_result,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' THEN 'Xpert' END) AS initiation_month_xpert_test,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' THEN tbs.test_date END) AS initiation_month_xpert_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' THEN tbs.serial_number END) AS initiation_month_xpert_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' THEN tbs.test_result END) AS initiation_month_xpert_result,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Urine LAM / CrAg Result' THEN 'Lam' END) AS initiation_month_lam_test,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Urine LAM / CrAg Result' THEN tbs.test_date END) AS initiation_month_lam_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Urine LAM / CrAg Result' THEN tbs.serial_number END) AS initiation_month_lam_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Initiation' AND tbs.test_type = 'Urine LAM / CrAg Result' THEN tbs.test_result END) AS initiation_month_lam_result,
    -- Month 2
    MAX(CASE WHEN tbs.tb_time = 'Month 2' THEN tbs.test_type END) AS month_two_test,
    MAX(CASE WHEN tbs.tb_time = 'Month 2' THEN tbs.test_date END) AS month_two_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Month 2' THEN tbs.serial_number END) AS month_two_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Month 2' THEN tbs.test_result END) AS month_two_result,
    MAX(CASE WHEN tbs.tb_time = 'Month 2' THEN tbs.weight END) AS month_two_weight,
    -- Month 3
    MAX(CASE WHEN tbs.tb_time = 'Month 3' THEN tbs.test_type END) AS month_three_test,
    MAX(CASE WHEN tbs.tb_time = 'Month 3' THEN tbs.test_date END) AS month_three_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Month 3' THEN tbs.serial_number END) AS month_three_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Month 3' THEN tbs.test_result END) AS month_three_result,
    MAX(CASE WHEN tbs.tb_time = 'Month 3' THEN tbs.weight END) AS month_three_weight,
    -- Month 5
    MAX(CASE WHEN tbs.tb_time = 'Month 5' THEN tbs.test_type END) AS month_five_test,
    MAX(CASE WHEN tbs.tb_time = 'Month 5' THEN tbs.test_date END) AS month_five_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Month 5' THEN tbs.serial_number END) AS month_five_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Month 5' THEN tbs.test_result END) AS month_five_result,
    MAX(CASE WHEN tbs.tb_time = 'Month 5' THEN tbs.weight END) AS month_five_weight,
    -- Month 6
    MAX(CASE WHEN tbs.tb_time = 'Month 6' THEN tbs.test_type END) AS month_six_test,
    MAX(CASE WHEN tbs.tb_time = 'Month 6' THEN tbs.test_date END) AS month_six_test_date,
    MAX(CASE WHEN tbs.tb_time = 'Month 6' THEN tbs.serial_number END) AS month_six_lab_serial_number,
    MAX(CASE WHEN tbs.tb_time = 'Month 6' THEN tbs.test_result END) AS month_six_result,
    MAX(CASE WHEN tbs.tb_time = 'Month 6' THEN tbs.weight END) AS month_six_weight
FROM omrs_encounter e
LEFT JOIN (
    -- Pivot each 'Tuberculosis test set' obs group into a single row
    SELECT
        og.encounter_id,
        og.obs_group_id,
        MAX(CASE WHEN oi.concept = 'TB Test time' THEN oi.value_coded END) AS tb_time,
        MAX(CASE WHEN oi.concept = 'Tuberculosis test type' THEN oi.value_coded END) AS test_type,
        MAX(CASE WHEN oi.concept = 'Date of general test' THEN oi.value_date END) AS test_date,
        MAX(CASE WHEN oi.concept = 'Lab test serial number' THEN oi.value_text END) AS serial_number,
        MAX(CASE WHEN oi.concept = 'Other lab test result' THEN oi.value_text END) AS test_result,
        MAX(CASE WHEN oi.concept = 'Weight (kg)' THEN oi.value_numeric END) AS weight
    FROM omrs_obs_group og
    INNER JOIN omrs_obs oi ON oi.obs_group_id = og.obs_group_id
    WHERE og.concept = 'Tuberculosis test set'
    GROUP BY og.encounter_id, og.obs_group_id
) tbs ON tbs.encounter_id = e.encounter_id
WHERE e.encounter_type = 'TB_INITIAL'
GROUP BY e.patient_id, e.encounter_date, e.location;

