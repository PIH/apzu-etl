-- Derivation script for mw_tb_initial
-- Generated from Pentaho transform: import-into-mw-tb-initial.ktr

DROP TABLE IF EXISTS mw_tb_initial;
CREATE TABLE mw_tb_initial (
  tb_initial_visit_id 			INT NOT NULL AUTO_INCREMENT,
  patient_id    				INT NOT NULL,
  visit_date            		DATE,
  location              		VARCHAR(255),
  disease_classification 		VARCHAR(255),
  patient_category 				VARCHAR(255),
  diagnosis						VARCHAR(255),
  arv_start_date 				DATE,
  ctx_start_date 				DATE,
  hiv_test_history  			VARCHAR(255),
  regimen_rhze					INT,
  initiation_month_weight		INT,
  dot_option  					VARCHAR(255),
  source_of_referral  			VARCHAR(255),
  dst_result  					VARCHAR(255),
  ptld_date_registered          DATE,
  date_started_prp              DATE,
     PRIMARY KEY (tb_initial_visit_id)
);

INSERT INTO mw_tb_initial
SELECT
    e.patient_id,
    DATE(e.encounter_date) as visit_date,
    e.location,
    MAX(CASE WHEN o.concept = 'Cotrimoxazole Start Date' THEN o.value_date END) as ctx_start_date,
    MAX(CASE WHEN o.concept = 'Date of HIV diagnosis' THEN o.value_date END) as arv_start_date,
    MAX(CASE WHEN o.concept = 'Tuberculosis drug sensitivity testing, non-coded' THEN o.value_text END) as dst_result,
    MAX(CASE WHEN o.concept = 'Date started pulmonary rehabilitation program (PRP)' THEN o.value_date END) as date_started_prp,
    MAX(CASE WHEN o.concept = 'TB Case Confirmation' THEN o.value_coded END) as diagnosis,
    MAX(CASE WHEN o.concept = 'HIV testing completion (coded)' THEN o.value_coded END) as hiv_test_history,
    MAX(CASE WHEN o.concept = 'Date registered in Post TB Lung Disease (PTLD)' THEN o.value_date END) as ptld_date_registered,
    MAX(CASE WHEN o.concept = 'Number of RHZE Tablets' THEN o.value_numeric END) as regimen_rhze,
    MAX(CASE WHEN o.concept = 'Referral Source' THEN o.value_coded END) as source_of_referral,
    MAX(CASE WHEN o.concept = 'Tuberculosis case classification' THEN o.value_coded END) as disease_classification,
    MAX(CASE WHEN o.concept = 'Weight (kg)' THEN o.value_numeric END) as initiation_month_weight,
    MAX(CASE WHEN o.concept = 'Directly observed treatment option' THEN
        CASE o.value_coded
            WHEN 'Primary Guardian' THEN 'Guardian'
            WHEN 'Health care worker' THEN 'HSA'
            WHEN 'Community volunteer' THEN 'Volunteer'
            WHEN 'Village Health Worker' THEN 'HCW'
        END
    END) as dot_option,
    MAX(CASE WHEN o.concept = 'Patient reported current tuberculosis prophylaxis' THEN
        CASE o.value_coded
            WHEN 'New patient' THEN 'New'
            WHEN 'Relapse MDR-TB patient' THEN 'Relapse'
            WHEN 'Treatment after default MDR-TB patient' THEN 'RALFT'
            WHEN 'Failed - TB' THEN 'Fail'
            WHEN 'Other (coded)' THEN 'Other'
            WHEN 'Unknown' THEN 'Unk'
        END
    END) as patient_category
FROM omrs_encounter e
LEFT JOIN omrs_obs o ON o.encounter_id = e.encounter_id
WHERE e.encounter_type IN ('TB_INITIAL')
GROUP BY e.patient_id, e.encounter_date, e.location;
