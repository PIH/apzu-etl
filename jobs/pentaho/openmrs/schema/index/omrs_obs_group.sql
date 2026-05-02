alter table omrs_obs_group add index omrs_bos_group_id_idx (obs_group_id);
alter table omrs_obs_group add index omrs_obs_group_patient_idx (patient_id);
alter table omrs_obs_group add index omrs_obs_group_date_idx (obs_group_date);
alter table omrs_obs_group add index omrs_obs_group_time_idx (obs_group_time);
alter table omrs_obs_group add index omrs_obs_group_concept_idx (concept);
alter table omrs_obs_group add index omrs_obs_group_encounter_type_idx (encounter_type);
alter table omrs_obs_group add index omrs_obs_group_location_idx (location);
