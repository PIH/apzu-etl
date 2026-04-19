-- Derivation script for mw_pdc_trisomy_21_followup
-- Generated from Pentaho transform: import-into-mw-pdc-trisomy-21-followup.ktr

drop table if exists mw_pdc_trisomy_21_followup;
create table mw_pdc_trisomy_21_followup (
  pdc_trisomy_21_visit_id 		int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  weight 				int default null,
  height				int default null,
  muac 					int default null,
  malnutrition				varchar(255) default null,
  passage_normal			varchar(255) default null,
  diarrhea_persistent			varchar(255) default null,
  vomiting				varchar(255) default null,
  ear_pain				varchar(255) default null,
  ear_discharge				varchar(255) default null,
  sleep_apnea				varchar(255) default null,
  sleep_chocking			varchar(255) default null,
  extremities_pain			varchar(255) default null,
  extremities_weakness			varchar(255) default null,
  anticonvulsant			varchar(255) default null,
  drug_and_dose				varchar(255) default null,
  adjust_dose				varchar(255) default null,
  individual_counselling		varchar(255) default null,
  feeding_counselling			varchar(255) default null,
  continue_followup			varchar(255) default null,
  physiotherapy				varchar(255) default null,
  group_counselling_and_play_therapy	varchar(255) default null,
  mdat					varchar(255) default null,
  referred_to_poser			varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  next_appointment_date 		date default null,
  primary key (pdc_trisomy_21_visit_id )
) ;

insert into mw_pdc_trisomy_21_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Adjust dose' then o.value_coded end) as adjust_dose,
    max(case when o.concept = 'Anticonvulsant' then o.value_coded end) as anticonvulsant,
    max(case when o.concept = 'Continue followup' then o.value_coded end) as continue_followup,
    max(case when o.concept = 'Diarrhea Persistent' then o.value_coded end) as diarrhea_persistent,
    max(case when o.concept = 'Medications dispensed' then o.value_text end) as drug_and_dose,
    max(case when o.concept = 'Discharge' then o.value_coded end) as ear_discharge,
    max(case when o.concept = 'Pain' then o.value_coded end) as ear_pain,
    max(case when o.concept = 'Pain' then o.value_coded end) as extremities_pain,
    max(case when o.concept = 'Weak' then o.value_coded end) as extremities_weakness,
    max(case when o.concept = 'Food supplement' then o.value_coded end) as feeding_counselling,
    max(case when o.concept = 'Play therapy' then o.value_coded end) as group_counselling_and_play_therapy,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Referred out' then o.value_coded end) as if_referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as if_referred_out_specify,
    max(case when o.concept = 'Counseling' then o.value_coded end) as individual_counselling,
    max(case when o.concept = 'Middle upper arm circumference (cm)' then o.value_numeric end) as muac,
    max(case when o.concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' then o.value_coded end) as mdat,
    max(case when o.concept = 'Wasting/malnutrition' then o.value_coded end) as malnutrition,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Normal(Generic)' then o.value_coded end) as passage_normal,
    max(case when o.concept = 'Physiotherapy' then o.value_coded end) as physiotherapy,
    max(case when o.concept = 'Referred out' then o.value_coded end) as referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as referred_out_specify,
    max(case when o.concept = 'Poor Growth' then o.value_coded end) as referred_to_poser,
    max(case when o.concept = 'Apnea' then o.value_coded end) as sleep_apnea,
    max(case when o.concept = 'Choking' then o.value_coded end) as sleep_chocking,
    max(case when o.concept = 'Patient Vomiting' then o.value_coded end) as vomiting,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_TRISOMY21_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;