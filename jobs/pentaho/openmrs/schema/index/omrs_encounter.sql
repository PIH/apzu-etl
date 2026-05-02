alter table omrs_encounter add index omrs_encounter_id_idx (encounter_id);
alter table omrs_encounter add index omrs_encounter_patient_idx (patient_id);
alter table omrs_encounter add index omrs_encounter_date_idx (encounter_date);
alter table omrs_encounter add index omrs_encounter_time_idx (encounter_time);
alter table omrs_encounter add index omrs_encounter_type_idx (encounter_type);
alter table omrs_encounter add index omrs_encounter_form_idx (form);
alter table omrs_encounter add index omrs_encounter_location_idx (location);
