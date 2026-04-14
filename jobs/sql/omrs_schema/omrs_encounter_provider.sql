CREATE TABLE omrs_encounter_provider (
  encounter_provider_id INT not null,
  uuid CHAR(38) not null,
  encounter_id INT not null,
  encounter_uuid CHAR(38) not null,
  provider VARCHAR(255),
  provider_role VARCHAR(255)
);
