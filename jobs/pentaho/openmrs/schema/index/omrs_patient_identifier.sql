alter table omrs_patient_identifier add index patient_identifier_id_idx (patient_identifier_id);
alter table omrs_patient_identifier add index omrs_patient_identifier_patient_idx (patient_id);
alter table omrs_patient_identifier add index omrs_patient_identifier_location_idx (location);
