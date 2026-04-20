-- Derivation script for mw_sickle_cell_disease_initial
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-initial.ktr

drop table if exists mw_sickle_cell_disease_initial;
create table mw_sickle_cell_disease_initial (
  sickle_cell_disease__initial_visit_id int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  diagnosis_date	 		date default null,
  microscopy				varchar(255) default null,
  microscopy_test_date 			date default null,
  rapid_test				varchar(255) default null,
  rapid_test_date 			date default null,
  hb_electrophoresis			varchar(255) default null,
  hb_electrophoresis_test_date 		date default null,
  hiv_status 				varchar(255) default null,
  hiv_test_date 			date default null,
  art_start_date 			date default null,
  parent 				varchar(255) default null,
  sibling				varchar(255) default null,
  referral_history_inpatient 		varchar(255) default null,
  referral_history_ic3 			varchar(255) default null,
  referral_history_opd 			varchar(255) default null,
  referral_history_other 		varchar(255) default null,
  referral_history_other_specify 	varchar(255) default null,
  primary key (sickle_cell_disease__initial_visit_id)
);

drop temporary table if exists temp_date_antiretrovirals_started;
create temporary table temp_date_antiretrovirals_started as select encounter_id, value_date from omrs_obs where concept = 'Date antiretrovirals started';
alter table temp_date_antiretrovirals_started add index temp_date_antiretrovirals_started_encounter_idx (encounter_id);

drop temporary table if exists temp_pdc_reasons_for_referral;
create temporary table temp_pdc_reasons_for_referral as select encounter_id, value_coded, obs_group_id from omrs_obs where concept = 'PDC Reasons for referral';
alter table temp_pdc_reasons_for_referral add index temp_pdc_reasons_for_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis_date;
create temporary table temp_diagnosis_date as select encounter_id, value_date from omrs_obs where concept = 'Diagnosis date';
alter table temp_diagnosis_date add index temp_diagnosis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_date;
create temporary table temp_hiv_test_date as select encounter_id, value_date from omrs_obs where concept = 'HIV test date';
alter table temp_hiv_test_date add index temp_hiv_test_date_encounter_idx (encounter_id);

drop temporary table if exists temp_parent_relationship;
create temporary table temp_parent_relationship as select encounter_id, value_coded from omrs_obs where concept = 'Parent relationship';
alter table temp_parent_relationship add index temp_parent_relationship_encounter_idx (encounter_id);

drop temporary table if exists temp_sibling_relationship;
create temporary table temp_sibling_relationship as select encounter_id, value_coded from omrs_obs where concept = 'Sibling relationship';
alter table temp_sibling_relationship add index temp_sibling_relationship_encounter_idx (encounter_id);

drop temporary table if exists temp_microscopy;
create temporary table temp_microscopy as select encounter_id, value_coded from omrs_obs where concept = 'Microscopy';
alter table temp_microscopy add index temp_microscopy_encounter_idx (encounter_id);

drop temporary table if exists temp_microscopy_date;
create temporary table temp_microscopy_date as select encounter_id, value_date from omrs_obs where concept = 'Microscopy date';
alter table temp_microscopy_date add index temp_microscopy_date_encounter_idx (encounter_id);

drop temporary table if exists temp_rapid_testing;
create temporary table temp_rapid_testing as select encounter_id, value_coded from omrs_obs where concept = 'Rapid Testing';
alter table temp_rapid_testing add index temp_rapid_testing_encounter_idx (encounter_id);

drop temporary table if exists temp_rapid_testing_date;
create temporary table temp_rapid_testing_date as select encounter_id, value_date from omrs_obs where concept = 'Rapid testing date';
alter table temp_rapid_testing_date add index temp_rapid_testing_date_encounter_idx (encounter_id);

drop temporary table if exists temp_hb_electrophoresis;
create temporary table temp_hb_electrophoresis as select encounter_id, value_coded from omrs_obs where concept = 'HB electrophoresis';
alter table temp_hb_electrophoresis add index temp_hb_electrophoresis_encounter_idx (encounter_id);

drop temporary table if exists temp_hb_electrophoresis_date;
create temporary table temp_hb_electrophoresis_date as select encounter_id, value_date from omrs_obs where concept = 'HB electrophoresis date';
alter table temp_hb_electrophoresis_date add index temp_hb_electrophoresis_date_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

insert into mw_sickle_cell_disease_initial (patient_id, visit_date, location, art_start_date, referral_history_inpatient, referral_history_opd, referral_history_ic3, diagnosis_date, hiv_status, hiv_test_date, parent, sibling, microscopy, microscopy_test_date, rapid_test, rapid_test_date, hb_electrophoresis, hb_electrophoresis_test_date, referral_history_other_specify, referral_history_other)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(date_antiretrovirals_started.value_date) as art_start_date,
    max(case when pdc_reasons_for_referral.value_coded = 'Patient transfer in' then pdc_reasons_for_referral.value_coded end) as referral_history_inpatient,
    max(case when pdc_reasons_for_referral.value_coded = 'OPD clinic' then pdc_reasons_for_referral.value_coded end) as referral_history_opd,
    max(case when pdc_reasons_for_referral.value_coded = 'IC3' then pdc_reasons_for_referral.value_coded end) as referral_history_ic3,
    max(diagnosis_date.value_date) as diagnosis_date,
    max(hiv_status.value_coded) as hiv_status,
    max(hiv_test_date.value_date) as hiv_test_date,
    max(parent_relationship.value_coded) as parent,
    max(sibling_relationship.value_coded) as sibling,
    max(microscopy.value_coded) as microscopy,
    max(microscopy_date.value_date) as microscopy_test_date,
    max(rapid_testing.value_coded) as rapid_test,
    max(rapid_testing_date.value_date) as rapid_test_date,
    max(hb_electrophoresis.value_coded) as hb_electrophoresis,
    max(hb_electrophoresis_date.value_date) as hb_electrophoresis_test_date,
    max(other_non_coded_text.value_text) as referral_history_other_specify,
    max(case when pdc_referral_og.concept = 'Reasons for referral set' and pdc_reasons_for_referral.value_coded = 'Referred out' then 'Other' end) as referral_history_other
from omrs_encounter e
left join temp_date_antiretrovirals_started date_antiretrovirals_started on e.encounter_id = date_antiretrovirals_started.encounter_id
left join temp_pdc_reasons_for_referral pdc_reasons_for_referral on e.encounter_id = pdc_reasons_for_referral.encounter_id
left join omrs_obs_group pdc_referral_og on pdc_referral_og.obs_group_id = pdc_reasons_for_referral.obs_group_id
left join temp_diagnosis_date diagnosis_date on e.encounter_id = diagnosis_date.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_hiv_test_date hiv_test_date on e.encounter_id = hiv_test_date.encounter_id
left join temp_parent_relationship parent_relationship on e.encounter_id = parent_relationship.encounter_id
left join temp_sibling_relationship sibling_relationship on e.encounter_id = sibling_relationship.encounter_id
left join temp_microscopy microscopy on e.encounter_id = microscopy.encounter_id
left join temp_microscopy_date microscopy_date on e.encounter_id = microscopy_date.encounter_id
left join temp_rapid_testing rapid_testing on e.encounter_id = rapid_testing.encounter_id
left join temp_rapid_testing_date rapid_testing_date on e.encounter_id = rapid_testing_date.encounter_id
left join temp_hb_electrophoresis hb_electrophoresis on e.encounter_id = hb_electrophoresis.encounter_id
left join temp_hb_electrophoresis_date hb_electrophoresis_date on e.encounter_id = hb_electrophoresis_date.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
where e.encounter_type in ('SICKLE_CELL_DISEASE_INITIAL')
group by e.patient_id, e.encounter_date, e.location;
