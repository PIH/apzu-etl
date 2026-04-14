DROP TABLE IF EXISTS mw_art_trace;
CREATE TABLE mw_art_trace (
  patient_id                        INT NOT NULL,
  location                          VARCHAR(255),
  art_number                        VARCHAR(50),
  last_visit_date                   DATE,
  next_appointment_date             DATE,
  last_viral_load_result_date       DATE,
  last_viral_load_result_numeric    DECIMAL(10,2),
  last_viral_load_result_exception  VARCHAR(100),
  last_viral_load_test_date         DATE
);

-- Active ART patients with last visit and viral load info
INSERT INTO mw_art_trace
SELECT
    r.patient_id,
    r.location,
    r.art_number,
    v.visit_date AS last_visit_date,
    v.next_appointment_date,
    vr.date_collected AS last_viral_load_result_date,
    vr.result_numeric AS last_viral_load_result_numeric,
    vr.result_exception AS last_viral_load_result_exception,
    vt.date_collected AS last_viral_load_test_date
FROM mw_art_register r
INNER JOIN mw_patient p ON r.patient_id = p.patient_id
LEFT JOIN mw_art_visits v ON v.art_visit_id = r.last_art_visit_id
LEFT JOIN mw_lab_tests vt ON vt.lab_test_id = r.last_viral_load_test_id
LEFT JOIN mw_lab_tests vr ON vr.lab_test_id = r.last_viral_load_result_id
WHERE r.end_date IS NULL;
