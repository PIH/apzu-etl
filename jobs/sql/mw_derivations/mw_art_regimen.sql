drop table if exists mw_art_regimen;
create table mw_art_regimen (
  patient_id           int not null,
  regimen              varchar(255),
  regimen_init_date    date,
  num_of_prev_regimens int,
  regimen_end_date     date,
  line                 varchar(100)
);

-- First ART regimen (Malawi Antiretroviral drugs change 1)
insert into mw_art_regimen (patient_id, regimen, regimen_init_date, num_of_prev_regimens)
select
    o.patient_id,
    o.value_coded,
    initdate.value_date as regimen_init_date,
    null as num_of_prev_regimens
from omrs_obs o
left join (
    select encounter_id, value_date
    from omrs_obs
    where concept = 'Start date 1st line ARV'
) initdate on initdate.encounter_id = o.encounter_id
where o.concept = 'Malawi Antiretroviral drugs change 1';

-- Second ART regimen (Malawi Antiretroviral drugs change 2)
insert into mw_art_regimen (patient_id, regimen, regimen_init_date, num_of_prev_regimens)
select
    o.patient_id,
    o.value_coded,
    initdate.value_date as regimen_init_date,
    null as num_of_prev_regimens
from omrs_obs o
left join (
    select encounter_id, value_date
    from omrs_obs
    where concept = 'Date of starting alternative 1st line ARV regimen'
) initdate on initdate.encounter_id = o.encounter_id
where o.concept = 'Malawi Antiretroviral drugs change 2';

-- Third ART regimen (Malawi Antiretroviral drugs change 3)
insert into mw_art_regimen (patient_id, regimen, regimen_init_date, num_of_prev_regimens)
select
    o.patient_id,
    o.value_coded,
    initdate.value_date as regimen_init_date,
    null as num_of_prev_regimens
from omrs_obs o
left join (
    select encounter_id, value_date
    from omrs_obs
    where concept = 'Date of starting 2nd line ARV regimen'
) initdate on initdate.encounter_id = o.encounter_id
where o.concept = 'Malawi Antiretroviral drugs change 3';
