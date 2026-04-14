DROP TABLE IF EXISTS mw_last_obs_in_period;
CREATE TABLE mw_last_obs_in_period (
  patient_id   INT NOT NULL,
  concept      VARCHAR(255),
  last_obs_date DATE,
  encounter_type VARCHAR(255),
  location     VARCHAR(255),
  value_coded  VARCHAR(255),
  value_date   DATE,
  value_numeric FLOAT,
  value_text   TEXT,
  obs_group_id INT
);

-- Most recent obs per patient per concept up to each selected period end date
INSERT INTO mw_last_obs_in_period
SELECT
    o.patient_id,
    o.concept,
    o.obs_date as last_obs_date,
    o.encounter_type,
    o.location,
    o.value_coded,
    o.value_date,
    o.value_numeric,
    o.value_text,
    o.obs_group_id
FROM omrs_obs o
INNER JOIN (
    SELECT
        o2.patient_id,
        o2.concept,
        MAX(o2.obs_date) as last_obs_date
    FROM omrs_obs o2
    CROSS JOIN mw_selected_periods p
    WHERE o2.concept IN (SELECT concept FROM mw_concepts_selected)
    AND o2.obs_date <= p.end_date
    GROUP BY o2.patient_id, o2.concept
) latest ON latest.patient_id = o.patient_id
        AND latest.concept = o.concept
        AND latest.last_obs_date = o.obs_date;
