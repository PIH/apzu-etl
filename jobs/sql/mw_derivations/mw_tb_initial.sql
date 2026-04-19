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

insert into mw_tb_initial
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Cotrimoxazole Start Date' then o.value_date end) as ctx_start_date,
    max(case when o.concept = 'Date of HIV diagnosis' then o.value_date end) as arv_start_date,
    max(case when o.concept = 'Tuberculosis drug sensitivity testing, non-coded' then o.value_text end) as dst_result,
    max(case when o.concept = 'Date started pulmonary rehabilitation program (PRP)' then o.value_date end) as date_started_prp,
    max(case when o.concept = 'TB Case Confirmation' then o.value_coded end) as diagnosis,
    max(case when o.concept = 'HIV testing completion (coded)' then o.value_coded end) as hiv_test_history,
    max(case when o.concept = 'Date registered in Post TB Lung Disease (PTLD)' then o.value_date end) as ptld_date_registered,
    max(case when o.concept = 'Number of RHZE Tablets' then o.value_numeric end) as regimen_rhze,
    max(case when o.concept = 'Referral Source' then o.value_coded end) as source_of_referral,
    max(case when o.concept = 'Tuberculosis case classification' then o.value_coded end) as disease_classification,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as initiation_month_weight,
    max(case when o.concept = 'Directly observed treatment option' then
        case o.value_coded
            when 'Primary Guardian' then 'Guardian'
            when 'Health care worker' then 'HSA'
            when 'Community volunteer' then 'Volunteer'
            when 'Village Health Worker' then 'HCW'
        end
    end) as dot_option,
    max(case when o.concept = 'Patient reported current tuberculosis prophylaxis' then
        case o.value_coded
            when 'New patient' then 'New'
            when 'Relapse MDR-TB patient' then 'Relapse'
            when 'Treatment after default MDR-TB patient' then 'RALFT'
            when 'Failed - TB' then 'Fail'
            when 'Other (coded)' then 'Other'
            when 'Unknown' then 'Unk'
        end
    end) as patient_category
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('TB_INITIAL')
group by e.patient_id, e.encounter_date, e.location;
