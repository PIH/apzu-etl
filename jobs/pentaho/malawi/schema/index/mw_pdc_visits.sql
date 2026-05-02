alter table mw_pdc_visits add index mw_pdc_visit_patient_idx (patient_id);
alter table mw_pdc_visits add index mw_pdc_visit_patient_location_idx (patient_id, location);
