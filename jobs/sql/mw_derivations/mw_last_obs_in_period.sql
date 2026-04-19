drop table if exists mw_last_obs_in_period;
create table mw_last_obs_in_period (
  patient_id   int not null,
  concept      varchar(255),
  last_obs_date date,
  encounter_type varchar(255),
  location     varchar(255),
  value_coded  varchar(255),
  value_date   date,
  value_numeric float,
  value_text   text,
  obs_group_id int
);

-- Most recent obs per patient per concept up to each selected period end date
insert into mw_last_obs_in_period
select
    o.patient_id,
    o.concept,
    o.obs_date as last_obs_date,
    o.encounter_type,
    o.location,
    o.value_coded,
    o.value_date,
    o.value_numeric,
    o.value_text,
    o.obs_group_id
from omrs_obs o
inner join (
    select
        o2.patient_id,
        o2.concept,
        max(o2.obs_date) as last_obs_date
    from omrs_obs o2
    CROSS join mw_selected_periods p
    where o2.concept in (select concept from mw_concepts_selected)
    and o2.obs_date <= p.end_date
    group by o2.patient_id, o2.concept
) latest on latest.patient_id = o.patient_id
        and latest.concept = o.concept
        and latest.last_obs_date = o.obs_date;
