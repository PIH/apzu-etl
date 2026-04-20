-- Derivation script for mw_tb_initial
-- Generated from Pentaho transform: import-into-mw-tb-initial.ktr

drop table if exists mw_tb_initial;
create table mw_tb_initial (
  tb_initial_visit_id 			int not null auto_increment,
  patient_id    				int not null,
  visit_date            		date,
  location              		varchar(255),
  disease_classification 		varchar(255),
  patient_category 				varchar(255),
  diagnosis						varchar(255),
  arv_start_date 				date,
  ctx_start_date 				date,
  hiv_test_history  			varchar(255),
  regimen_rhze					int,
  initiation_month_weight		int,
  dot_option  					varchar(255),
  source_of_referral  			varchar(255),
  dst_result  					varchar(255),
  ptld_date_registered          date,
  date_started_prp              date,
     primary key (tb_initial_visit_id)
);

drop temporary table if exists temp_cotrimoxazole_start_date;
create temporary table temp_cotrimoxazole_start_date as select encounter_id, value_date from omrs_obs where concept = 'Cotrimoxazole Start Date';
alter table temp_cotrimoxazole_start_date add index temp_cotrimoxazole_start_date_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_hiv_diagnosis;
create temporary table temp_date_of_hiv_diagnosis as select encounter_id, value_date from omrs_obs where concept = 'Date of HIV diagnosis';
alter table temp_date_of_hiv_diagnosis add index temp_date_of_hiv_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_tb_drug_sensitivity_testing_non_coded;
create temporary table temp_tb_drug_sensitivity_testing_non_coded as select encounter_id, value_text from omrs_obs where concept = 'Tuberculosis drug sensitivity testing, non-coded';
alter table temp_tb_drug_sensitivity_testing_non_coded add index temp_tb_drug_sensitivity_testing_non_coded_2 (encounter_id);

drop temporary table if exists temp_date_started_pulmonary_rehabilitation;
create temporary table temp_date_started_pulmonary_rehabilitation as select encounter_id, value_date from omrs_obs where concept = 'Date started pulmonary rehabilitation program (PRP)';
alter table temp_date_started_pulmonary_rehabilitation add index temp_date_started_pulmonary_rehabilitation_2 (encounter_id);

drop temporary table if exists temp_tb_case_confirmation;
create temporary table temp_tb_case_confirmation as select encounter_id, value_coded from omrs_obs where concept = 'TB Case Confirmation';
alter table temp_tb_case_confirmation add index temp_tb_case_confirmation_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_testing_completion_coded;
create temporary table temp_hiv_testing_completion_coded as select encounter_id, value_coded from omrs_obs where concept = 'HIV testing completion (coded)';
alter table temp_hiv_testing_completion_coded add index temp_hiv_testing_completion_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_date_registered_in_post_tb_lung_disease_ptld;
create temporary table temp_date_registered_in_post_tb_lung_disease_ptld as select encounter_id, value_date from omrs_obs where concept = 'Date registered in Post TB Lung Disease (PTLD)';
alter table temp_date_registered_in_post_tb_lung_disease_ptld add index temp_date_registered_post_tb_lung_disease_ptld (encounter_id);

drop temporary table if exists temp_number_of_rhze_tablets;
create temporary table temp_number_of_rhze_tablets as select encounter_id, value_numeric from omrs_obs where concept = 'Number of RHZE Tablets';
alter table temp_number_of_rhze_tablets add index temp_number_of_rhze_tablets_encounter_idx (encounter_id);

drop temporary table if exists temp_referral_source;
create temporary table temp_referral_source as select encounter_id, value_coded from omrs_obs where concept = 'Referral Source';
alter table temp_referral_source add index temp_referral_source_encounter_idx (encounter_id);

drop temporary table if exists temp_tuberculosis_case_classification;
create temporary table temp_tuberculosis_case_classification as select encounter_id, value_coded from omrs_obs where concept = 'Tuberculosis case classification';
alter table temp_tuberculosis_case_classification add index temp_tb_case_classification_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_directly_observed_treatment_option;
create temporary table temp_directly_observed_treatment_option as select encounter_id, value_coded from omrs_obs where concept = 'Directly observed treatment option';
alter table temp_directly_observed_treatment_option add index temp_directly_observed_treatment_option_encounter (encounter_id);

drop temporary table if exists temp_patient_reported_current_tb_prophylaxis;
create temporary table temp_patient_reported_current_tb_prophylaxis as select encounter_id, value_coded from omrs_obs where concept = 'Patient reported current tuberculosis prophylaxis';
alter table temp_patient_reported_current_tb_prophylaxis add index temp_patient_reported_current_tb_prophylaxis_2 (encounter_id);

insert into mw_tb_initial (patient_id, visit_date, location, ctx_start_date, arv_start_date, dst_result, date_started_prp, diagnosis, hiv_test_history, ptld_date_registered, regimen_rhze, source_of_referral, disease_classification, initiation_month_weight, dot_option, patient_category)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(cotrimoxazole_start_date.value_date) as ctx_start_date,
    max(date_of_hiv_diagnosis.value_date) as arv_start_date,
    max(tuberculosis_drug_sensitivity_testing_non_coded.value_text) as dst_result,
    max(date_started_pulmonary_rehabilitation_program_prp.value_date) as date_started_prp,
    max(tb_case_confirmation.value_coded) as diagnosis,
    max(hiv_testing_completion_coded.value_coded) as hiv_test_history,
    max(date_registered_in_post_tb_lung_disease_ptld.value_date) as ptld_date_registered,
    max(number_of_rhze_tablets.value_numeric) as regimen_rhze,
    max(referral_source.value_coded) as source_of_referral,
    max(tuberculosis_case_classification.value_coded) as disease_classification,
    max(weight_kg.value_numeric) as initiation_month_weight,
    max(case when 1=1 then
        case directly_observed_treatment_option.value_coded
            when 'Primary Guardian' then 'Guardian'
            when 'Health care worker' then 'HSA'
            when 'Community volunteer' then 'Volunteer'
            when 'Village Health Worker' then 'HCW'
        end
    end) as dot_option,
    max(case when 1=1 then
        case patient_reported_current_tuberculosis_prophylaxis.value_coded
            when 'New patient' then 'New'
            when 'Relapse MDR-TB patient' then 'Relapse'
            when 'Treatment after default MDR-TB patient' then 'RALFT'
            when 'Failed - TB' then 'Fail'
            when 'Other (coded)' then 'Other'
            when 'Unknown' then 'Unk'
        end
    end) as patient_category
from omrs_encounter e
left join temp_cotrimoxazole_start_date cotrimoxazole_start_date on e.encounter_id = cotrimoxazole_start_date.encounter_id
left join temp_date_of_hiv_diagnosis date_of_hiv_diagnosis on e.encounter_id = date_of_hiv_diagnosis.encounter_id
left join temp_tb_drug_sensitivity_testing_non_coded tuberculosis_drug_sensitivity_testing_non_coded on e.encounter_id = tuberculosis_drug_sensitivity_testing_non_coded.encounter_id
left join temp_date_started_pulmonary_rehabilitation date_started_pulmonary_rehabilitation_program_prp on e.encounter_id = date_started_pulmonary_rehabilitation_program_prp.encounter_id
left join temp_tb_case_confirmation tb_case_confirmation on e.encounter_id = tb_case_confirmation.encounter_id
left join temp_hiv_testing_completion_coded hiv_testing_completion_coded on e.encounter_id = hiv_testing_completion_coded.encounter_id
left join temp_date_registered_in_post_tb_lung_disease_ptld date_registered_in_post_tb_lung_disease_ptld on e.encounter_id = date_registered_in_post_tb_lung_disease_ptld.encounter_id
left join temp_number_of_rhze_tablets number_of_rhze_tablets on e.encounter_id = number_of_rhze_tablets.encounter_id
left join temp_referral_source referral_source on e.encounter_id = referral_source.encounter_id
left join temp_tuberculosis_case_classification tuberculosis_case_classification on e.encounter_id = tuberculosis_case_classification.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_directly_observed_treatment_option directly_observed_treatment_option on e.encounter_id = directly_observed_treatment_option.encounter_id
left join temp_patient_reported_current_tb_prophylaxis patient_reported_current_tuberculosis_prophylaxis on e.encounter_id = patient_reported_current_tuberculosis_prophylaxis.encounter_id
where e.encounter_type in ('TB_INITIAL')
group by e.patient_id, e.encounter_date, e.location;
