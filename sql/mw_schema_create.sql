
-- Schema used to set up the mw_* tables for transformed OpenMRS Malawi data

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
  vhw                   VARCHAR(100),
  dead                  BOOLEAN,
  death_date            DATE
);

CREATE TABLE mw_lab_tests (
  lab_test_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id           INT NOT NULL,
  date_collected       DATE,
  test_type            VARCHAR(100),
  date_result_received DATE,
  date_result_entered  DATE,
  result_coded         VARCHAR(100),
  result_numeric       DOUBLE,
  result_exception     VARCHAR(100)
);

CREATE TABLE mw_eid_visits (
  eid_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  breastfeeding_status  VARCHAR(100),
  next_appointment_date DATE
);

CREATE TABLE mw_eid_register (
  enrollment_id                    INT NOT NULL,
  patient_id                       INT NOT NULL,
  location                         VARCHAR(255),
  eid_number                       VARCHAR(50),
  start_date                       DATE,
  end_date                         DATE,
  outcome                          VARCHAR(100),
  last_eid_visit_id                INT
);

CREATE TABLE mw_eid_trace (
  patient_id                              INT NOT NULL,
  location                                VARCHAR(255),
  eid_number                              VARCHAR(50),
  last_visit_date                         DATE,
  next_appointment_date                   DATE,
  birthdate                               DATE,
  breastfeeding_stopped_over_6_weeks_date DATE,
  last_pcr_result                         VARCHAR(100),
  last_pcr_result_date                    DATE,
  second_to_last_pcr_result               VARCHAR(100)
);

CREATE TABLE mw_art_visits (
  art_visit_id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id            INT NOT NULL,
  visit_date            DATE,
  location              VARCHAR(255),
  next_appointment_date DATE
);

CREATE TABLE mw_art_register (
  enrollment_id     INT NOT NULL,
  patient_id        INT NOT NULL,
  location          VARCHAR(255),
  art_number        VARCHAR(50),
  start_date        DATE,
  end_date          DATE,
  outcome           VARCHAR(100),
  last_art_visit_id INT
);

create table mw_ncd_visits (
  patient_id                          INT NOT NULL,
  encounter_date                      DATE NOT NULL,
  encounter_location                  INT,
  has_hypertension                    BOOLEAN,
  has_diabetes                        BOOLEAN,
  has_asthma                          BOOLEAN,
  has_epilepsy                        BOOLEAN,
  has_sickle_cell_disease             BOOLEAN,
  has_chronic_kidney_disease          BOOLEAN,
  has_rheumatic_heart_disease         BOOLEAN,
  has_congestive_heart_failure        BOOLEAN,
  systolic_bp                         DOUBLE,
  diastolic_bp                        DOUBLE,
  on_insulin                          BOOLEAN,
  asthma_severity                     VARCHAR(100),
  num_seizures_per_month              DOUBLE
);

create table mw_ncd_register (
  patient_id                  INT NOT NULL,
  location                    INT NOT NULL,
  ncd_start_date              DATE,
  outcome_date                DATE,
  ncd_number                  VARCHAR(100),
  last_visit_date             DATE,
  next_appointment_date       DATE,
  diagnoses                   VARCHAR(255),
  ever_high_bp                BOOLEAN,
  ever_on_insulin             BOOLEAN,
  last_asthma_severity        VARCHAR(100),
  last_num_seizures_per_month DOUBLE
);