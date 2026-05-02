CREATE TABLE mw_eid_register (
  enrollment_id                    INT NOT NULL,
  patient_id                       INT NOT NULL,
  location                         VARCHAR(255),
  eid_number                       VARCHAR(50),
  mother_art_number				   VARCHAR(100),
  start_date                       DATE,
  end_date                         DATE,
  outcome                          VARCHAR(100),
  last_eid_visit_id                INT
);