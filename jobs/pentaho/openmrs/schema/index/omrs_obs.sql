alter table omrs_obs add index omrs_obs_id_idx (obs_id);
alter table omrs_obs add index omrs_obs_patient_idx (patient_id);
alter table omrs_obs add index omrs_obs_date_idx (obs_date);
alter table omrs_obs add index omrs_obs_time_idx (obs_time);
alter table omrs_obs add index omrs_obs_concept_idx (concept);
alter table omrs_obs add index omrs_obs_encounter_type_idx (encounter_type);
alter table omrs_obs add index omrs_obs_location_idx (location);
