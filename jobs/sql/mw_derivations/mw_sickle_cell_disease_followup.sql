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

drop temporary table if exists temp_sickle_cell_followup_obs;
create temporary table temp_sickle_cell_followup_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'SICKLE_CELL_DISEASE_FOLLOWUP';
alter table temp_sickle_cell_followup_obs add index temp_sickle_cell_followup_obs_concept_idx (concept);
alter table temp_sickle_cell_followup_obs add index temp_sickle_cell_followup_obs_encounter_idx (encounter_id);
alter table temp_sickle_cell_followup_obs add index temp_sickle_cell_followup_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Appointment date'                                                              then value_date    end) as next_appointment_date,
    max(case when concept = 'Ascites'                                                                       then value_coded   end) as ascites,
    max(case when concept = 'Attended school ever'                                                          then value_coded   end) as absence_from_school,
    max(case when concept = 'Blood oxygen saturation'                                                       then value_numeric end) as spo2,
    max(case when concept = 'Body mass index, measured'                                                     then value_numeric end) as bmi_muac,
    max(case when concept = 'Complications since last visit'                                                then value_coded   end) as enlarged_spleen,
    max(case when concept = 'Currently (or in the last week) taking antibiotics'                            then value_coded   end) as antibiotics_rx,
    max(case when concept = 'Diagnosis resolved'                                                            then value_coded   end) as irregular_conjunctiva,
    max(case when concept = 'Diastolic blood pressure'                                                      then value_numeric end) as bp_diastolic,
    max(case when concept = 'Enlarged Liver'                                                                then value_coded   end) as enlarged_liver,
    max(case when concept = 'Extremity exam findings'                                                       then value_coded   end) as Jaundice,
    max(case when concept = 'Haemoglobin'                                                                   then value_numeric end) as hb,
    max(case when concept = 'Height (cm)'                                                                   then value_numeric end) as height,
    max(case when concept = 'Lung exam findings'                                                            then value_coded   end) as abnormal_lungs_exam,
    max(case when concept = 'Malaria'                                                                       then value_coded   end) as medication_rx,
    max(case when concept = 'Medication Side Effects'                                                       then value_coded   end) as medication_side_effects,
    max(case when concept = 'Pain'                                                                          then value_coded   end) as pain,
    max(case when concept = 'Patient experiences fevers, chills, night sweats, or productive cough'         then value_coded   end) as fever,
    max(case when concept = 'Patient hospitalized since last visit'                                         then value_coded   end) as hospitalized_since_last_visit,
    max(case when concept = 'Pulse'                                                                         then value_numeric end) as hr,
    max(case when concept = 'Systolic blood pressure'                                                       then value_numeric end) as bp_systolic,
    max(case when concept = 'Temperature (c)'                                                               then value_numeric end) as temperature,
    max(case when concept = 'Weight (kg)'                                                                   then value_numeric end) as weight
from temp_sickle_cell_followup_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_sickle_cell_disease_followup (patient_id, visit_date, location, abnormal_lungs_exam, absence_from_school, antibiotics_rx, ascites, bmi_muac, bp_diastolic, bp_systolic, enlarged_liver, enlarged_spleen, fever, hr, height, hospitalized_since_last_visit, irregular_conjunctiva, jaundice, medication_rx, medication_side_effects, pain, spo2, temperature, weight, next_appointment_date, hb)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sv.abnormal_lungs_exam) as abnormal_lungs_exam,
    max(sv.absence_from_school) as absence_from_school,
    max(sv.antibiotics_rx) as antibiotics_rx,
    max(sv.ascites) as ascites,
    max(sv.bmi_muac) as bmi_muac,
    max(sv.bp_diastolic) as bp_diastolic,
    max(sv.bp_systolic) as bp_systolic,
    max(sv.enlarged_liver) as enlarged_liver,
    max(sv.enlarged_spleen) as enlarged_spleen,
    max(sv.fever) as fever,
    max(sv.hr) as hr,
    max(sv.height) as height,
    max(sv.hospitalized_since_last_visit) as hospitalized_since_last_visit,
    max(sv.irregular_conjunctiva) as irregular_conjunctiva,
    max(sv.Jaundice) as Jaundice,
    max(sv.medication_rx) as medication_rx,
    max(sv.medication_side_effects) as medication_side_effects,
    max(sv.pain) as pain,
    max(sv.spo2) as spo2,
    max(sv.temperature) as temperature,
    max(sv.weight) as weight,
    max(sv.next_appointment_date) as next_appointment_date,
    max(sv.hb) as hb
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('SICKLE_CELL_DISEASE_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_sickle_cell_followup_obs;
drop temporary table if exists temp_single_values;
