alter table mw_pre_art_register add index mw_pre_art_register_patient_idx (patient_id);
alter table mw_pre_art_register add index mw_pre_art_register_patient_location_idx (patient_id, location);
