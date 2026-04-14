-- Derivation script for mw_patient
-- Generated from Pentaho transform: import-into-mw-patient.ktr

DROP TABLE IF EXISTS mw_patient;
CREATE TABLE mw_patient (
  patient_id            INT NOT NULL,
  identifier            VARCHAR(50),
  first_name            VARCHAR(50),
  last_name             VARCHAR(50),
  gender                CHAR(1),
  birthdate             DATE,
  birthdate_estimated   BOOLEAN,
  phone_number          VARCHAR(50),
  district              VARCHAR(255),
  traditional_authority VARCHAR(255),
  village               VARCHAR(255),
  chw                   VARCHAR(100),
  dead                  BOOLEAN,
  death_date            DATE,
  patient_uuid	 	 CHAR(38)
);
alter table mw_patient add index mw_patient_id_idx (patient_id);

INSERT INTO mw_patient
SELECT
    p.patient_id,
    p.identifier,
    p.first_name,
    p.last_name,
    p.gender,
    p.birthdate,
    p.birthdate_estimated,
    p.phone_number,
    p.state_province AS district,
    p.county_district AS traditional_authority,
    p.city_village AS village,
    chw.related_person AS chw,
    p.dead,
    p.death_date,
    p.patient_uuid
FROM omrs_patient p
LEFT JOIN omrs_relationship chw ON chw.relationship_id = (
    SELECT r.relationship_id
    FROM omrs_relationship r
    WHERE r.patient_id = p.patient_id
    AND r.related_person_role = 'Community Health Worker'
    ORDER BY IF(r.end_date IS NULL, 1, 0) DESC,
             IF(r.start_date IS NULL, 0, 1) DESC,
             r.date_created DESC
    LIMIT 1
);
