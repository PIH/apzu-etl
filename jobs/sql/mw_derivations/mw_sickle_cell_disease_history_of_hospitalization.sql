-- Derivation script for mw_sickle_cell_disease_history_of_hospitalization
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-history-of-hospitalization.ktr

drop table if exists mw_sickle_cell_disease_history_of_hospitalization;
create table mw_sickle_cell_disease_history_of_hospitalization
(
    sickle_cell_disease_history_of_hospitalization int not null auto_increment,
    patient_id                                     int not null,
    visit_date                                     date,
    location                                       varchar(255),
    length_of_stay                                 int,
    reason_for_admission                           varchar(255),
    discharge_date                                 date,
    discharge_diagnosis                            varchar(255),
    discharge_medications                          varchar(255),
    primary key (sickle_cell_disease_history_of_hospitalization)
);

drop temporary table if exists temp_hospitalization_discharge_date;
create temporary table temp_hospitalization_discharge_date as select encounter_id, value_date from omrs_obs where concept = 'Hospitalization discharge date';
alter table temp_hospitalization_discharge_date add index temp_hospitalization_discharge_date_encounter_idx (encounter_id);

drop temporary table if exists temp_discharge_medications_text;
create temporary table temp_discharge_medications_text as select encounter_id, value_text from omrs_obs where concept = 'Discharge medications (text)';
alter table temp_discharge_medications_text add index temp_discharge_medications_text_encounter_idx (encounter_id);

drop temporary table if exists temp_discharge_diagnosis_text;
create temporary table temp_discharge_diagnosis_text as select encounter_id, value_text from omrs_obs where concept = 'Discharge diagnosis (text)';
alter table temp_discharge_diagnosis_text add index temp_discharge_diagnosis_text_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_admission_text;
create temporary table temp_reason_for_admission_text as select encounter_id, value_text from omrs_obs where concept = 'Reason for admission (text)';
alter table temp_reason_for_admission_text add index temp_reason_for_admission_text_encounter_idx (encounter_id);

insert into mw_sickle_cell_disease_history_of_hospitalization (patient_id, visit_date, location, discharge_date, discharge_medications, discharge_diagnosis, reason_for_admission)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(hospitalization_discharge_date.value_date) as discharge_date,
    max(discharge_medications_text.value_text) as discharge_medications,
    max(discharge_diagnosis_text.value_text) as discharge_diagnosis,
    max(reason_for_admission_text.value_text) as reason_for_admission
from omrs_encounter e
left join temp_hospitalization_discharge_date hospitalization_discharge_date on e.encounter_id = hospitalization_discharge_date.encounter_id
left join temp_discharge_medications_text discharge_medications_text on e.encounter_id = discharge_medications_text.encounter_id
left join temp_discharge_diagnosis_text discharge_diagnosis_text on e.encounter_id = discharge_diagnosis_text.encounter_id
left join temp_reason_for_admission_text reason_for_admission_text on e.encounter_id = reason_for_admission_text.encounter_id
where e.encounter_type in ('PDC_HOSPITALIZATION_HISTORY')
group by e.patient_id, e.encounter_date, e.location;