-- Derivation script for mw_pdc_complications
-- Generated from Pentaho transform: import-into-mw-pdc-complications.ktr

DROP TABLE IF EXISTS mw_pdc_complications;
CREATE TABLE mw_pdc_complications (
  pdc_complications_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  date_of_complication			date DEFAULT NULL,
  self_reported_complication		varchar(255) DEFAULT NULL,
  details_of_complications		varchar(255) DEFAULT NULL,
  PRIMARY KEY (pdc_complications_id)
) ;

INSERT INTO mw_pdc_complications
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Date of complication' THEN o.value_date END) as date_of_complication,
    MAX(CASE WHEN o.concept = 'Details of Complications' THEN o.value_text END) as details_of_complications,
    MAX(CASE WHEN o.concept = 'Complications since last visit' THEN o.value_coded END) as self_reported_complication
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('PDC_COMPLICATIONS')
GROUP BY e.patient_id, e.encounter_date, e.location;