-- Derivation script for mw_diabetes_hypertension_initial
-- Generated from Pentaho transform: import-into-mw-diabetes-hypertension-initial.ktr

drop table if exists mw_diabetes_hypertension_initial;
create table mw_diabetes_hypertension_initial
(
    initial_visit_id                 int not null auto_increment,
    patient_id                       int not null,
    visit_date                       date,
    location                         varchar(255),
    diagnosis_type_1_diabetes        varchar(255),
    diagnosis_type_1_diabetes_date   date,
    diagnosis_type_2_diabetes        varchar(255),
    diagnosis_type_2_diabetes_date   date,
    diagnosis_hypertension           varchar(255),
    diagnosis_hypertension_date      date,
    hiv_status                       varchar(255),
    hiv_test_date                    date,
    art_start_date                   date,
    cardiovascular_disease           varchar(255),
    cardiovascular_disease_date      date,
    retinopathy                      varchar(255),
    retinopathy_date                 date,
    renal_disease                    varchar(255),
    renal_disease_date               date,
    family_history_diabetes_mellitus varchar(255),
    family_history_hypertension      varchar(255),
    tb_status                        varchar(255),
    tb_status_year                   varchar(255),
    stroke_and_tia                   varchar(255),
    stroke_and_tia_date              date,
    peripheral_vascular_disease      varchar(255),
    peripheral_vascular_disease_date date,
    neuropathy                       varchar(255),
    neuropathy_date                  date,
    sexual_disorder                  varchar(255),
    sexual_disorder_date             date,
    primary key (initial_visit_id)
);

drop temporary table if exists temp_dhi_obs;
create temporary table temp_dhi_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'DIABETES HYPERTENSION INITIAL VISIT';
alter table temp_dhi_obs add index temp_dhi_obs_concept_idx (concept);
alter table temp_dhi_obs add index temp_dhi_obs_encounter_idx (encounter_id);
alter table temp_dhi_obs add index temp_dhi_obs_group_idx (obs_group_id);

drop temporary table if exists temp_diagnosis;
create temporary table temp_diagnosis (
    encounter_id int,
    obs_group_id int,
    diagnosis varchar(255),
    diagnosis_date date
);
alter table temp_diagnosis add index temp_diagnosis_diagnosis_idx (diagnosis);
alter table temp_diagnosis add index temp_diagnosis_obs_group_idx (obs_group_id);

insert into temp_diagnosis (encounter_id, obs_group_id, diagnosis)
select encounter_id, obs_group_id, value_coded from temp_dhi_obs where value_coded in (
    'Cardiovascular disease', 'Hypertension', 'Neuropathy', 'Peripheral vascular disease', 'Renal disease',
    'Retinopathy', 'Sexual Disorder', 'Stroke and Transient Ischemic Attack', 'Type 1 diabetes', 'Type 2 diabetes'
);
update temp_diagnosis d
    inner join temp_dhi_obs o on d.obs_group_id = o.obs_group_id and o.concept = 'Diagnosis date'
set diagnosis_date = o.value_date;

drop temporary table if exists temp_diagnosis_values;
create temporary table temp_diagnosis_values as
select
    encounter_id,
    max(case when diagnosis = 'Cardiovascular disease'              then 1 else 0 end) as cardiovascular_disease,
    min(case when diagnosis = 'Cardiovascular disease'              then diagnosis_date end) as cardiovascular_disease_date,
    max(case when diagnosis = 'Hypertension'                        then 1 else 0 end) as diagnosis_hypertension,
    min(case when diagnosis = 'Hypertension'                        then diagnosis_date end) as diagnosis_hypertension_date,
    max(case when diagnosis = 'Neuropathy'                          then 1 else 0 end) as neuropathy,
    min(case when diagnosis = 'Neuropathy'                          then diagnosis_date end) as neuropathy_date,
    max(case when diagnosis = 'Peripheral vascular disease'         then 1 else 0 end) as peripheral_vascular_disease,
    min(case when diagnosis = 'Peripheral vascular disease'         then diagnosis_date end) as peripheral_vascular_disease_date,
    max(case when diagnosis = 'Renal disease'                       then 1 else 0 end) as renal_disease,
    min(case when diagnosis = 'Renal disease'                       then diagnosis_date end) as renal_disease_date,
    max(case when diagnosis = 'Retinopathy'                         then 1 else 0 end) as retinopathy,
    min(case when diagnosis = 'Retinopathy'                         then diagnosis_date end) as retinopathy_date,
    max(case when diagnosis = 'Sexual Disorder'                     then 1 else 0 end) as sexual_disorder,
    min(case when diagnosis = 'Sexual Disorder'                     then diagnosis_date end) as sexual_disorder_date,
    max(case when diagnosis = 'Stroke and Transient Ischemic Attack' then 1 else 0 end) as stroke_and_tia,
    min(case when diagnosis = 'Stroke and Transient Ischemic Attack' then diagnosis_date end) as stroke_and_tia_date,
    max(case when diagnosis = 'Type 1 diabetes'                     then 1 else 0 end) as diagnosis_type_1_diabetes,
    min(case when diagnosis = 'Type 1 diabetes'                     then diagnosis_date end) as diagnosis_type_1_diabetes_date,
    max(case when diagnosis = 'Type 2 diabetes'                     then 1 else 0 end) as diagnosis_type_2_diabetes,
    min(case when diagnosis = 'Type 2 diabetes'                     then diagnosis_date end) as diagnosis_type_2_diabetes_date
from temp_diagnosis
group by encounter_id;
alter table temp_diagnosis_values add index temp_diagnosis_values_encounter_idx (encounter_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Date antiretrovirals started'          then value_date    end) as art_start_date,
    max(case when concept = 'Family History of Diabetes Mellitus'   then value_coded   end) as family_history_diabetes_mellitus,
    max(case when concept = 'Family history of hypertension'        then value_coded   end) as family_history_hypertension,
    max(case when concept = 'HIV status'                            then value_coded   end) as hiv_status,
    max(case when concept = 'HIV test date'                         then value_date    end) as hiv_test_date,
    max(case when concept = 'TB status'                             then value_coded   end) as tb_status,
    max(case when concept = 'Year of Tuberculosis diagnosis'        then value_numeric end) as tb_status_year
from temp_dhi_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_diabetes_hypertension_initial (
    patient_id, visit_date, location, art_start_date, cardiovascular_disease, cardiovascular_disease_date, family_history_diabetes_mellitus,
    family_history_hypertension, hiv_status, hiv_test_date, diagnosis_hypertension, diagnosis_hypertension_date, neuropathy, neuropathy_date,
    peripheral_vascular_disease, peripheral_vascular_disease_date, renal_disease, renal_disease_date, retinopathy, retinopathy_date,
    sexual_disorder, sexual_disorder_date, stroke_and_tia, stroke_and_tia_date, tb_status, tb_status_year,
    diagnosis_type_1_diabetes, diagnosis_type_1_diabetes_date, diagnosis_type_2_diabetes, diagnosis_type_2_diabetes_date)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.art_start_date,
    dv.cardiovascular_disease,
    dv.cardiovascular_disease_date,
    sv.family_history_diabetes_mellitus,
    sv.family_history_hypertension,
    sv.hiv_status,
    sv.hiv_test_date,
    dv.diagnosis_hypertension,
    dv.diagnosis_hypertension_date,
    dv.neuropathy,
    dv.neuropathy_date,
    dv.peripheral_vascular_disease,
    dv.peripheral_vascular_disease_date,
    dv.renal_disease,
    dv.renal_disease_date,
    dv.retinopathy,
    dv.retinopathy_date,
    dv.sexual_disorder,
    dv.sexual_disorder_date,
    dv.stroke_and_tia,
    dv.stroke_and_tia_date,
    sv.tb_status,
    sv.tb_status_year,
    dv.diagnosis_type_1_diabetes,
    dv.diagnosis_type_1_diabetes_date,
    dv.diagnosis_type_2_diabetes,
    dv.diagnosis_type_2_diabetes_date
from omrs_encounter e
left join temp_diagnosis_values dv on dv.encounter_id = e.encounter_id
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('DIABETES HYPERTENSION INITIAL VISIT')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_dhi_obs;
drop temporary table if exists temp_diagnosis;
drop temporary table if exists temp_diagnosis_values;
drop temporary table if exists temp_single_values;
