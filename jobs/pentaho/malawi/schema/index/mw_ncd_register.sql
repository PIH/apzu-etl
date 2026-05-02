alter table mw_ncd_register add index mw_ncd_register_patient_idx (patient_id);
alter table mw_ncd_register add index mw_ncd_register_patient_location_idx (patient_id, location);
