create table omrs_encounter_provider (
  encounter_provider_id int not null,
  uuid char(38) not null,
  encounter_id int not null,
  encounter_uuid char(38) not null,
  provider varchar(255),
  provider_role varchar(255)
);