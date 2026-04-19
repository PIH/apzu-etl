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

insert into mw_ckd_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date antiretrovirals started' then o.value_date end) as art_start_date,
    max(case when o.concept = 'Date of dialysis' then o.value_date end) as date_of_dialysis,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Diabetes' then o.value_coded end) as diagnosis_diabetes,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Hypertension' then o.value_coded end) as diagnosis_hypertension,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Other non-coded' then o.value_coded end) as diagnosis_other,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Heart failure' then o.value_coded end) as diagnosis_chf,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_chf,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_diabetes,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_hypertension,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_other,
    max(case when o.concept = 'History of dialysis' then o.value_text end) as history_of_dialysis,
    max(case when o.concept = 'HIV status' then o.value_coded end) as hiv_status,
    max(case when o.concept = 'HIV test date' then o.value_date end) as hiv_test_date,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' and o.value_coded = 'Diabetes' then o.value_coded end) as presumed_etiology_diabetes,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as presumed_etiology_diagnosis_date,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' then o.value_coded end) as presumed_etiology_drugs,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' and o.value_coded = 'Human immunodeficiency virus' then o.value_coded end) as presumed_etiology_hiv,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' and o.value_coded = 'Hypertension' then o.value_coded end) as presumed_etiology_hypertension,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' and o.value_coded = 'Nephropathy' then o.value_coded end) as presumed_etiology_nephrotic,
    max(case when o.concept = 'drugs' then o.value_text end) as presumed_etiology_other,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' and o.value_coded = 'Other' then o.value_coded end) as presumed_etiology_other_2,
    max(case when o.concept = 'Presumed chronic kidney disease etiology' and o.value_coded = 'Unknown cause' then o.value_coded end) as presumed_etiology_unknown,
    max(case when o.concept = 'Tuberculosis diagnosis date' then o.value_date end) as tb_date,
    max(case when o.concept = 'TB status' then o.value_coded end) as tb_status
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('CKD_INITIAL')
group by e.patient_id, e.encounter_date, e.location;