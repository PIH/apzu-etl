DROP TABLE IF EXISTS mw_selected_periods;
CREATE TABLE mw_selected_periods (
	year INT,
    quarter INT,
    yearquarter VARCHAR(255),
    start_date DATE,
    end_date DATE,
    zero INT
);

-- Generate quarterly periods from 2016Q1 through the current quarter
INSERT INTO mw_selected_periods (year, quarter, yearquarter, start_date, end_date, zero)
WITH RECURSIVE quarters AS (
    SELECT 2016 AS yr, 1 AS q
    UNION ALL
    SELECT CASE WHEN q = 4 THEN yr + 1 ELSE yr END,
           CASE WHEN q = 4 THEN 1 ELSE q + 1 END
    FROM quarters
    WHERE yr < YEAR(NOW()) OR (yr = YEAR(NOW()) AND q <= QUARTER(NOW()))
)
SELECT
    yr,
    q,
    CONCAT(yr, 'Q', q),
    CASE q WHEN 1 THEN DATE(CONCAT(yr, '-01-01'))
            WHEN 2 THEN DATE(CONCAT(yr, '-04-01'))
            WHEN 3 THEN DATE(CONCAT(yr, '-07-01'))
            WHEN 4 THEN DATE(CONCAT(yr, '-10-01')) END,
    CASE q WHEN 1 THEN DATE(CONCAT(yr, '-03-31'))
            WHEN 2 THEN DATE(CONCAT(yr, '-06-30'))
            WHEN 3 THEN DATE(CONCAT(yr, '-09-30'))
            WHEN 4 THEN DATE(CONCAT(yr, '-12-31')) END,
    0
FROM quarters;
