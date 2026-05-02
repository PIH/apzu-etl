alter table mw_pre_art_visits add index mw_pre_art_visit_patient_idx (patient_id);
alter table mw_pre_art_visits add index mw_pre_art_visit_patient_location_idx (patient_id, location);
