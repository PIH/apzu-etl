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

insert into mw_poc_adherence_counseling
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Adherence counseling (coded)' then o.value_coded end) as adherence_counselling,
    max(case when o.concept = 'Adherence session number' then o.value_coded end) as adherence_session_number,
    max(case when o.concept = 'Medication Adherence percent' then o.value_numeric end) as medication_adherence_percent,
    max(case when o.concept = 'Name of support provider' then o.value_text end) as name_of_support_provider,
    max(case when o.concept = 'Number of missed medication doses in past 7 days' then o.value_numeric end) as number_of_missed_medication_doses_in_past_week,
    max(case when o.concept = 'Viral load counseling' then o.value_coded end) as viral_load_counseling
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('Adherence Counseling')
group by e.patient_id, e.encounter_date, e.location;