-- Derivation script for mw_teen_club_followup
-- Generated from Pentaho transform: import-into-mw-teen-club-followup.ktr

drop table if exists mw_teen_club_followup;
create table mw_teen_club_followup (
    teen_club_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    height decimal(10 , 2 ),
    weight decimal(10 , 2 ),
    muac_bmi decimal(10 , 2 ),
    tb_status varchar(255),
    tb_screening_outcome varchar(255),
    sputum_collected varchar(255),
    nutrition_screening_for_normal_muac varchar(255),
    nutrition_referred varchar(255),
    mental_health_screened varchar(255),
    adolescent_referred varchar(255),
    adolescent_registered varchar(255),
    sti_screening_outcome varchar(255),
    referred_to_sti_clinic varchar(255),
    hospitalized varchar(255),
    next_appointment date,
    primary key (teen_club_followup_visit_id)
);

insert into mw_teen_club_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Sample collected' then o.value_coded end) as hospitalized,
    max(case when o.concept = 'Body mass index, measured' then o.value_numeric end) as muac_bmi,
    max(case when o.concept = 'Normal nutrition screening for MUAC' then o.value_coded end) as nutrition_screening_for_normal_muac,
    max(case when o.concept = 'Nutrition referral' then o.value_coded end) as nutrition_referred,
    max(case when o.concept = 'STI referral' then o.value_coded end) as referred_to_sti_clinic,
    max(case when o.concept = 'STI screening outcome' then o.value_coded end) as sti_screening_outcome,
    max(case when o.concept = 'Sample collected' then o.value_coded end) as sputum_collected,
    max(case when o.concept = 'TB screening outcome' then o.value_coded end) as tb_screening_outcome,
    max(case when o.concept = 'TB status' then o.value_coded end) as tb_status,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight,
    max(case when o.concept = 'If yes,Adolescent referred?' then o.value_coded end) as adolescent_referred,
    max(case when o.concept = 'If yes,Adolescent registered?' then o.value_coded end) as adolescent_registered,
    max(case when o.concept = 'Mental health screened' then o.value_coded end) as mental_health_screened
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('TEEN_CLUB_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;