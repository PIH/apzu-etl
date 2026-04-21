-- Derivation script for mw_art_initial
-- Generated from Pentaho transform: import-into-mw-art-initial.ktr

drop table if exists mw_art_initial;
create table mw_art_initial (
  art_initial_visit_id 			int not null auto_increment,
  patient_id    				int not null,
  visit_date            			date,
  location              			varchar(255),
  who_clinical_conditions 			varchar(255),
  clinical_stage 				varchar(255),
  presumed_hiv_severe_present			varchar(255),
  tb_status 					varchar(255),
  cd4_count					int,
  cd4_percentage				decimal(6,2),
  ks_side_effects_worsening_on_arvs  		varchar(255),
  cd4_date					date,
  link_id                                       varchar(255),
  tb_xpert                                      varchar(255),
  tb_xpert_date                                 date,
  urine_lam                                     varchar(255),
  urine_lam_date                                date,
  crag_results                                  varchar(255),
  crag_test_date                                date,
  pregnant_or_lactating			varchar(255),
  height					decimal(10,2),
  weight					decimal(10,2),
  ever_taken_arvs				varchar(255),
  age_at_initiation				int,
  last_arvs_taken				varchar(255),
  last_arvs_taken_date				varchar(255),
  confirmatory_test_location   		varchar(255),
  confirmatory_test_date			date,
  confirmatory_test_type 			varchar(255),
  art_education_done				varchar(255),
  art_education_date				date,
  tb_registration_number			varchar(255),
  tb_treatment_start_date			date,
  art_first_line_regimen			varchar(255),
  art_first_line_regimen_start_date		date,
  art_alternative_first_line_regimen		varchar(255),
  art_alternative_first_line_regimen_date	date,
  art_second_line_regimen			varchar(255),
  art_second_line_regimen_start_date		date,
  transfer_in_date				date,
  child_hcc_no					varchar(255),
     primary key (art_initial_visit_id)
);

drop temporary table if exists temp_art_initial_obs;
create temporary table temp_art_initial_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'ART_INITIAL';
alter table temp_art_initial_obs add index temp_art_initial_obs_concept_idx (concept);
alter table temp_art_initial_obs add index temp_art_initial_obs_encounter_idx (encounter_id);
alter table temp_art_initial_obs add index temp_art_initial_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Date of starting 2nd line ARV regimen'                  then value_date    end) as art_second_line_regimen_start_date,
    max(case when concept = 'Date of starting alternative 1st line ARV regimen'       then value_date    end) as art_alternative_first_line_regimen_date,
    max(case when concept = 'Malawi Antiretroviral drugs change 2'                    then value_coded   end) as art_alternative_first_line_regimen,
    max(case when concept = 'Malawi Antiretroviral drugs change 1'                    then value_coded   end) as art_first_line_regimen,
    max(case when concept = 'Start date 1st line ARV'                                 then value_date    end) as art_first_line_regimen_start_date,
    max(case when concept = 'Malawi Antiretroviral drugs change 3'                    then value_coded   end) as art_second_line_regimen,
    max(case when concept = 'ART education date'                                      then value_date    end) as art_education_date,
    max(case when concept = 'ARV education done'                                      then value_coded   end) as art_education_done,
    max(case when concept = 'Age'                                                     then value_numeric end) as age_at_initiation,
    max(case when concept = 'CD4 count'                                               then value_numeric end) as cd4_count,
    max(case when concept = 'Date of CD4 count'                                       then value_date    end) as cd4_date,
    max(case when concept = 'Cd4%'                                                    then value_numeric end) as cd4_percentage,
    max(case when concept = 'Child HCC Registration Number'                           then value_text    end) as child_hcc_no,
    max(case when concept = 'WHO stage'                                               then value_coded   end) as clinical_stage,
    max(case when concept = 'Date of HIV diagnosis'                                   then value_date    end) as confirmatory_test_date,
    max(case when concept = 'Confirmatory HIV test location'                          then value_text    end) as confirmatory_test_location,
    max(case when concept = 'First positive HIV test type'                            then value_coded   end) as confirmatory_test_type,
    max(case when concept = 'CrAg Results'                                            then value_coded   end) as crag_results,
    max(case when concept = 'Date of CrAg test'                                       then value_date    end) as crag_test_date,
    max(case when concept = 'Ever received ART?'                                      then value_coded   end) as ever_taken_arvs,
    max(case when concept = 'Height (cm)'                                             then value_numeric end) as height,
    max(case when concept = 'Kaposis sarcoma side effects worsening while on ARVs?'  then value_coded   end) as ks_side_effects_worsening_on_arvs,
    max(case when concept = 'Last antiretroviral drugs taken'                         then value_text    end) as last_arvs_taken,
    max(case when concept = 'Date ART last taken'                                     then value_date    end) as last_arvs_taken_date,
    max(case when concept = 'Linkage to Care ID'                                      then value_text    end) as link_id,
    max(case when concept = 'Pregnant/Lactating'                                      then value_coded   end) as pregnant_or_lactating,
    max(case when concept = 'Presumed severe HIV criteria present'                    then value_coded   end) as presumed_hiv_severe_present,
    max(case when concept = 'TB registration number'                                  then value_text    end) as tb_registration_number,
    max(case when concept = 'Tuberculosis treatment status'                           then value_coded   end) as tb_status,
    max(case when concept = 'Tuberculosis drug treatment start date'                  then value_date    end) as tb_treatment_start_date,
    max(case when concept = 'TB Xpert'                                                then value_coded   end) as tb_xpert,
    max(case when concept = 'Date of TB Xpert test'                                   then value_date    end) as tb_xpert_date,
    max(case when concept = 'Transfer in date'                                        then value_date    end) as transfer_in_date,
    max(case when concept = 'Urine LAM / CrAg Result'                                then value_coded   end) as urine_lam,
    max(case when concept = 'Date of Urine Lam'                                       then value_date    end) as urine_lam_date,
    max(case when concept = 'Clinical Conditions Text'                                then value_text    end) as who_clinical_conditions,
    max(case when concept = 'Weight (kg)'                                             then value_numeric end) as weight
from temp_art_initial_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_art_initial (patient_id, visit_date, location, art_second_line_regimen_start_date, art_alternative_first_line_regimen_date, art_alternative_first_line_regimen, art_first_line_regimen, art_first_line_regimen_start_date, art_second_line_regimen, art_education_date, art_education_done, age_at_initiation, cd4_count, cd4_date, cd4_percentage, child_hcc_no, clinical_stage, confirmatory_test_date, confirmatory_test_location, confirmatory_test_type, crag_results, crag_test_date, ever_taken_arvs, height, ks_side_effects_worsening_on_arvs, last_arvs_taken, last_arvs_taken_date, link_id, pregnant_or_lactating, presumed_hiv_severe_present, tb_registration_number, tb_status, tb_treatment_start_date, tb_xpert, tb_xpert_date, transfer_in_date, urine_lam, urine_lam_date, who_clinical_conditions, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    sv.art_second_line_regimen_start_date,
    sv.art_alternative_first_line_regimen_date,
    sv.art_alternative_first_line_regimen,
    sv.art_first_line_regimen,
    sv.art_first_line_regimen_start_date,
    sv.art_second_line_regimen,
    sv.art_education_date,
    sv.art_education_done,
    sv.age_at_initiation,
    sv.cd4_count,
    sv.cd4_date,
    sv.cd4_percentage,
    sv.child_hcc_no,
    sv.clinical_stage,
    sv.confirmatory_test_date,
    sv.confirmatory_test_location,
    sv.confirmatory_test_type,
    sv.crag_results,
    sv.crag_test_date,
    sv.ever_taken_arvs,
    sv.height,
    sv.ks_side_effects_worsening_on_arvs,
    sv.last_arvs_taken,
    sv.last_arvs_taken_date,
    sv.link_id,
    sv.pregnant_or_lactating,
    sv.presumed_hiv_severe_present,
    sv.tb_registration_number,
    sv.tb_status,
    sv.tb_treatment_start_date,
    sv.tb_xpert,
    sv.tb_xpert_date,
    sv.transfer_in_date,
    sv.urine_lam,
    sv.urine_lam_date,
    sv.who_clinical_conditions,
    sv.weight
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('ART_INITIAL')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_art_initial_obs;
drop temporary table if exists temp_single_values;
