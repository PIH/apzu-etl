CREATE TABLE mw_patient_2 (
    patient_id            INT NOT NULL PRIMARY KEY,
    patient_uuid	 	  CHAR(38),
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
    death_date            DATE
);