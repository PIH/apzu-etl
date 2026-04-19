-- Derivation script for mw_pdc_developmental_delay_followup
-- Generated from Pentaho transform: import-into-mw-pdc-developmental-delay-followup.ktr

drop table if exists mw_pdc_developmental_delay_followup;
create table mw_pdc_developmental_delay_followup (
  pdc_developmenta_delay_visit_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  height				int default null,
  weight 				int default null,
  muac 					int default null,
  weight_against_age			int default null,
  weight_against_height			int default null,
  malnutrition				varchar(255) default null,
  mdat					varchar(255) default null,
  tone_normal				varchar(255) default null,
  tone_hypo				varchar(255) default null,
  tone_hyper				varchar(255) default null,
  feeding_sucking			varchar(255) default null,
  feeding_cup				varchar(255) default null,
  feeding_tube				varchar(255) default null,
  signs_of_cerebral_palsy		varchar(255) default null,
  under_mental_health_care_program	varchar(255) default null,
  anticonvulsant			varchar(255) default null,
  dose_and_drug				varchar(255) default null,
  dose_adjusted				varchar(255) default null,
  continue_followup			varchar(255) default null,
  feeding_counselling			varchar(255) default null,
  group_counselling_and_play_therapy	varchar(255) default null,
  referred_to_poser			varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  next_appointment_date 		date default null,
  primary key (pdc_developmenta_delay_visit_id)
) ;

insert into mw_pdc_developmental_delay_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Anticonvulsant' then o.value_coded end) as anticonvulsant,
    max(case when o.concept = 'Continue followup' then o.value_coded end) as continue_followup,
    max(case when o.concept = 'Adjust dose' then o.value_coded end) as dose_adjusted,
    max(case when o.concept = 'Medications dispensed' then o.value_text end) as dose_and_drug,
    max(case when o.concept = 'Cup-feeding' then o.value_coded end) as feeding_cup,
    max(case when o.concept = 'Breast feeding' then o.value_coded end) as feeding_sucking,
    max(case when o.concept = 'Orogastric tube' then o.value_coded end) as feeding_tube,
    max(case when o.concept = 'Food supplement' then o.value_coded end) as feeding_counselling,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Referred out' then o.value_coded end) as if_referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as if_referred_out_specify,
    max(case when o.concept = 'Middle upper arm circumference (cm)' then o.value_numeric end) as muac,
    max(case when o.concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' then o.value_coded end) as mdat,
    max(case when o.concept = 'Wasting/malnutrition' then o.value_coded end) as malnutrition,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Play therapy' then o.value_coded end) as group_counselling_and_play_therapy,
    max(case when o.concept = 'Referred out' then o.value_coded end) as referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as referred_out_specify,
    max(case when o.concept = 'Poor Growth' then o.value_coded end) as referred_to_poser,
    max(case when o.concept = 'Signs of Cerebral Palsy' then o.value_coded end) as signs_of_cerebral_palsy,
    max(case when o.concept = 'Hyper' then o.value_coded end) as tone_hyper,
    max(case when o.concept = 'Hypo' then o.value_coded end) as tone_hypo,
    max(case when o.concept = 'Normal(Generic)' then o.value_coded end) as tone_normal,
    max(case when o.concept = 'Mental health referral' then o.value_coded end) as under_mental_health_care_program,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight,
    max(case when o.concept = 'Numeric value or result' then o.value_numeric end) as weight_against_age,
    max(case when o.concept = 'Numeric value or result' then o.value_numeric end) as weight_against_height
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_DEVELOPMENTAL_DELAY_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;