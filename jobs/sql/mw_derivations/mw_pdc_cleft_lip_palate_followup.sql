-- Derivation script for mw_pdc_cleft_lip_palate_followup
-- Generated from Pentaho transform: import-into-mw-pdc-cleft-lip-palate-followup.ktr

drop table if exists mw_pdc_cleft_lip_palate_followup;
create table mw_pdc_cleft_lip_palate_followup (
  pdc_cleft_lip_palate_visit_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  weight 				int default null,
  height				int default null,
  muac 				int default null,
  weight_for_age			int default null,
  height_for_age			int default null,
  malnutrition				varchar(255) default null,
  feeding_problems			varchar(255) default null,
  difficult_breathing			varchar(255) default null,
  heart_murmur				varchar(255) default null,
  ear_pain				varchar(255) default null,
  ear_discharge			varchar(255) default null,
  other			        varchar(255) default null,
  surgery_scheduled			varchar(255) default null,
  surgery_date				date default null,
  continue_followup			varchar(255) default null,
  group_therapy			varchar(255) default null,
  food_supplement			varchar(255) default null,
  individual_counselling		varchar(255) default null,
  feeding_counseling			varchar(255) default null,
  mdat					varchar(255) default null,
  poser				varchar(255) default null,
  referred_out				varchar(255) default null,
  referred_out_specify			varchar(255) default null,
  if_referred_out			varchar(255) default null,
  if_referred_out_specify		varchar(255) default null,
  clinical_plan			varchar(255) default null,
  next_appointment_date		date default null,
  primary key (pdc_cleft_lip_palate_visit_id)
) ;

insert into mw_pdc_cleft_lip_palate_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Continue followup' then o.value_coded end) as continue_followup,
    max(case when o.concept = 'Difficult breathing' then o.value_coded end) as difficult_breathing,
    max(case when o.concept = 'Discharge' then o.value_coded end) as ear_discharge,
    max(case when o.concept = 'Pain' then o.value_coded end) as ear_pain,
    max(case when o.concept = 'Counseling' then o.value_coded end) as feeding_counseling,
    max(case when o.concept = 'Feeding issues' then o.value_coded end) as feeding_problems,
    max(case when o.concept = 'Food supplement' then o.value_coded end) as food_supplement,
    max(case when o.concept = 'Support group' then o.value_coded end) as group_therapy,
    max(case when o.concept = 'Heart murmur' then o.value_coded end) as heart_murmur,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Height for age percent of median' then o.value_numeric end) as height_for_age,
    max(case when o.concept = 'Referred out' then o.value_coded end) as if_referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as if_referred_out_specify,
    max(case when o.concept = 'Group Counselling' then o.value_coded end) as individual_counselling,
    max(case when o.concept = 'Middle upper arm circumference (cm)' then o.value_numeric end) as muac,
    max(case when o.concept = 'Malawi Developmental Assessment Tool Summary (Normal)-(Coded)' then o.value_coded end) as mdat,
    max(case when o.concept = 'Wasting/malnutrition' then o.value_coded end) as malnutrition,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Other assessments' then o.value_coded end) as other,
    max(case when o.concept = 'Poser Support' then o.value_coded end) as poser,
    max(case when o.concept = 'Clinical impression comments' then o.value_text end) as clinical_plan,
    max(case when o.concept = 'Referred out' then o.value_coded end) as referred_out,
    max(case when o.concept = 'Other non-coded (text)' then o.value_text end) as referred_out_specify,
    max(case when o.concept = 'Date of surgery' then o.value_date end) as surgery_date,
    max(case when o.concept = 'Scheduled' then o.value_coded end) as surgery_scheduled,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight,
    max(case when o.concept = 'Weight for age percent of median' then o.value_numeric end) as weight_for_age
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('PDC_CLEFT_CLIP_PALLET_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;