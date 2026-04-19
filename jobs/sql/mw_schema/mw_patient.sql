
create table mw_patient (
  patient_id            int not null,
  identifier            varchar(50),
  first_name            varchar(50),
  last_name             varchar(50),
  gender                char(1),
  birthdate             date,
  birthdate_estimated   boolean,
  phone_number          varchar(50),
  district              varchar(255),
  traditional_authority varchar(255),
  village               varchar(255),
  chw                   varchar(100),
  dead                  boolean,
  death_date            date,
  patient_uuid	 	 char(38)
);
alter table mw_patient add index mw_patient_id_idx (patient_id);
