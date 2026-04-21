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


drop temporary table if exists temp_lung_exam_findings;
create temporary table temp_lung_exam_findings as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Lung exam findings';
alter table temp_lung_exam_findings add index temp_lung_exam_findings_encounter_idx (encounter_id);

drop temporary table if exists temp_attended_school_ever;
create temporary table temp_attended_school_ever as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Attended school ever';
alter table temp_attended_school_ever add index temp_attended_school_ever_encounter_idx (encounter_id);

drop temporary table if exists temp_or_last_week_taking_antibiotics;
create temporary table temp_or_last_week_taking_antibiotics as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Currently (or in the last week) taking antibiotics';
alter table temp_or_last_week_taking_antibiotics add index temp_or_last_week_taking_antibiotics_encounter_idx (encounter_id);

drop temporary table if exists temp_ascites;
create temporary table temp_ascites as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Ascites';
alter table temp_ascites add index temp_ascites_encounter_idx (encounter_id);

drop temporary table if exists temp_body_mass_index_measured;
create temporary table temp_body_mass_index_measured as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Body mass index, measured';
alter table temp_body_mass_index_measured add index temp_body_mass_index_measured_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_enlarged_liver;
create temporary table temp_enlarged_liver as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Enlarged Liver';
alter table temp_enlarged_liver add index temp_enlarged_liver_encounter_idx (encounter_id);

drop temporary table if exists temp_complications_since_last_visit;
create temporary table temp_complications_since_last_visit as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Complications since last visit';
alter table temp_complications_since_last_visit add index temp_complications_since_last_visit_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_experiences_fevers_chills_night;
create temporary table temp_patient_experiences_fevers_chills_night as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Patient experiences fevers, chills, night sweats, or productive cough';
alter table temp_patient_experiences_fevers_chills_night add index temp_patient_experiences_fevers_chills_night_2 (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_patient_hospitalized_since_last_visit;
create temporary table temp_patient_hospitalized_since_last_visit as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Patient hospitalized since last visit';
alter table temp_patient_hospitalized_since_last_visit add index temp_patient_hospitalized_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_diagnosis_resolved;
create temporary table temp_diagnosis_resolved as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Diagnosis resolved';
alter table temp_diagnosis_resolved add index temp_diagnosis_resolved_encounter_idx (encounter_id);

drop temporary table if exists temp_extremity_exam_findings;
create temporary table temp_extremity_exam_findings as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Extremity exam findings';
alter table temp_extremity_exam_findings add index temp_extremity_exam_findings_encounter_idx (encounter_id);

drop temporary table if exists temp_malaria;
create temporary table temp_malaria as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Malaria';
alter table temp_malaria add index temp_malaria_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_side_effects;
create temporary table temp_medication_side_effects as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Medication Side Effects';
alter table temp_medication_side_effects add index temp_medication_side_effects_encounter_idx (encounter_id);

drop temporary table if exists temp_pain;
create temporary table temp_pain as select encounter_id, value_coded from temp_sickle_cell_followup_obs where concept = 'Pain';
alter table temp_pain add index temp_pain_encounter_idx (encounter_id);

drop temporary table if exists temp_blood_oxygen_saturation;
create temporary table temp_blood_oxygen_saturation as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Blood oxygen saturation';
alter table temp_blood_oxygen_saturation add index temp_blood_oxygen_saturation_encounter_idx (encounter_id);

drop temporary table if exists temp_temperature_c;
create temporary table temp_temperature_c as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Temperature (c)';
alter table temp_temperature_c add index temp_temperature_c_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from temp_sickle_cell_followup_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_haemoglobin;
create temporary table temp_haemoglobin as select encounter_id, value_numeric from temp_sickle_cell_followup_obs where concept = 'Haemoglobin';
alter table temp_haemoglobin add index temp_haemoglobin_encounter_idx (encounter_id);

insert into mw_sickle_cell_disease_followup (patient_id, visit_date, location, abnormal_lungs_exam, absence_from_school, antibiotics_rx, ascites, bmi_muac, bp_diastolic, bp_systolic, enlarged_liver, enlarged_spleen, fever, hr, height, hospitalized_since_last_visit, irregular_conjunctiva, jaundice, medication_rx, medication_side_effects, pain, spo2, temperature, weight, next_appointment_date, hb)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(lung_exam_findings.value_coded) as abnormal_lungs_exam,
    max(attended_school_ever.value_coded) as absence_from_school,
    max(currently_or_in_the_last_week_taking_antibiotics.value_coded) as antibiotics_rx,
    max(ascites.value_coded) as ascites,
    max(body_mass_index_measured.value_numeric) as bmi_muac,
    max(diastolic_blood_pressure.value_numeric) as bp_diastolic,
    max(systolic_blood_pressure.value_numeric) as bp_systolic,
    max(enlarged_liver.value_coded) as enlarged_liver,
    max(complications_since_last_visit.value_coded) as enlarged_spleen,
    max(patient_experiences_fevers_chills_night_sweats_or_productive_cough.value_coded) as fever,
    max(pulse.value_numeric) as hr,
    max(height_cm.value_numeric) as height,
    max(patient_hospitalized_since_last_visit.value_coded) as hospitalized_since_last_visit,
    max(diagnosis_resolved.value_coded) as irregular_conjunctiva,
    max(extremity_exam_findings.value_coded) as Jaundice,
    max(malaria.value_coded) as medication_rx,
    max(medication_side_effects.value_coded) as medication_side_effects,
    max(pain.value_coded) as pain,
    max(blood_oxygen_saturation.value_numeric) as spo2,
    max(temperature_c.value_numeric) as temperature,
    max(weight_kg.value_numeric) as weight,
    max(appointment_date.value_date) as next_appointment_date,
    max(haemoglobin.value_numeric) as hb
from omrs_encounter e
left join temp_lung_exam_findings lung_exam_findings on e.encounter_id = lung_exam_findings.encounter_id
left join temp_attended_school_ever attended_school_ever on e.encounter_id = attended_school_ever.encounter_id
left join temp_or_last_week_taking_antibiotics currently_or_in_the_last_week_taking_antibiotics on e.encounter_id = currently_or_in_the_last_week_taking_antibiotics.encounter_id
left join temp_ascites ascites on e.encounter_id = ascites.encounter_id
left join temp_body_mass_index_measured body_mass_index_measured on e.encounter_id = body_mass_index_measured.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_enlarged_liver enlarged_liver on e.encounter_id = enlarged_liver.encounter_id
left join temp_complications_since_last_visit complications_since_last_visit on e.encounter_id = complications_since_last_visit.encounter_id
left join temp_patient_experiences_fevers_chills_night patient_experiences_fevers_chills_night_sweats_or_productive_cough on e.encounter_id = patient_experiences_fevers_chills_night_sweats_or_productive_cough.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_patient_hospitalized_since_last_visit patient_hospitalized_since_last_visit on e.encounter_id = patient_hospitalized_since_last_visit.encounter_id
left join temp_diagnosis_resolved diagnosis_resolved on e.encounter_id = diagnosis_resolved.encounter_id
left join temp_extremity_exam_findings extremity_exam_findings on e.encounter_id = extremity_exam_findings.encounter_id
left join temp_malaria malaria on e.encounter_id = malaria.encounter_id
left join temp_medication_side_effects medication_side_effects on e.encounter_id = medication_side_effects.encounter_id
left join temp_pain pain on e.encounter_id = pain.encounter_id
left join temp_blood_oxygen_saturation blood_oxygen_saturation on e.encounter_id = blood_oxygen_saturation.encounter_id
left join temp_temperature_c temperature_c on e.encounter_id = temperature_c.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_haemoglobin haemoglobin on e.encounter_id = haemoglobin.encounter_id
where e.encounter_type in ('SICKLE_CELL_DISEASE_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;