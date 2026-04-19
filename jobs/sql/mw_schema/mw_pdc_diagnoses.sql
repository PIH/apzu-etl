create table mw_pdc_diagnoses (
  patient_id     	int          not null,
  diagnosis    	varchar(255) not null,
  comments		varchar(255) default null,
  encounter_type 	varchar(255) not null,
  location  		varchar(255) not null,
  visit_date		date
);
alter table mw_pdc_diagnoses add index mw_pdc_diagnoses_patient_idx (patient_id);
