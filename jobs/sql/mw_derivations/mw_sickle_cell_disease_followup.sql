-- Derivation script for mw_sickle_cell_disease_followup
-- Generated from Pentaho transform: import-into-mw-sickle-cell-disease-followup.ktr

drop table if exists mw_sickle_cell_disease_followup;
create table mw_sickle_cell_disease_followup (
  sickle_cell_disease_followup_visit_id int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  height 				int default null,
  weight 				int default null,
  bmi_muac				int default null,
  bp_systolic 				int default null,
  bp_diastolic		 		int default null,
  hr			 		int default null,
  hb			 		int default null,
  spo2				 	int default null,
  temperature				int default null,
  hospitalized_since_last_visit		varchar(255) default null,
  absence_from_school 			varchar(255) default null,
  pain		 			varchar(255) default null,
  fever		 			varchar(255) default null,
  medication_rx				varchar(255) default null,
  antibiotics_rx			varchar(255) default null,
  medication_side_effects		varchar(255) default null,
  Jaundice			 	varchar(255) default null,
  irregular_conjunctiva 		varchar(255) default null,
  abnormal_lungs_exam 			varchar(255) default null,
  ascites	 			varchar(255) default null,
  enlarged_liver 			varchar(255) default null,
  enlarged_spleen			varchar(255) default null,
  next_appointment_date			date,
  primary key (sickle_cell_disease_followup_visit_id));

insert into mw_sickle_cell_disease_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'Lung exam findings' then o.value_coded end) as abnormal_lungs_exam,
    max(case when o.concept = 'Attended school ever' then o.value_coded end) as absence_from_school,
    max(case when o.concept = 'Currently (or in the last week) taking antibiotics' then o.value_coded end) as antibiotics_rx,
    max(case when o.concept = 'Ascites' then o.value_coded end) as ascites,
    max(case when o.concept = 'Body mass index, measured' then o.value_numeric end) as bmi_muac,
    max(case when o.concept = 'Diastolic blood pressure' then o.value_numeric end) as bp_diastolic,
    max(case when o.concept = 'Systolic blood pressure' then o.value_numeric end) as bp_systolic,
    max(case when o.concept = 'Enlarged Liver' then o.value_coded end) as enlarged_liver,
    max(case when o.concept = 'Complications since last visit' then o.value_coded end) as enlarged_spleen,
    max(case when o.concept = 'Patient experiences fevers, chills, night sweats, or productive cough' then o.value_coded end) as fever,
    max(case when o.concept = 'Pulse' then o.value_numeric end) as hr,
    max(case when o.concept = 'Height (cm)' then o.value_numeric end) as height,
    max(case when o.concept = 'Patient hospitalized since last visit' then o.value_coded end) as hospitalized_since_last_visit,
    max(case when o.concept = 'Diagnosis resolved' then o.value_coded end) as irregular_conjunctiva,
    max(case when o.concept = 'Extremity exam findings' then o.value_coded end) as Jaundice,
    max(case when o.concept = 'Malaria' then o.value_coded end) as medication_rx,
    max(case when o.concept = 'Medication Side Effects' then o.value_coded end) as medication_side_effects,
    max(case when o.concept = 'Pain' then o.value_coded end) as pain,
    max(case when o.concept = 'Blood oxygen saturation' then o.value_numeric end) as spo2,
    max(case when o.concept = 'Temperature (c)' then o.value_numeric end) as temperature,
    max(case when o.concept = 'Weight (kg)' then o.value_numeric end) as weight,
    max(case when o.concept = 'Appointment date' then o.value_date end) as next_appointment_date,
    max(case when o.concept = 'Haemoglobin' then o.value_numeric end) as hb
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
where e.encounter_type in ('SICKLE_CELL_DISEASE_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;