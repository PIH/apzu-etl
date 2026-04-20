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

drop temporary table if exists temp_date_of_starting_2nd_line_arv_regimen;
create temporary table temp_date_of_starting_2nd_line_arv_regimen as select encounter_id, value_date from omrs_obs where concept = 'Date of starting 2nd line ARV regimen';
alter table temp_date_of_starting_2nd_line_arv_regimen add index temp_date_starting_2nd_line_arv_regimen_encounter (encounter_id);

drop temporary table if exists temp_date_starting_alternative_1st_line_arv;
create temporary table temp_date_starting_alternative_1st_line_arv as select encounter_id, value_date from omrs_obs where concept = 'Date of starting alternative 1st line ARV regimen';
alter table temp_date_starting_alternative_1st_line_arv add index temp_date_starting_alternative_1st_line_arv_2 (encounter_id);

drop temporary table if exists temp_malawi_antiretroviral_drugs_change_2;
create temporary table temp_malawi_antiretroviral_drugs_change_2 as select encounter_id, value_coded from omrs_obs where concept = 'Malawi Antiretroviral drugs change 2';
alter table temp_malawi_antiretroviral_drugs_change_2 add index temp_malawi_arv_drugs_change_2_encounter_idx (encounter_id);

drop temporary table if exists temp_malawi_antiretroviral_drugs_change_1;
create temporary table temp_malawi_antiretroviral_drugs_change_1 as select encounter_id, value_coded from omrs_obs where concept = 'Malawi Antiretroviral drugs change 1';
alter table temp_malawi_antiretroviral_drugs_change_1 add index temp_malawi_arv_drugs_change_1_encounter_idx (encounter_id);

drop temporary table if exists temp_start_date_1st_line_arv;
create temporary table temp_start_date_1st_line_arv as select encounter_id, value_date from omrs_obs where concept = 'Start date 1st line ARV';
alter table temp_start_date_1st_line_arv add index temp_start_date_1st_line_arv_encounter_idx (encounter_id);

drop temporary table if exists temp_malawi_antiretroviral_drugs_change_3;
create temporary table temp_malawi_antiretroviral_drugs_change_3 as select encounter_id, value_coded from omrs_obs where concept = 'Malawi Antiretroviral drugs change 3';
alter table temp_malawi_antiretroviral_drugs_change_3 add index temp_malawi_arv_drugs_change_3_encounter_idx (encounter_id);

drop temporary table if exists temp_art_education_date;
create temporary table temp_art_education_date as select encounter_id, value_date from omrs_obs where concept = 'ART education date';
alter table temp_art_education_date add index temp_art_education_date_encounter_idx (encounter_id);

drop temporary table if exists temp_arv_education_done;
create temporary table temp_arv_education_done as select encounter_id, value_coded from omrs_obs where concept = 'ARV education done';
alter table temp_arv_education_done add index temp_arv_education_done_encounter_idx (encounter_id);

drop temporary table if exists temp_age;
create temporary table temp_age as select encounter_id, value_numeric from omrs_obs where concept = 'Age';
alter table temp_age add index temp_age_encounter_idx (encounter_id);

drop temporary table if exists temp_cd4_count;
create temporary table temp_cd4_count as select encounter_id, value_numeric from omrs_obs where concept = 'CD4 count';
alter table temp_cd4_count add index temp_cd4_count_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_cd4_count;
create temporary table temp_date_of_cd4_count as select encounter_id, value_date from omrs_obs where concept = 'Date of CD4 count';
alter table temp_date_of_cd4_count add index temp_date_of_cd4_count_encounter_idx (encounter_id);

drop temporary table if exists temp_cd4;
create temporary table temp_cd4 as select encounter_id, value_numeric from omrs_obs where concept = 'Cd4%';
alter table temp_cd4 add index temp_cd4_encounter_idx (encounter_id);

drop temporary table if exists temp_child_hcc_registration_number;
create temporary table temp_child_hcc_registration_number as select encounter_id, value_text from omrs_obs where concept = 'Child HCC Registration Number';
alter table temp_child_hcc_registration_number add index temp_child_hcc_registration_number_encounter_idx (encounter_id);

drop temporary table if exists temp_who_stage;
create temporary table temp_who_stage as select encounter_id, value_coded from omrs_obs where concept = 'WHO stage';
alter table temp_who_stage add index temp_who_stage_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_hiv_diagnosis;
create temporary table temp_date_of_hiv_diagnosis as select encounter_id, value_date from omrs_obs where concept = 'Date of HIV diagnosis';
alter table temp_date_of_hiv_diagnosis add index temp_date_of_hiv_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_confirmatory_hiv_test_location;
create temporary table temp_confirmatory_hiv_test_location as select encounter_id, value_text from omrs_obs where concept = 'Confirmatory HIV test location';
alter table temp_confirmatory_hiv_test_location add index temp_confirmatory_hiv_test_location_encounter_idx (encounter_id);

drop temporary table if exists temp_first_positive_hiv_test_type;
create temporary table temp_first_positive_hiv_test_type as select encounter_id, value_coded from omrs_obs where concept = 'First positive HIV test type';
alter table temp_first_positive_hiv_test_type add index temp_first_positive_hiv_test_type_encounter_idx (encounter_id);

drop temporary table if exists temp_crag_results;
create temporary table temp_crag_results as select encounter_id, value_coded from omrs_obs where concept = 'CrAg Results';
alter table temp_crag_results add index temp_crag_results_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_crag_test;
create temporary table temp_date_of_crag_test as select encounter_id, value_date from omrs_obs where concept = 'Date of CrAg test';
alter table temp_date_of_crag_test add index temp_date_of_crag_test_encounter_idx (encounter_id);

drop temporary table if exists temp_ever_received_art;
create temporary table temp_ever_received_art as select encounter_id, value_coded from omrs_obs where concept = 'Ever received ART?';
alter table temp_ever_received_art add index temp_ever_received_art_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_kaposis_sarcoma_side_effects_worsening_while;
create temporary table temp_kaposis_sarcoma_side_effects_worsening_while as select encounter_id, value_coded from omrs_obs where concept = 'Kaposis sarcoma side effects worsening while on ARVs?';
alter table temp_kaposis_sarcoma_side_effects_worsening_while add index temp_ks_side_effects_worsening_while_arvs (encounter_id);

drop temporary table if exists temp_last_antiretroviral_drugs_taken;
create temporary table temp_last_antiretroviral_drugs_taken as select encounter_id, value_text from omrs_obs where concept = 'Last antiretroviral drugs taken';
alter table temp_last_antiretroviral_drugs_taken add index temp_last_antiretroviral_drugs_taken_encounter_idx (encounter_id);

drop temporary table if exists temp_date_art_last_taken;
create temporary table temp_date_art_last_taken as select encounter_id, value_date from omrs_obs where concept = 'Date ART last taken';
alter table temp_date_art_last_taken add index temp_date_art_last_taken_encounter_idx (encounter_id);

drop temporary table if exists temp_linkage_to_care_id;
create temporary table temp_linkage_to_care_id as select encounter_id, value_text from omrs_obs where concept = 'Linkage to Care ID';
alter table temp_linkage_to_care_id add index temp_linkage_to_care_id_encounter_idx (encounter_id);

drop temporary table if exists temp_pregnant_lactating;
create temporary table temp_pregnant_lactating as select encounter_id, value_coded from omrs_obs where concept = 'Pregnant/Lactating';
alter table temp_pregnant_lactating add index temp_pregnant_lactating_encounter_idx (encounter_id);

drop temporary table if exists temp_presumed_severe_hiv_criteria_present;
create temporary table temp_presumed_severe_hiv_criteria_present as select encounter_id, value_coded from omrs_obs where concept = 'Presumed severe HIV criteria present';
alter table temp_presumed_severe_hiv_criteria_present add index temp_presumed_severe_hiv_criteria_present_2 (encounter_id);

drop temporary table if exists temp_tb_registration_number;
create temporary table temp_tb_registration_number as select encounter_id, value_text from omrs_obs where concept = 'TB registration number';
alter table temp_tb_registration_number add index temp_tb_registration_number_encounter_idx (encounter_id);

drop temporary table if exists temp_tuberculosis_treatment_status;
create temporary table temp_tuberculosis_treatment_status as select encounter_id, value_coded from omrs_obs where concept = 'Tuberculosis treatment status';
alter table temp_tuberculosis_treatment_status add index temp_tuberculosis_treatment_status_encounter_idx (encounter_id);

drop temporary table if exists temp_tuberculosis_drug_treatment_start_date;
create temporary table temp_tuberculosis_drug_treatment_start_date as select encounter_id, value_date from omrs_obs where concept = 'Tuberculosis drug treatment start date';
alter table temp_tuberculosis_drug_treatment_start_date add index temp_tb_drug_treatment_start_date_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_xpert;
create temporary table temp_tb_xpert as select encounter_id, value_coded from omrs_obs where concept = 'TB Xpert';
alter table temp_tb_xpert add index temp_tb_xpert_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_tb_xpert_test;
create temporary table temp_date_of_tb_xpert_test as select encounter_id, value_date from omrs_obs where concept = 'Date of TB Xpert test';
alter table temp_date_of_tb_xpert_test add index temp_date_of_tb_xpert_test_encounter_idx (encounter_id);

drop temporary table if exists temp_transfer_in_date;
create temporary table temp_transfer_in_date as select encounter_id, value_date from omrs_obs where concept = 'Transfer in date';
alter table temp_transfer_in_date add index temp_transfer_in_date_encounter_idx (encounter_id);

drop temporary table if exists temp_urine_lam_crag_result;
create temporary table temp_urine_lam_crag_result as select encounter_id, value_coded from omrs_obs where concept = 'Urine LAM / CrAg Result';
alter table temp_urine_lam_crag_result add index temp_urine_lam_crag_result_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_urine_lam;
create temporary table temp_date_of_urine_lam as select encounter_id, value_date from omrs_obs where concept = 'Date of Urine Lam';
alter table temp_date_of_urine_lam add index temp_date_of_urine_lam_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_conditions_text;
create temporary table temp_clinical_conditions_text as select encounter_id, value_text from omrs_obs where concept = 'Clinical Conditions Text';
alter table temp_clinical_conditions_text add index temp_clinical_conditions_text_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_art_initial (patient_id, visit_date, location, art_second_line_regimen_start_date, art_alternative_first_line_regimen_date, art_alternative_first_line_regimen, art_first_line_regimen, art_first_line_regimen_start_date, art_second_line_regimen, art_education_date, art_education_done, age_at_initiation, cd4_count, cd4_date, cd4_percentage, child_hcc_no, clinical_stage, confirmatory_test_date, confirmatory_test_location, confirmatory_test_type, crag_results, crag_test_date, ever_taken_arvs, height, ks_side_effects_worsening_on_arvs, last_arvs_taken, last_arvs_taken_date, link_id, pregnant_or_lactating, presumed_hiv_severe_present, tb_registration_number, tb_status, tb_treatment_start_date, tb_xpert, tb_xpert_date, transfer_in_date, urine_lam, urine_lam_date, who_clinical_conditions, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_of_starting_2nd_line_arv_regimen.value_date) as art_second_line_regimen_start_date,
    max(date_of_starting_alternative_1st_line_arv_regimen.value_date) as art_alternative_first_line_regimen_date,
    max(malawi_antiretroviral_drugs_change_2.value_coded) as art_alternative_first_line_regimen,
    max(malawi_antiretroviral_drugs_change_1.value_coded) as art_first_line_regimen,
    max(start_date_1st_line_arv.value_date) as art_first_line_regimen_start_date,
    max(malawi_antiretroviral_drugs_change_3.value_coded) as art_second_line_regimen,
    max(art_education_date.value_date) as art_education_date,
    max(arv_education_done.value_coded) as art_education_done,
    max(age.value_numeric) as age_at_initiation,
    max(cd4_count.value_numeric) as cd4_count,
    max(date_of_cd4_count.value_date) as cd4_date,
    max(cd4.value_numeric) as cd4_percentage,
    max(child_hcc_registration_number.value_text) as child_hcc_no,
    max(who_stage.value_coded) as clinical_stage,
    max(date_of_hiv_diagnosis.value_date) as confirmatory_test_date,
    max(confirmatory_hiv_test_location.value_text) as confirmatory_test_location,
    max(first_positive_hiv_test_type.value_coded) as confirmatory_test_type,
    max(crag_results.value_coded) as crag_results,
    max(date_of_crag_test.value_date) as crag_test_date,
    max(ever_received_art.value_coded) as ever_taken_arvs,
    max(height_cm.value_numeric) as height,
    max(kaposis_sarcoma_side_effects_worsening_while_on_arvs.value_coded) as ks_side_effects_worsening_on_arvs,
    max(last_antiretroviral_drugs_taken.value_text) as last_arvs_taken,
    max(date_art_last_taken.value_date) as last_arvs_taken_date,
    max(linkage_to_care_id.value_text) as link_id,
    max(pregnant_lactating.value_coded) as pregnant_or_lactating,
    max(presumed_severe_hiv_criteria_present.value_coded) as presumed_hiv_severe_present,
    max(tb_registration_number.value_text) as tb_registration_number,
    max(tuberculosis_treatment_status.value_coded) as tb_status,
    max(tuberculosis_drug_treatment_start_date.value_date) as tb_treatment_start_date,
    max(tb_xpert.value_coded) as tb_xpert,
    max(date_of_tb_xpert_test.value_date) as tb_xpert_date,
    max(transfer_in_date.value_date) as transfer_in_date,
    max(urine_lam_crag_result.value_coded) as urine_lam,
    max(date_of_urine_lam.value_date) as urine_lam_date,
    max(clinical_conditions_text.value_text) as who_clinical_conditions,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_date_of_starting_2nd_line_arv_regimen date_of_starting_2nd_line_arv_regimen on e.encounter_id = date_of_starting_2nd_line_arv_regimen.encounter_id
left join temp_date_starting_alternative_1st_line_arv date_of_starting_alternative_1st_line_arv_regimen on e.encounter_id = date_of_starting_alternative_1st_line_arv_regimen.encounter_id
left join temp_malawi_antiretroviral_drugs_change_2 malawi_antiretroviral_drugs_change_2 on e.encounter_id = malawi_antiretroviral_drugs_change_2.encounter_id
left join temp_malawi_antiretroviral_drugs_change_1 malawi_antiretroviral_drugs_change_1 on e.encounter_id = malawi_antiretroviral_drugs_change_1.encounter_id
left join temp_start_date_1st_line_arv start_date_1st_line_arv on e.encounter_id = start_date_1st_line_arv.encounter_id
left join temp_malawi_antiretroviral_drugs_change_3 malawi_antiretroviral_drugs_change_3 on e.encounter_id = malawi_antiretroviral_drugs_change_3.encounter_id
left join temp_art_education_date art_education_date on e.encounter_id = art_education_date.encounter_id
left join temp_arv_education_done arv_education_done on e.encounter_id = arv_education_done.encounter_id
left join temp_age age on e.encounter_id = age.encounter_id
left join temp_cd4_count cd4_count on e.encounter_id = cd4_count.encounter_id
left join temp_date_of_cd4_count date_of_cd4_count on e.encounter_id = date_of_cd4_count.encounter_id
left join temp_cd4 cd4 on e.encounter_id = cd4.encounter_id
left join temp_child_hcc_registration_number child_hcc_registration_number on e.encounter_id = child_hcc_registration_number.encounter_id
left join temp_who_stage who_stage on e.encounter_id = who_stage.encounter_id
left join temp_date_of_hiv_diagnosis date_of_hiv_diagnosis on e.encounter_id = date_of_hiv_diagnosis.encounter_id
left join temp_confirmatory_hiv_test_location confirmatory_hiv_test_location on e.encounter_id = confirmatory_hiv_test_location.encounter_id
left join temp_first_positive_hiv_test_type first_positive_hiv_test_type on e.encounter_id = first_positive_hiv_test_type.encounter_id
left join temp_crag_results crag_results on e.encounter_id = crag_results.encounter_id
left join temp_date_of_crag_test date_of_crag_test on e.encounter_id = date_of_crag_test.encounter_id
left join temp_ever_received_art ever_received_art on e.encounter_id = ever_received_art.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_kaposis_sarcoma_side_effects_worsening_while kaposis_sarcoma_side_effects_worsening_while_on_arvs on e.encounter_id = kaposis_sarcoma_side_effects_worsening_while_on_arvs.encounter_id
left join temp_last_antiretroviral_drugs_taken last_antiretroviral_drugs_taken on e.encounter_id = last_antiretroviral_drugs_taken.encounter_id
left join temp_date_art_last_taken date_art_last_taken on e.encounter_id = date_art_last_taken.encounter_id
left join temp_linkage_to_care_id linkage_to_care_id on e.encounter_id = linkage_to_care_id.encounter_id
left join temp_pregnant_lactating pregnant_lactating on e.encounter_id = pregnant_lactating.encounter_id
left join temp_presumed_severe_hiv_criteria_present presumed_severe_hiv_criteria_present on e.encounter_id = presumed_severe_hiv_criteria_present.encounter_id
left join temp_tb_registration_number tb_registration_number on e.encounter_id = tb_registration_number.encounter_id
left join temp_tuberculosis_treatment_status tuberculosis_treatment_status on e.encounter_id = tuberculosis_treatment_status.encounter_id
left join temp_tuberculosis_drug_treatment_start_date tuberculosis_drug_treatment_start_date on e.encounter_id = tuberculosis_drug_treatment_start_date.encounter_id
left join temp_tb_xpert tb_xpert on e.encounter_id = tb_xpert.encounter_id
left join temp_date_of_tb_xpert_test date_of_tb_xpert_test on e.encounter_id = date_of_tb_xpert_test.encounter_id
left join temp_transfer_in_date transfer_in_date on e.encounter_id = transfer_in_date.encounter_id
left join temp_urine_lam_crag_result urine_lam_crag_result on e.encounter_id = urine_lam_crag_result.encounter_id
left join temp_date_of_urine_lam date_of_urine_lam on e.encounter_id = date_of_urine_lam.encounter_id
left join temp_clinical_conditions_text clinical_conditions_text on e.encounter_id = clinical_conditions_text.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('ART_INITIAL')
group by e.patient_id, e.encounter_date, e.location;