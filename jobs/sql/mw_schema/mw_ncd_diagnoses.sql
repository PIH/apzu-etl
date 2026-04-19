
create table mw_ncd_diagnoses (
  patient_id     	int          not null,
  diagnosis      	varchar(100) not null,
  diagnosis_date 	date         not null,
  encounter_type       varchar(255),
  location       	varchar(255)
);
alter table mw_ncd_diagnoses add index mw_ncd_diagnoses_patient_idx (patient_id);
