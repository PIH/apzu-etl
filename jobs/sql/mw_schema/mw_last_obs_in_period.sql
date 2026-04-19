create table mw_last_obs_in_period (
	patient_id int,
    concept varchar(255),
    end_date date,
    last_obs_date date,
    encounter_type varchar(255),
    location varchar(255),
    value_coded varchar(255),
    value_date date,
    value_numeric decimal(10,2) default null,
    value_text text,
    obs_group_id int
);