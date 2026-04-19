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

insert into mw_sickle_cell_disease_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Date antiretrovirals started' then o.value_date end) as art_start_date,
    max(case when o.concept = 'PDC Reasons for referral' and o.value_coded = 'Patient transfer in' then o.value_coded end) as referral_history_inpatient,
    max(case when o.concept = 'PDC Reasons for referral' and o.value_coded = 'OPD clinic' then o.value_coded end) as referral_history_opd,
    max(case when o.concept = 'PDC Reasons for referral' and o.value_coded = 'IC3' then o.value_coded end) as referral_history_ic3,
    max(case when o.concept = 'Diagnosis date' then o.value_date end) as diagnosis_date,
    max(case when o.concept = 'HIV status' then o.value_coded end) as hiv_status,
    max(case when o.concept = 'HIV test date' then o.value_date end) as hiv_test_date,
    max(case when o.concept = 'Parent relationship' then o.value_coded end) as parent,
    max(case when o.concept = 'Sibling relationship' then o.value_coded end) as sibling,
    max(case when o.concept = 'Microscopy' then o.value_coded end) as microscopy,
    max(case when o.concept = 'Microscopy date' then o.value_date end) as microscopy_test_date,
    max(case when o.concept = 'Rapid Testing' then o.value_coded end) as rapid_test,
    max(case when o.concept = 'Rapid testing date' then o.value_date end) as rapid_test_date,
    max(case when o.concept = 'HB electrophoresis' then o.value_coded end) as hb_electrophoresis,
    max(case when o.concept = 'HB electrophoresis date' then o.value_date end) as hb_electrophoresis_test_date,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as referral_history_other_specify,
    max(case when og.concept = 'Reasons for referral set' and o.concept = 'PDC Reasons for referral' and o.value_coded = 'Referred out' then 'Other' end) as referral_history_other
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
left join omrs_obs_group og on og.obs_group_id = o.obs_group_id
where e.encounter_type in ('SICKLE_CELL_DISEASE_INITIAL')
group by e.patient_id, e.encounter_date, e.location;
