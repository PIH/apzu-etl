-- Derivation script for mw_poc_adherence_counseling
-- Generated from Pentaho transform: import-into-mw-poc-adherence-counseling.ktr

drop table if exists mw_poc_adherence_counseling;
create table mw_poc_adherence_counseling (
    poc_adherence_counseling_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    adherence_session_number varchar(255),
    name_of_support_provider varchar(255),
    number_of_missed_medication_doses_in_past_week varchar(255),
    viral_load_counseling varchar(255),
    medication_adherence_percent varchar(255),
    adherence_counselling varchar(255),
    primary key (poc_adherence_counseling_visit_id)
);

drop temporary table if exists temp_adherence_counseling_coded;
create temporary table temp_adherence_counseling_coded as select encounter_id, value_coded from omrs_obs where concept = 'Adherence counseling (coded)';
alter table temp_adherence_counseling_coded add index temp_adherence_counseling_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_adherence_session_number;
create temporary table temp_adherence_session_number as select encounter_id, value_coded from omrs_obs where concept = 'Adherence session number';
alter table temp_adherence_session_number add index temp_adherence_session_number_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_adherence_percent;
create temporary table temp_medication_adherence_percent as select encounter_id, value_numeric from omrs_obs where concept = 'Medication Adherence percent';
alter table temp_medication_adherence_percent add index temp_medication_adherence_percent_encounter_idx (encounter_id);

drop temporary table if exists temp_name_of_support_provider;
create temporary table temp_name_of_support_provider as select encounter_id, value_text from omrs_obs where concept = 'Name of support provider';
alter table temp_name_of_support_provider add index temp_name_of_support_provider_encounter_idx (encounter_id);

drop temporary table if exists temp_number_missed_medication_doses_past_7_days;
create temporary table temp_number_missed_medication_doses_past_7_days as select encounter_id, value_numeric from omrs_obs where concept = 'Number of missed medication doses in past 7 days';
alter table temp_number_missed_medication_doses_past_7_days add index temp_number_missed_medication_doses_past_7_days_2 (encounter_id);

drop temporary table if exists temp_viral_load_counseling;
create temporary table temp_viral_load_counseling as select encounter_id, value_coded from omrs_obs where concept = 'Viral load counseling';
alter table temp_viral_load_counseling add index temp_viral_load_counseling_encounter_idx (encounter_id);

insert into mw_poc_adherence_counseling (patient_id, visit_date, location, adherence_counselling, adherence_session_number, medication_adherence_percent, name_of_support_provider, number_of_missed_medication_doses_in_past_week, viral_load_counseling, creator)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(adherence_counseling_coded.value_coded) as adherence_counselling,
    max(adherence_session_number.value_coded) as adherence_session_number,
    max(medication_adherence_percent.value_numeric) as medication_adherence_percent,
    max(name_of_support_provider.value_text) as name_of_support_provider,
    max(number_of_missed_medication_doses_in_past_7_days.value_numeric) as number_of_missed_medication_doses_in_past_week,
    max(viral_load_counseling.value_coded) as viral_load_counseling,
    max(e.created_by) as creator
from omrs_encounter e
left join temp_adherence_counseling_coded adherence_counseling_coded on e.encounter_id = adherence_counseling_coded.encounter_id
left join temp_adherence_session_number adherence_session_number on e.encounter_id = adherence_session_number.encounter_id
left join temp_medication_adherence_percent medication_adherence_percent on e.encounter_id = medication_adherence_percent.encounter_id
left join temp_name_of_support_provider name_of_support_provider on e.encounter_id = name_of_support_provider.encounter_id
left join temp_number_missed_medication_doses_past_7_days number_of_missed_medication_doses_in_past_7_days on e.encounter_id = number_of_missed_medication_doses_in_past_7_days.encounter_id
left join temp_viral_load_counseling viral_load_counseling on e.encounter_id = viral_load_counseling.encounter_id
where e.encounter_type in ('Adherence Counseling')
group by e.patient_id, e.encounter_date, e.location;