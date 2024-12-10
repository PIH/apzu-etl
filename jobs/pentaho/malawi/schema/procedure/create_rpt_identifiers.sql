/************************************************************************
Get identifiers for the patient at the given location and overall
*************************************************************************/
CREATE PROCEDURE create_rpt_identifiers(IN _location VARCHAR(255)) BEGIN

  DROP TEMPORARY TABLE IF EXISTS rpt_identifiers;
  CREATE TEMPORARY TABLE rpt_identifiers (
    patient_id          	INT NOT NULL PRIMARY KEY,
    art_number          	VARCHAR(50),
    all_art_numbers     	VARCHAR(1000),
    eid_number          	VARCHAR(50),
    all_eid_numbers     	VARCHAR(1000),
    pre_art_number      	VARCHAR(50),
    all_pre_art_numbers 	VARCHAR(1000),
    ncd_number     		VARCHAR(50),
    pdc_number     		VARCHAR(50),
    all_ncd_numbers		VARCHAR(1000),
    yendanafe_number		VARCHAR(50),
    all_yendanafe_numbers	VARCHAR(1000)
  );
  CREATE INDEX rpt_identifiers_patient_id_idx ON rpt_identifiers(patient_id);

  INSERT INTO rpt_identifiers (patient_id, art_number)
    SELECT r.patient_id, r.art_number from mw_art_register r where r.location = _location
  ON DUPLICATE KEY UPDATE art_number = values(art_number);

  INSERT INTO rpt_identifiers (patient_id, all_art_numbers)
    SELECT r.patient_id, group_concat(DISTINCT art_number ORDER BY art_number asc SEPARATOR ', ') FROM mw_art_register r GROUP BY r.patient_id
  ON DUPLICATE KEY UPDATE all_art_numbers = values(all_art_numbers);

  INSERT INTO rpt_identifiers (patient_id, eid_number)
    SELECT r.patient_id, r.eid_number from mw_eid_register r where r.location = _location
  ON DUPLICATE KEY UPDATE eid_number = values(eid_number);

  INSERT INTO rpt_identifiers (patient_id, all_eid_numbers)
    SELECT r.patient_id, group_concat(DISTINCT eid_number ORDER BY eid_number asc SEPARATOR ', ') FROM mw_eid_register r GROUP BY r.patient_id
  ON DUPLICATE KEY UPDATE all_eid_numbers = values(all_eid_numbers);

  INSERT INTO rpt_identifiers (patient_id, pre_art_number)
    SELECT r.patient_id, r.pre_art_number from mw_pre_art_register r where r.location = _location
  ON DUPLICATE KEY UPDATE pre_art_number = values(pre_art_number);

  INSERT INTO rpt_identifiers (patient_id, all_pre_art_numbers)
    SELECT r.patient_id, group_concat(DISTINCT pre_art_number ORDER BY pre_art_number asc SEPARATOR ', ') FROM mw_pre_art_register r GROUP BY r.patient_id
  ON DUPLICATE KEY UPDATE all_pre_art_numbers = values(all_pre_art_numbers);

  INSERT INTO rpt_identifiers (patient_id, ncd_number)
    SELECT r.patient_id, r.ncd_number from mw_ncd_register r where r.location = _location
  ON DUPLICATE KEY UPDATE ncd_number = values(ncd_number);

  INSERT INTO rpt_identifiers (patient_id, all_ncd_numbers)
    SELECT r.patient_id, group_concat(DISTINCT ncd_number ORDER BY ncd_number asc SEPARATOR ', ') FROM mw_ncd_register r GROUP BY r.patient_id
  ON DUPLICATE KEY UPDATE all_ncd_numbers = values(all_ncd_numbers);

  INSERT INTO rpt_identifiers (patient_id, pdc_number)
  SELECT r.patient_id, r.pdc_number from mw_pdc_register r where r.location = _location
  ON DUPLICATE KEY UPDATE pdc_number = values(pdc_number);
  
  INSERT INTO rpt_identifiers (patient_id, yendanafe_number)
    SELECT opi.patient_id, opi.identifier as yendanafe_number from omrs_patient_identifier opi where opi.location = _location and opi.type = "Yendanafe Identifier"
  ON DUPLICATE KEY UPDATE yendanafe_number = values(yendanafe_number);
  
  INSERT INTO rpt_identifiers (patient_id, all_yendanafe_numbers)
    SELECT opi.patient_id, group_concat(DISTINCT opi.identifier ORDER BY opi.identifier asc SEPARATOR ', ') as all_yendanafe_numbers
    FROM omrs_patient_identifier opi where opi.type = "Yendanafe Identifier" GROUP BY opi.patient_id
  ON DUPLICATE KEY UPDATE all_yendanafe_numbers = values(all_yendanafe_numbers);

END
