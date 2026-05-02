create table mw_pdc_diagnoses (
  patient_id     	INT          NOT NULL,
  diagnosis    	VARCHAR(255) NOT NULL,
  comments		VARCHAR(255) DEFAULT NULL,
  encounter_type 	VARCHAR(255) NOT NULL,
  location  		VARCHAR(255) NOT NULL,
  visit_date		DATE
);
