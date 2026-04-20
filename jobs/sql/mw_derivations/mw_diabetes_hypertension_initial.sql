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

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date, obs_group_id from omrs_obs where concept = 'Diagnosis date';
alter table temp_diagnosis_date add index temp_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_family_history_of_diabetes_mellitus;
create temporary table temp_family_history_of_diabetes_mellitus as select encounter_id, value_coded from omrs_obs where concept = 'Family History of Diabetes Mellitus';
alter table temp_family_history_of_diabetes_mellitus add index temp_family_history_diabetes_mellitus_encounter (encounter_id);

drop temporary table if exists temp_family_history_of_hypertension;
create temporary table temp_family_history_of_hypertension as select encounter_id, value_coded from omrs_obs where concept = 'Family history of hypertension';
alter table temp_family_history_of_hypertension add index temp_family_history_of_hypertension_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_date;
create temporary table temp_hiv_test_date as select encounter_id, value_date from omrs_obs where concept = 'HIV test date';
alter table temp_hiv_test_date add index temp_hiv_test_date_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_status;
create temporary table temp_tb_status as select encounter_id, value_coded from omrs_obs where concept = 'TB status';
alter table temp_tb_status add index temp_tb_status_encounter_idx (encounter_id);

drop temporary table if exists temp_year_of_tuberculosis_diagnosis;
create temporary table temp_year_of_tuberculosis_diagnosis as select encounter_id, value_numeric from omrs_obs where concept = 'Year of Tuberculosis diagnosis';
alter table temp_year_of_tuberculosis_diagnosis add index temp_year_of_tuberculosis_diagnosis_encounter_idx (encounter_id);

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
select encounter_id, obs_group_id, value_coded from omrs_obs where value_coded in (
    'Cardiovascular disease', 'Hypertension', 'Neuropathy', 'Peripheral vascular disease', 'Renal disease',
    'Retinopathy', 'Sexual Disorder', 'Stroke and Transient Ischemic Attack', 'Type 1 diabetes', 'Type 2 diabetes'
);
update temp_diagnosis d
    inner join omrs_obs o on d.obs_group_id = o.obs_group_id and o.concept = 'Diagnosis date'
set diagnosis_date = o.value_date;

drop temporary table if exists temp_cardiovascular_disease;
create temporary table temp_cardiovascular_disease as select * from temp_diagnosis where diagnosis = 'Cardiovascular disease';
alter table temp_cardiovascular_disease add index temp_cardiovascular_disease_encounter_idx (encounter_id);

drop temporary table if exists temp_hypertension;
create temporary table temp_hypertension as select * from temp_diagnosis where diagnosis = 'Hypertension';
alter table temp_hypertension add index temp_hypertension_encounter_idx (encounter_id);

drop temporary table if exists temp_neuropathy;
create temporary table temp_neuropathy as select * from temp_diagnosis where diagnosis = 'Neuropathy';
alter table temp_neuropathy add index temp_neuropathy_encounter_idx (encounter_id);

drop temporary table if exists temp_pvd;
create temporary table temp_pvd as select * from temp_diagnosis where diagnosis = 'Peripheral vascular disease';
alter table temp_pvd add index temp_pvd_encounter_idx (encounter_id);

drop temporary table if exists temp_renal_disease;
create temporary table temp_renal_disease as select * from temp_diagnosis where diagnosis = 'Renal disease';
alter table temp_renal_disease add index temp_renal_disease_encounter_idx (encounter_id);

drop temporary table if exists temp_retinopathy;
create temporary table temp_retinopathy as select * from temp_diagnosis where diagnosis = 'Retinopathy';
alter table temp_retinopathy add index temp_retinopathy_encounter_idx (encounter_id);

drop temporary table if exists temp_sexual_disorder;
create temporary table temp_sexual_disorder as select * from temp_diagnosis where diagnosis = 'Sexual Disorder';
alter table temp_sexual_disorder add index temp_sexual_disorder_encounter_idx (encounter_id);

drop temporary table if exists temp_stroke;
create temporary table temp_stroke as select * from temp_diagnosis where diagnosis = 'Stroke and Transient Ischemic Attack';
alter table temp_stroke add index temp_stroke_encounter_idx (encounter_id);

drop temporary table if exists temp_t1_diabetes;
create temporary table temp_t1_diabetes as select * from temp_diagnosis where diagnosis = 'Type 1 diabetes';
alter table temp_t1_diabetes add index temp_t1_diabetes_encounter_idx (encounter_id);

drop temporary table if exists temp_t2_diabetes;
create temporary table temp_t2_diabetes as select * from temp_diagnosis where diagnosis = 'Type 2 diabetes';
alter table temp_t2_diabetes add index temp_t2_diabetes_encounter_idx (encounter_id);

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
    max(date_antiretrovirals_started.value_date) as art_start_date,
    count(temp_cardiovascular_disease.diagnosis > 0) as cardiovascular_disease,
    min(temp_cardiovascular_disease.diagnosis_date) as cardiovascular_disease_date,
    max(family_history_of_diabetes_mellitus.value_coded) as family_history_diabetes_mellitus,
    max(family_history_of_hypertension.value_coded) as family_history_hypertension,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    count(temp_hypertension.diagnosis > 0) as diagnosis_hypertension,
    min(temp_hypertension.diagnosis_date) as diagnosis_hypertension_date,
    count(temp_neuropathy.diagnosis > 0) as neuropathy,
    min(temp_neuropathy.diagnosis_date) as neuropathy_date,
    count(temp_pvd.diagnosis > 0) as peripheral_vascular_disease,
    min(temp_pvd.diagnosis_date) as peripheral_vascular_disease_date,
    count(temp_renal_disease.diagnosis > 0) as diagnosis_renal_disease,
    min(temp_renal_disease.diagnosis_date) as diagnosis_renal_disease_date,
    count(temp_retinopathy.diagnosis > 0) as diagnosis_retinopathy,
    min(temp_retinopathy.diagnosis_date) as diagnosis_retinopathy_date,
    count(temp_sexual_disorder.diagnosis > 0) as diagnosis_sexual_disorder,
    min(temp_sexual_disorder.diagnosis_date) as diagnosis_sexual_disorder_date,
    count(temp_stroke.diagnosis > 0) as diagnosis_stroke,
    min(temp_stroke.diagnosis_date) as diagnosis_stroke_date,
    max(tb_status.value_coded) as tb_status,
    max(year_of_tuberculosis_diagnosis.value_numeric) as tb_status_year,
    count(temp_t1_diabetes.diagnosis > 0) as diagnosis_t1_diabetes,
    min(temp_t1_diabetes.diagnosis_date) as diagnosis_t1_diabetes_date,
    count(temp_t2_diabetes.diagnosis > 0) as diagnosis_t2_diabetes,
    min(temp_t2_diabetes.diagnosis_date) as diagnosis_t2_diabetes_date
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_family_history_of_diabetes_mellitus family_history_of_diabetes_mellitus on e.encounter_id = family_history_of_diabetes_mellitus.encounter_id
left join temp_family_history_of_hypertension family_history_of_hypertension on e.encounter_id = family_history_of_hypertension.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_tb_status tb_status on e.encounter_id = tb_status.encounter_id
left join temp_year_of_tuberculosis_diagnosis year_of_tuberculosis_diagnosis on e.encounter_id = year_of_tuberculosis_diagnosis.encounter_id
left join temp_cardiovascular_disease on temp_cardiovascular_disease.encounter_id = e.encounter_id
left join temp_hypertension on temp_hypertension.encounter_id = e.encounter_id
left join temp_neuropathy on temp_neuropathy.encounter_id = e.encounter_id
left join temp_pvd on temp_pvd.encounter_id = e.encounter_id
left join temp_renal_disease on temp_renal_disease.encounter_id = e.encounter_id
left join temp_retinopathy on temp_retinopathy.encounter_id = e.encounter_id
left join temp_sexual_disorder on temp_sexual_disorder.encounter_id = e.encounter_id
left join temp_stroke on temp_stroke.encounter_id = e.encounter_id
left join temp_t1_diabetes on temp_t1_diabetes.encounter_id = e.encounter_id
left join temp_t2_diabetes on temp_t2_diabetes.encounter_id = e.encounter_id
where e.encounter_type in ('DIABETES HYPERTENSION INITIAL VISIT')
group by e.patient_id, e.encounter_date, e.location;