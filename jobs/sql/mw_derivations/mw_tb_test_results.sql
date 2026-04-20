-- Derivation script for mw_tb_test_results
-- Generated from Pentaho transform: import-into-mw-tb-test-results.ktr

drop table if exists mw_tb_test_results;
create table mw_tb_test_results (
  tb_test_results_id 					int not null auto_increment,
  patient_id    						int not null,
  visit_date            				date,
  location              				varchar(255),
  initiation_month_smear_test	varchar(255),
  initiation_month_smear_test_date	date,
  initiation_month_smaer_lab_serial_number	varchar(255),
  initiation_month_smear_result	varchar(255),
  initiation_month_culture_test	varchar(255),
  initiation_month_culture_test_date	date,
  initiation_month_culture_lab_serial_number	varchar(255),
  initiation_month_culture_result	varchar(255),
  initiation_month_xpert_test	varchar(255),
  initiation_month_xpert_test_date	date,
  initiation_month_xpert_lab_serial_number	varchar(255),
  initiation_month_xpert_result	varchar(255),
  initiation_month_lam_test	varchar(255),
  initiation_month_lam_test_date	date,
  initiation_month_lam_lab_serial_number	varchar(255),
  initiation_month_lam_result	varchar(255),
  month_two_test	varchar(255),
  month_two_test_date	date,
  month_two_lab_serial_number	varchar(255),
  month_two_result	varchar(255),
  month_two_weight	int(11),
  month_three_test	varchar(255),
  month_three_test_date	date,
  month_three_lab_serial_number	varchar(255),
  month_three_result	varchar(255),
  month_three_weight	int(11),
  month_five_test	varchar(255),
  month_five_test_date	date,
  month_five_lab_serial_number	varchar(255),
  month_five_result	varchar(255),
  month_five_weight	int(11),
  month_six_test	varchar(255),
  month_six_test_date	date,
  month_six_lab_serial_number	varchar(255),
  month_six_result	varchar(255),
  month_six_weight	int(11),
   primary key (tb_test_results_id )
);

-- Each TB test is stored in a 'Tuberculosis test set' obs group with:
--   'TB Test time' obs identifying the period (Initiation, Month 2, Month 3, Month 5, Month 6)
--   'Tuberculosis test type' obs identifying the test type (smear, culture, xpert, lam)
-- The subquery pivots each obs_group into a single row, then the outer query
-- pivots across time + test type dimensions into columns.
insert into mw_tb_test_results (patient_id, visit_date, location, initiation_month_smear_test, initiation_month_smear_test_date, initiation_month_smaer_lab_serial_number, initiation_month_smear_result, initiation_month_culture_test, initiation_month_culture_test_date, initiation_month_culture_lab_serial_number, initiation_month_culture_result, initiation_month_xpert_test, initiation_month_xpert_test_date, initiation_month_xpert_lab_serial_number, initiation_month_xpert_result, initiation_month_lam_test, initiation_month_lam_test_date, initiation_month_lam_lab_serial_number, initiation_month_lam_result, month_two_test, month_two_test_date, month_two_lab_serial_number, month_two_result, month_two_weight, month_three_test, month_three_test_date, month_three_lab_serial_number, month_three_result, month_three_weight, month_five_test, month_five_test_date, month_five_lab_serial_number, month_five_result, month_five_weight, month_six_test, month_six_test_date, month_six_lab_serial_number, month_six_result, month_six_weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    -- Initiation month tests
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis smear microscopy method' then tbs.test_type end) as initiation_month_smear_test,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis smear microscopy method' then tbs.test_date end) as initiation_month_smear_test_date,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis smear microscopy method' then tbs.serial_number end) as initiation_month_smaer_lab_serial_number,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis smear microscopy method' then tbs.test_result end) as initiation_month_smear_result,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis culture method' then tbs.test_type end) as initiation_month_culture_test,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis culture method' then tbs.test_date end) as initiation_month_culture_test_date,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis culture method' then tbs.serial_number end) as initiation_month_culture_lab_serial_number,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis culture method' then tbs.test_result end) as initiation_month_culture_result,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' then 'Xpert' end) as initiation_month_xpert_test,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' then tbs.test_date end) as initiation_month_xpert_test_date,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' then tbs.serial_number end) as initiation_month_xpert_lab_serial_number,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Tuberculosis polymerase chain reaction with rifampin resistance checking' then tbs.test_result end) as initiation_month_xpert_result,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Urine LAM / CrAg Result' then 'Lam' end) as initiation_month_lam_test,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Urine LAM / CrAg Result' then tbs.test_date end) as initiation_month_lam_test_date,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Urine LAM / CrAg Result' then tbs.serial_number end) as initiation_month_lam_lab_serial_number,
    max(case when tbs.tb_time = 'Initiation' and tbs.test_type = 'Urine LAM / CrAg Result' then tbs.test_result end) as initiation_month_lam_result,
    -- Month 2
    max(case when tbs.tb_time = 'Month 2' then tbs.test_type end) as month_two_test,
    max(case when tbs.tb_time = 'Month 2' then tbs.test_date end) as month_two_test_date,
    max(case when tbs.tb_time = 'Month 2' then tbs.serial_number end) as month_two_lab_serial_number,
    max(case when tbs.tb_time = 'Month 2' then tbs.test_result end) as month_two_result,
    max(case when tbs.tb_time = 'Month 2' then tbs.weight end) as month_two_weight,
    -- Month 3
    max(case when tbs.tb_time = 'Month 3' then tbs.test_type end) as month_three_test,
    max(case when tbs.tb_time = 'Month 3' then tbs.test_date end) as month_three_test_date,
    max(case when tbs.tb_time = 'Month 3' then tbs.serial_number end) as month_three_lab_serial_number,
    max(case when tbs.tb_time = 'Month 3' then tbs.test_result end) as month_three_result,
    max(case when tbs.tb_time = 'Month 3' then tbs.weight end) as month_three_weight,
    -- Month 5
    max(case when tbs.tb_time = 'Month 5' then tbs.test_type end) as month_five_test,
    max(case when tbs.tb_time = 'Month 5' then tbs.test_date end) as month_five_test_date,
    max(case when tbs.tb_time = 'Month 5' then tbs.serial_number end) as month_five_lab_serial_number,
    max(case when tbs.tb_time = 'Month 5' then tbs.test_result end) as month_five_result,
    max(case when tbs.tb_time = 'Month 5' then tbs.weight end) as month_five_weight,
    -- Month 6
    max(case when tbs.tb_time = 'Month 6' then tbs.test_type end) as month_six_test,
    max(case when tbs.tb_time = 'Month 6' then tbs.test_date end) as month_six_test_date,
    max(case when tbs.tb_time = 'Month 6' then tbs.serial_number end) as month_six_lab_serial_number,
    max(case when tbs.tb_time = 'Month 6' then tbs.test_result end) as month_six_result,
    max(case when tbs.tb_time = 'Month 6' then tbs.weight end) as month_six_weight
from omrs_encounter e
left join (
    -- Pivot each 'Tuberculosis test set' obs group into a single row
    select
        og.encounter_id,
        og.obs_group_id,
        max(case when oi.concept = 'TB Test time' then oi.value_coded end) as tb_time,
        max(case when oi.concept = 'Tuberculosis test type' then oi.value_coded end) as test_type,
        max(case when oi.concept = 'Date of general test' then oi.value_date end) as test_date,
        max(case when oi.concept = 'Lab test serial number' then oi.value_text end) as serial_number,
        max(case when oi.concept = 'Other lab test result' then oi.value_text end) as test_result,
        max(case when oi.concept = 'Weight (kg)' then oi.value_numeric end) as weight
    from omrs_obs_group og
    inner join omrs_obs oi on oi.obs_group_id = og.obs_group_id
    where og.concept = 'Tuberculosis test set'
    group by og.encounter_id, og.obs_group_id
) tbs on tbs.encounter_id = e.encounter_id
where e.encounter_type = 'TB_INITIAL'
group by e.patient_id, e.encounter_date, e.location;

