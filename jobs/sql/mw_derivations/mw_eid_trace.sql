DROP TABLE IF EXISTS mw_eid_trace;
CREATE TABLE mw_eid_trace (
  patient_id                              INT NOT NULL,
  location                                VARCHAR(255),
  eid_number                              VARCHAR(50),
  last_visit_date                         DATE,
  next_appointment_date                   DATE,
  birthdate                               DATE,
  breastfeeding_stopped_over_6_weeks_date DATE,
  last_pcr_result                         VARCHAR(255),
  last_pcr_result_date                    DATE,
  second_to_last_pcr_result               VARCHAR(255),
  second_to_last_pcr_result_date          DATE
);

-- Active EID patients with last visit, PCR results, and breastfeeding info
INSERT INTO mw_eid_trace
SELECT
    r.patient_id,
    r.location,
    r.eid_number,
    v.visit_date AS last_visit_date,
    v.next_appointment_date,
    p.birthdate,
    bf.breastfeeding_stopped_over_6_weeks_date,
    pcr1.last_pcr_result,
    pcr1.last_pcr_result_date,
    pcr2.second_to_last_pcr_result,
    pcr2.second_to_last_pcr_result_date
FROM mw_eid_register r
INNER JOIN mw_patient p ON r.patient_id = p.patient_id
LEFT JOIN mw_eid_visits v ON v.eid_visit_id = r.last_eid_visit_id
LEFT JOIN (
    -- Date on which patient first stopped breastfeeding over 6 weeks ago,
    -- after any other different breastfeeding status was recorded
    SELECT
        v1.patient_id,
        MIN(v1.visit_date) AS breastfeeding_stopped_over_6_weeks_date
    FROM mw_eid_visits v1
    LEFT JOIN (
        SELECT v2.patient_id, MAX(v2.visit_date) AS last_non_6_wk_status_date
        FROM mw_eid_visits v2
        WHERE v2.breastfeeding_status != 'Breastfeeding stopped over 6 weeks ago'
        GROUP BY v2.patient_id
    ) ls ON v1.patient_id = ls.patient_id
    WHERE v1.breastfeeding_status = 'Breastfeeding stopped over 6 weeks ago'
    AND (ls.last_non_6_wk_status_date IS NULL OR v1.visit_date >= ls.last_non_6_wk_status_date)
    GROUP BY v1.patient_id
) bf ON bf.patient_id = r.patient_id
LEFT JOIN (
    -- Most recent PCR result
    SELECT
        t.patient_id,
        t.result_coded AS last_pcr_result,
        COALESCE(t.date_collected, t.date_result_received, t.date_result_entered) AS last_pcr_result_date
    FROM mw_lab_tests t
    WHERE t.lab_test_id = (
        SELECT t1.lab_test_id
        FROM mw_lab_tests t1
        WHERE t1.patient_id = t.patient_id
        AND t1.test_type = 'HIV DNA polymerase chain reaction'
        AND t1.result_coded IS NOT NULL
        ORDER BY COALESCE(t1.date_collected, t1.date_result_received, t1.date_result_entered) DESC
        LIMIT 1
    )
) pcr1 ON pcr1.patient_id = r.patient_id
LEFT JOIN (
    -- Second to last PCR result
    SELECT
        t.patient_id,
        t.result_coded AS second_to_last_pcr_result,
        COALESCE(t.date_collected, t.date_result_received, t.date_result_entered) AS second_to_last_pcr_result_date
    FROM mw_lab_tests t
    WHERE t.lab_test_id = (
        SELECT t1.lab_test_id
        FROM mw_lab_tests t1
        WHERE t1.patient_id = t.patient_id
        AND t1.test_type = 'HIV DNA polymerase chain reaction'
        AND t1.result_coded IS NOT NULL
        ORDER BY COALESCE(t1.date_collected, t1.date_result_received, t1.date_result_entered) DESC
        LIMIT 1
        OFFSET 1
    )
) pcr2 ON pcr2.patient_id = r.patient_id
WHERE r.end_date IS NULL;
