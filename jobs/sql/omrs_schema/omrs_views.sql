create or replace view omrs_encounter_2018 as
select * from omrs_encounter where encounter_date >= '2018-01-01' and encounter_date < '2019-01-01';

create or replace view omrs_obs_2018 as
select * from omrs_obs where obs_date >= '2018-01-01' and obs_date < '2019-01-01';

create or replace view omrs_encounter_2019 as
select * from omrs_encounter where encounter_date >= '2019-01-01' and encounter_date < '2020-01-01';

create or replace view omrs_obs_2019 as
select * from omrs_obs where obs_date >= '2019-01-01' and obs_date < '2020-01-01';

create or replace view omrs_encounter_2020 as
select * from omrs_encounter where encounter_date >= '2020-01-01' and encounter_date < '2021-01-01';

create or replace view omrs_obs_2020 as
select * from omrs_obs where obs_date >= '2020-01-01' and obs_date < '2021-01-01';
