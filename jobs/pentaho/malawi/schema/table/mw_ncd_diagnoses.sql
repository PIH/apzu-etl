
create table mw_ncd_diagnoses (
  patient_id     	INT          NOT NULL,
  diagnosis      	VARCHAR(100) NOT NULL,
  diagnosis_date 	DATE         NOT NULL,
  encounter_type       VARCHAR(255),
  location       	VARCHAR(255)
);
alter table mw_ncd_diagnoses add index mw_ncd_diagnoses_patient_idx (patient_id);
