-- Minimal synthetic OpenMRS source fixture, for verifying the Malawi reporting
-- pipeline (openmrs source -> MySQL warehouse -> SQL Server) end to end
-- without needing a real backup. All data below is fabricated --
-- no real patient or employee data of any kind.
--
-- Usage:
--   openmrs-docker <instance> restore --from-dump docs/fixtures/minimal-openmrs.sql
-- See docs/docker-reporting-runbook.md for the full procedure.
--
-- Scope: contains ONLY the tables/columns that jobs/refresh-omrs-tables.yml's
-- Pentaho transforms (jobs/pentaho/openmrs/transforms/*.ktr) and
-- jobs/refresh-mw-tables.yml's mw_users.ktr actually SELECT from the "OpenMRS"
-- (source) connection, traced by reading each transform's embedded SQL. See
-- docs/docker-reporting-runbook.md for how this was derived. Types are
-- intentionally loose (no FK constraints) since MySQL 5.6 (the openmrs-db
-- image) just needs to run these SELECTs successfully -- referential
-- integrity is guaranteed by hand here, not enforced by the schema.

USE openmrs;

-- ===================== Reference / lookup tables =====================

CREATE TABLE location (
  location_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE encounter_role (
  encounter_role_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE encounter_type (
  encounter_type_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE visit_type (
  visit_type_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE form (
  form_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE patient_identifier_type (
  patient_identifier_type_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE person_attribute_type (
  person_attribute_type_id INT PRIMARY KEY,
  name VARCHAR(255),
  format VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE relationship_type (
  relationship_type_id INT PRIMARY KEY,
  a_is_to_b VARCHAR(255),
  b_is_to_a VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE drug (
  drug_id INT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE concept (
  concept_id INT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE concept_name (
  concept_name_id INT PRIMARY KEY,
  concept_id INT,
  name VARCHAR(255),
  voided TINYINT(1) DEFAULT 0,
  concept_name_type VARCHAR(50),
  locale VARCHAR(20),
  locale_preferred TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE program (
  program_id INT PRIMARY KEY,
  concept_id INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE program_workflow (
  program_workflow_id INT PRIMARY KEY,
  program_id INT,
  concept_id INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE program_workflow_state (
  program_workflow_state_id INT PRIMARY KEY,
  program_workflow_id INT,
  concept_id INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================== People =====================

CREATE TABLE person (
  person_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  gender VARCHAR(10),
  birthdate DATE,
  birthdate_estimated TINYINT(1) DEFAULT 0,
  dead TINYINT(1) DEFAULT 0,
  death_date DATETIME,
  cause_of_death INT,
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE patient (
  patient_id INT PRIMARY KEY,
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE person_name (
  person_name_id INT PRIMARY KEY,
  person_id INT,
  given_name VARCHAR(255),
  middle_name VARCHAR(255),
  family_name_prefix VARCHAR(255),
  family_name VARCHAR(255),
  family_name2 VARCHAR(255),
  family_name_suffix VARCHAR(255),
  preferred TINYINT(1) DEFAULT 0,
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE person_address (
  person_address_id INT PRIMARY KEY,
  person_id INT,
  country VARCHAR(255),
  postal_code VARCHAR(255),
  state_province VARCHAR(255),
  county_district VARCHAR(255),
  city_village VARCHAR(255),
  address1 VARCHAR(255),
  address2 VARCHAR(255),
  address3 VARCHAR(255),
  address4 VARCHAR(255),
  address5 VARCHAR(255),
  address6 VARCHAR(255),
  latitude VARCHAR(50),
  longitude VARCHAR(50),
  preferred TINYINT(1) DEFAULT 0,
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE person_attribute (
  person_attribute_id INT PRIMARY KEY,
  person_id INT,
  person_attribute_type_id INT,
  value VARCHAR(255),
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE patient_identifier (
  patient_identifier_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  patient_id INT,
  identifier_type INT,
  identifier VARCHAR(255),
  location_id INT,
  preferred TINYINT(1) DEFAULT 0,
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE provider (
  provider_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  person_id INT,
  name VARCHAR(255),
  identifier VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  person_id INT,
  creator INT,
  username VARCHAR(255),
  system_id VARCHAR(255),
  email VARCHAR(255),
  retired TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE relationship (
  relationship_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  person_a INT,
  person_b INT,
  relationship INT,
  start_date DATE,
  end_date DATE,
  date_created DATETIME,
  voided TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================== Visits / encounters / obs =====================

CREATE TABLE visit (
  visit_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  location_id INT,
  visit_type_id INT,
  date_started DATETIME,
  date_stopped DATETIME,
  patient_id INT,
  date_created DATETIME,
  voided TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE encounter (
  encounter_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  location_id INT,
  encounter_type INT,
  form_id INT,
  encounter_datetime DATETIME,
  patient_id INT,
  date_created DATETIME,
  creator INT,
  visit_id INT,
  voided TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE encounter_provider (
  encounter_provider_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  encounter_id INT,
  provider_id INT,
  encounter_role_id INT,
  voided TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE obs (
  obs_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  concept_id INT,
  obs_datetime DATETIME,
  encounter_id INT,
  person_id INT,
  value_coded INT,
  value_drug INT,
  value_numeric DOUBLE,
  value_datetime DATETIME,
  value_text TEXT,
  comments VARCHAR(255),
  obs_group_id INT,
  voided TINYINT(1) DEFAULT 0,
  date_created DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================== Programs =====================

CREATE TABLE patient_program (
  patient_program_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  patient_id INT,
  program_id INT,
  date_enrolled DATETIME,
  location_id INT,
  date_completed DATETIME,
  outcome_concept_id INT,
  voided TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE patient_state (
  patient_state_id INT PRIMARY KEY,
  uuid VARCHAR(38),
  patient_program_id INT,
  state INT,
  start_date DATE,
  end_date DATE,
  voided TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================== Extra tables read by mw_users.ktr =====================

CREATE TABLE authentication_event_log (
  user_id INT,
  event_type VARCHAR(50),
  event_datetime DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE user_property (
  user_id INT,
  property VARCHAR(255),
  property_value VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================== Synthetic data =====================

INSERT INTO location (location_id, name) VALUES (1, 'Unknown Location');
INSERT INTO encounter_role (encounter_role_id, name) VALUES (1, 'Clinician');
INSERT INTO encounter_type (encounter_type_id, name) VALUES (1, 'Consultation');
INSERT INTO visit_type (visit_type_id, name) VALUES (1, 'Outpatient');
INSERT INTO form (form_id, name) VALUES (1, 'Test Form');
INSERT INTO patient_identifier_type (patient_identifier_type_id, name) VALUES (1, 'Test ID');
INSERT INTO person_attribute_type (person_attribute_type_id, name, format) VALUES (1, 'Test Attribute', 'java.lang.String');
INSERT INTO relationship_type (relationship_type_id, a_is_to_b, b_is_to_a) VALUES (1, 'Parent', 'Child');
INSERT INTO drug (drug_id, name) VALUES (1, 'Test Drug');

INSERT INTO concept (concept_id) VALUES (1), (2), (3), (4);
INSERT INTO concept_name (concept_name_id, concept_id, name, voided, concept_name_type, locale, locale_preferred) VALUES
  (1, 1, 'Test Program', 0, 'FULLY_SPECIFIED', 'en', 1),
  (2, 2, 'Weight (kg)', 0, 'FULLY_SPECIFIED', 'en', 1),
  (3, 3, 'Test Workflow', 0, 'FULLY_SPECIFIED', 'en', 1),
  (4, 4, 'Test State', 0, 'FULLY_SPECIFIED', 'en', 1);

INSERT INTO program (program_id, concept_id) VALUES (1, 1);
INSERT INTO program_workflow (program_workflow_id, program_id, concept_id) VALUES (1, 1, 3);
INSERT INTO program_workflow_state (program_workflow_state_id, program_workflow_id, concept_id) VALUES (1, 1, 4);

-- person_id 1 = admin/creator (not a patient); 2 and 3 = synthetic patients
INSERT INTO person (person_id, uuid, gender, birthdate, birthdate_estimated, dead, death_date, cause_of_death, voided, date_created) VALUES
  (1, '11111111-1111-1111-1111-111111111111', 'M', '1980-01-01', 0, 0, NULL, NULL, 0, '2023-01-01 00:00:00'),
  (2, '22222222-2222-2222-2222-222222222222', 'F', '1990-05-15', 0, 0, NULL, NULL, 0, '2023-01-01 00:00:00'),
  (3, '33333333-3333-3333-3333-333333333333', 'M', '2000-11-02', 0, 0, NULL, NULL, 0, '2023-01-01 00:00:00');

INSERT INTO patient (patient_id, voided, date_created) VALUES
  (2, 0, '2023-01-01 00:00:00'),
  (3, 0, '2023-01-01 00:00:00');

INSERT INTO person_name (person_name_id, person_id, given_name, middle_name, family_name_prefix, family_name, family_name2, family_name_suffix, preferred, voided, date_created) VALUES
  (1, 1, 'Admin', NULL, NULL, 'User', NULL, NULL, 1, 0, '2023-01-01 00:00:00'),
  (2, 2, 'Jane', NULL, NULL, 'TestPatient', NULL, NULL, 1, 0, '2023-01-01 00:00:00'),
  (3, 3, 'John', NULL, NULL, 'TestPatient', NULL, NULL, 1, 0, '2023-01-01 00:00:00');

INSERT INTO person_address (person_address_id, person_id, country, postal_code, state_province, county_district, city_village, address1, address2, address3, address4, address5, address6, latitude, longitude, preferred, voided, date_created) VALUES
  (1, 2, 'Malawi', NULL, NULL, NULL, 'Neno', '123 Test Rd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, '2023-01-01 00:00:00');

INSERT INTO person_attribute (person_attribute_id, person_id, person_attribute_type_id, value, voided, date_created) VALUES
  (1, 2, 1, 'test-value', 0, '2023-01-01 00:00:00');

INSERT INTO patient_identifier (patient_identifier_id, uuid, patient_id, identifier_type, identifier, location_id, preferred, voided, date_created) VALUES
  (1, 'a1111111-1111-1111-1111-111111111111', 2, 1, 'TEST-0001', 1, 1, 0, '2023-01-01 00:00:00'),
  (2, 'a2222222-2222-2222-2222-222222222222', 3, 1, 'TEST-0002', 1, 1, 0, '2023-01-01 00:00:00');

INSERT INTO provider (provider_id, uuid, person_id, name, identifier) VALUES
  (1, 'b1111111-1111-1111-1111-111111111111', 1, 'Test Provider', 'PROV-1');

INSERT INTO users (user_id, uuid, person_id, creator, username, system_id, email, retired, date_created) VALUES
  (1, 'c1111111-1111-1111-1111-111111111111', 1, 1, 'admin', 'admin', 'admin@example.org', 0, '2023-01-01 00:00:00');

INSERT INTO relationship (relationship_id, uuid, person_a, person_b, relationship, start_date, end_date, date_created, voided) VALUES
  (1, 'd1111111-1111-1111-1111-111111111111', 2, 3, 1, '2020-01-01', NULL, '2023-01-01 00:00:00', 0);

INSERT INTO visit (visit_id, uuid, location_id, visit_type_id, date_started, date_stopped, patient_id, date_created, voided) VALUES
  (1, 'e1111111-1111-1111-1111-111111111111', 1, 1, '2023-01-10 08:00:00', '2023-01-10 09:00:00', 2, '2023-01-10 08:00:00', 0);

INSERT INTO encounter (encounter_id, uuid, location_id, encounter_type, form_id, encounter_datetime, patient_id, date_created, creator, visit_id, voided) VALUES
  (1, 'f1111111-1111-1111-1111-111111111111', 1, 1, 1, '2023-01-10 08:30:00', 2, '2023-01-10 08:30:00', 1, 1, 0);

INSERT INTO encounter_provider (encounter_provider_id, uuid, encounter_id, provider_id, encounter_role_id, voided) VALUES
  (1, 'g1111111-1111-1111-1111-111111111111', 1, 1, 1, 0);

-- obs_id 1: simple numeric obs. obs_id 2/3: an obs group (parent + one child)
-- to exercise the is_obs_group detection in import-into-omrs-obs.ktr.
INSERT INTO obs (obs_id, uuid, concept_id, obs_datetime, encounter_id, person_id, value_coded, value_drug, value_numeric, value_datetime, value_text, comments, obs_group_id, voided, date_created) VALUES
  (1, 'h1111111-1111-1111-1111-111111111111', 2, '2023-01-10 08:30:00', 1, 2, NULL, NULL, 62.5, NULL, NULL, NULL, NULL, 0, '2023-01-10 08:30:00'),
  (2, 'h2222222-2222-2222-2222-222222222222', 3, '2023-01-10 08:30:00', 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2023-01-10 08:30:00'),
  (3, 'h3333333-3333-3333-3333-333333333333', 4, '2023-01-10 08:30:00', 1, 2, 4, NULL, NULL, NULL, NULL, NULL, 2, 0, '2023-01-10 08:30:00');

INSERT INTO patient_program (patient_program_id, uuid, patient_id, program_id, date_enrolled, location_id, date_completed, outcome_concept_id, voided) VALUES
  (1, 'i1111111-1111-1111-1111-111111111111', 2, 1, '2023-01-10 00:00:00', 1, NULL, NULL, 0);

INSERT INTO patient_state (patient_state_id, uuid, patient_program_id, state, start_date, end_date, voided) VALUES
  (1, 'j1111111-1111-1111-1111-111111111111', 1, 1, '2023-01-10', NULL, 0);

INSERT INTO authentication_event_log (user_id, event_type, event_datetime) VALUES
  (1, 'LOGIN_SUCCEEDED', '2023-01-10 08:00:00');

INSERT INTO user_property (user_id, property, property_value) VALUES
  (1, 'authentication.secondaryType', 'disabled');
