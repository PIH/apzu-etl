alter table mw_pdc_register add index mw_pdc_register_patient_idx (patient_id);
alter table mw_pdc_register add index mw_pdc_register_patient_location_idx (patient_id, location);
