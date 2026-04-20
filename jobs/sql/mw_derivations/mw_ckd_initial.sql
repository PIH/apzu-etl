-- Derivation script for mw_ckd_initial
-- Generated from Pentaho transform: import-into-mw-ckd-initial.ktr

drop table if exists mw_ckd_initial;
create table mw_ckd_initial (
  ckd_initial_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  presumed_etiology_hypertension varchar(255) default null,
  presumed_etiology_diabetes varchar(255) default null,
  presumed_etiology_hiv varchar(255) default null,
  presumed_etiology_nephrotic varchar(255) default null,
  presumed_etiology_drugs varchar(255) default null,
  presumed_etiology_other varchar(255) default null,
  presumed_etiology_other_2 varchar(255) default null,
  presumed_etiology_unknown varchar(255) default null,
  presumed_etiology_diagnosis_date date default null,
  diagnosis_chf varchar(255) default null,
  diagnosis_date_chf date default null,
  diagnosis_hypertension varchar(255) default null,
  diagnosis_date_hypertension date default null,
  diagnosis_diabetes varchar(255) default null,
  diagnosis_date_diabetes date default null,
  diagnosis_other varchar(255) default null,
  diagnosis_date_other date default null,
  hiv_status varchar(255) default null,
  hiv_test_date date default null,
  art_start_date date default null,
  tb_status varchar(255) default null,
  tb_date date default null,
  history_of_dialysis varchar(255) default null,
  date_of_dialysis date default null,
  primary key (ckd_initial_visit_id)
);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_dialysis;
create temporary table temp_date_of_dialysis as select encounter_id, value_date from omrs_obs where concept = 'Date of dialysis';
alter table temp_date_of_dialysis add index temp_date_of_dialysis_encounter_idx (encounter_id);

drop temporary table if exists temp_chronic_care_diagnosis;
create temporary table temp_chronic_care_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Chronic care diagnosis';
alter table temp_chronic_care_diagnosis add index temp_chronic_care_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date from omrs_obs where concept = 'Diagnosis date';
alter table temp_diagnosis_date add index temp_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_dialysis;
create temporary table temp_history_of_dialysis as select encounter_id, value_text from omrs_obs where concept = 'History of dialysis';
alter table temp_history_of_dialysis add index temp_history_of_dialysis_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_date;
create temporary table temp_hiv_test_date as select encounter_id, value_date from omrs_obs where concept = 'HIV test date';
alter table temp_hiv_test_date add index temp_hiv_test_date_encounter_idx (encounter_id);

drop temporary table if exists temp_presumed_chronic_kidney_disease_etiology;
create temporary table temp_presumed_chronic_kidney_disease_etiology as select encounter_id, value_coded from omrs_obs where concept = 'Presumed chronic kidney disease etiology';
alter table temp_presumed_chronic_kidney_disease_etiology add index temp_presumed_chronic_kidney_disease_etiology_2 (encounter_id);

drop temporary table if exists temp_drugs;
create temporary table temp_drugs as select encounter_id, value_text from omrs_obs where concept = 'drugs';
alter table temp_drugs add index temp_drugs_encounter_idx (encounter_id);

drop temporary table if exists temp_tuberculosis_diagnosis_date;
create temporary table temp_tuberculosis_diagnosis_date as select encounter_id, value_date from omrs_obs where concept = 'Tuberculosis diagnosis date';
alter table temp_tuberculosis_diagnosis_date add index temp_tuberculosis_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from omrs_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

insert into mw_ckd_initial (patient_id, visit_date, location, art_start_date, date_of_dialysis, diagnosis_diabetes, diagnosis_hypertension, diagnosis_other, diagnosis_chf, diagnosis_date_chf, diagnosis_date_diabetes, diagnosis_date_hypertension, diagnosis_date_other, history_of_dialysis, hiv_status, hiv_test_date, presumed_etiology_diabetes, presumed_etiology_diagnosis_date, presumed_etiology_drugs, presumed_etiology_hiv, presumed_etiology_hypertension, presumed_etiology_nephrotic, presumed_etiology_other, presumed_etiology_other_2, presumed_etiology_unknown, tb_date, tb_status)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(date_of_dialysis.value_date) as date_of_dialysis,
    max(case when chronic_care_diagnosis.value_coded = 'Diabetes' then chronic_care_diagnosis.value_coded end) as diagnosis_diabetes,
    max(case when chronic_care_diagnosis.value_coded = 'Hypertension' then chronic_care_diagnosis.value_coded end) as diagnosis_hypertension,
    max(case when chronic_care_diagnosis.value_coded = 'Other non-coded' then chronic_care_diagnosis.value_coded end) as diagnosis_other,
    max(case when chronic_care_diagnosis.value_coded = 'Heart failure' then chronic_care_diagnosis.value_coded end) as diagnosis_chf,
    max(diagnosis_date.value_date) as diagnosis_date_chf,
    max(diagnosis_date.value_date) as diagnosis_date_diabetes,
    max(diagnosis_date.value_date) as diagnosis_date_hypertension,
    max(diagnosis_date.value_date) as diagnosis_date_other,
    max(history_of_dialysis.value_text) as history_of_dialysis,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(case when presumed_chronic_kidney_disease_etiology.value_coded = 'Diabetes' then presumed_chronic_kidney_disease_etiology.value_coded end) as presumed_etiology_diabetes,
    max(diagnosis_date.value_date) as presumed_etiology_diagnosis_date,
    max(presumed_chronic_kidney_disease_etiology.value_coded) as presumed_etiology_drugs,
    max(case when presumed_chronic_kidney_disease_etiology.value_coded = 'Human immunodeficiency virus' then presumed_chronic_kidney_disease_etiology.value_coded end) as presumed_etiology_hiv,
    max(case when presumed_chronic_kidney_disease_etiology.value_coded = 'Hypertension' then presumed_chronic_kidney_disease_etiology.value_coded end) as presumed_etiology_hypertension,
    max(case when presumed_chronic_kidney_disease_etiology.value_coded = 'Nephropathy' then presumed_chronic_kidney_disease_etiology.value_coded end) as presumed_etiology_nephrotic,
    max(drugs.value_text) as presumed_etiology_other,
    max(case when presumed_chronic_kidney_disease_etiology.value_coded = 'Other' then presumed_chronic_kidney_disease_etiology.value_coded end) as presumed_etiology_other_2,
    max(case when presumed_chronic_kidney_disease_etiology.value_coded = 'Unknown cause' then presumed_chronic_kidney_disease_etiology.value_coded end) as presumed_etiology_unknown,
    max(tuberculosis_diagnosis_date.value_date) as tb_date,
    max(tb_status.value_coded) as tb_status
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_date_of_dialysis date_of_dialysis on e.encounter_id = date_of_dialysis.encounter_id
left join temp_chronic_care_diagnosis chronic_care_diagnosis on e.encounter_id = chronic_care_diagnosis.encounter_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_history_of_dialysis history_of_dialysis on e.encounter_id = history_of_dialysis.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_presumed_chronic_kidney_disease_etiology presumed_chronic_kidney_disease_etiology on e.encounter_id = presumed_chronic_kidney_disease_etiology.encounter_id
left join temp_drugs drugs on e.encounter_id = drugs.encounter_id
left join temp_tuberculosis_diagnosis_date tuberculosis_diagnosis_date on e.encounter_id = tuberculosis_diagnosis_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
where e.encounter_type in ('CKD_INITIAL')
group by e.patient_id, e.encounter_date, e.location;