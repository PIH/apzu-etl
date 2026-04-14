DROP TABLE IF EXISTS mw_lab_tests_recent_period;
CREATE TABLE mw_lab_tests_recent_period (
  lab_test_id          INT NOT NULL,
  patient_id           INT NOT NULL,
  encounter_id         INT,
  date_collected       DATE,
  test_type            VARCHAR(100),
  date_result_received DATE,
  date_result_entered  DATE,
  result_coded         VARCHAR(100),
  result_numeric       DECIMAL(10,2),
  result_exception     VARCHAR(100),
  end_date             DATE
);

-- Most recent lab test result per patient per reporting period
INSERT INTO mw_lab_tests_recent_period
SELECT
    t.lab_test_id,
    t.patient_id,
    t.encounter_id,
    t.date_collected,
    t.test_type,
    t.date_result_received,
    t.date_result_entered,
    t.result_coded,
    t.result_numeric,
    t.result_exception,
    p.end_date
FROM mw_selected_periods p
CROSS JOIN omrs_patient pat
INNER JOIN omrs_program_enrollment enr ON enr.patient_id = pat.patient_id AND enr.program = 'HIV Program'
INNER JOIN (
    SELECT
        t1.patient_id,
        p1.end_date,
        MIN(t1.lab_test_id) as last_test_id
    FROM (
        SELECT
            t2.patient_id,
            p2.end_date,
            MAX(t2.date_collected) as last_test_date
        FROM mw_lab_tests t2
        CROSS JOIN mw_selected_periods p2
        WHERE t2.test_type = 'Viral Load'
        AND t2.date_collected <= p2.end_date
        GROUP BY t2.patient_id, p2.end_date
    ) latest
    INNER JOIN mw_lab_tests t1
        ON t1.patient_id = latest.patient_id
        AND t1.date_collected = latest.last_test_date
    INNER JOIN mw_selected_periods p1
        ON p1.end_date = latest.end_date
    WHERE t1.test_type = 'Viral Load'
    GROUP BY t1.patient_id, p1.end_date
) most_recent ON most_recent.patient_id = pat.patient_id AND most_recent.end_date = p.end_date
INNER JOIN mw_lab_tests t ON t.lab_test_id = most_recent.last_test_id;
