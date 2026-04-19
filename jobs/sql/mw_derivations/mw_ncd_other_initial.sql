-- Derivation script for mw_ncd_other_initial
-- Generated from Pentaho transform: import-into-mw-ncd-other-initial.ktr

drop table if exists mw_ncd_other_initial;
create table mw_ncd_other_initial (
  ncd_other_initial_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  diagnosis_rheumatoid_arthritis varchar(255) default null,
  diagnosis_date_rheumatoid_arthritis date default null,
  diagnosis_cirrhosis varchar(255) default null,
  diagnosis_date_cirrhosis date default null,
  diagnosis_dvt_or_pe varchar(255) default null,
  diagnosis_date_dvt_or_pe date default null,
  diagnosis_sickle_cell_disease varchar(255) default null,
  diagnosis_other varchar(255) default null,
  diagnosis_date_other date default null,
  hiv_status varchar(255) default null,
  hiv_test_date date default null,
  art_start_date date default null,
  tb_status varchar(255) default null,
  tb_start_date date default null,
  comorbidities_hypertension varchar(255) default null,
  comorbidities_diabetes varchar(255) default null,
  comorbidities_chronic_kidney_disease varchar(255) default null,
  comorbidities_other varchar(255) default null,
  echo_test_result varchar(255) default null,
  echo_test_date date default null,
  ecg_test_result varchar(255) default null,
  ecg_test_date date default null,
  primary key (ncd_other_initial_visit_id)
);

insert into mw_ncd_other_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date antiretrovirals started' then o.value_date end) as art_start_date,
    max(case when o.concept = 'Current opportunistic infection or comorbidity, confirmed or presumed' and o.value_coded = 'Chronic kidney disease' then o.value_coded end) as comorbidities_chronic_kidney_disease,
    max(case when o.concept = 'Current opportunistic infection or comorbidity, confirmed or presumed' and o.value_coded = 'Diabetes' then o.value_coded end) as comorbidities_diabetes,
    max(case when o.concept = 'Current opportunistic infection or comorbidity, confirmed or presumed' and o.value_coded = 'Hypertension' then o.value_coded end) as comorbidities_hypertension,
    max(case when o.concept = 'Other diagnosis' then o.value_text end) as comorbidities_other,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Restrictive cardiomyopathy' then o.value_coded end) as diagnosis_cirrhosis,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_other,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_cirrhosis,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_dvt_or_pe,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_rheumatoid_arthritis,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date_sickle_cell_disease,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Deep vein thrombosis' then o.value_coded end) as diagnosis_dvt_or_pe,
    max(case when o.concept = 'Other diagnosis' then o.value_text end) as diagnosis_other,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Rheumatoid arthritis' then o.value_coded end) as diagnosis_rheumatoid_arthritis,
    max(case when o.concept = 'Chronic care diagnosis' and o.value_coded = 'Sickle cell disease' then o.value_coded end) as diagnosis_sickle_cell_disease,
    max(case when o.concept = 'Date of general test' then o.value_date end) as ecg_test_date,
    max(case when o.concept = 'Electrocardiogram diagnosis' then o.value_coded end) as ecg_test_result,
    max(case when o.concept = 'Date of general test' then o.value_date end) as echo_test_date,
    max(case when o.concept = 'ECHO imaging result' then o.value_text end) as echo_test_result,
    max(case when o.concept = 'HIV status' then o.value_coded end) as hiv_status,
    max(case when o.concept = 'HIV test date' then o.value_date end) as hiv_test_date,
    max(case when o.concept = 'Tuberculosis diagnosis date' then o.value_date end) as tb_start_date,
    max(case when o.concept = 'TB status' then o.value_coded end) as tb_status
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('NCD_OTHER_INITIAL')
group by e.patient_id, e.encounter_date, e.location;