alter table omrs_visit add index omrs_visit_id_idx (visit_id);
alter table omrs_visit add index omrs_visit_patient_idx (patient_id);
alter table omrs_visit add index omrs_visit_date_started_idx (date_started);
alter table omrs_visit add index omrs_visit_date_stopped_idx (date_stopped);
alter table omrs_visit add index omrs_visit_type_idx (visit_type);
alter table omrs_visit add index omrs_visit_location_idx (location);
