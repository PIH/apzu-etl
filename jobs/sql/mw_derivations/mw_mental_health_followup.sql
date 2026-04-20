-- Derivation script for mw_mental_health_followup
-- Generated from Pentaho transform: import-into-mw-mental-health-followup.ktr

drop table if exists mw_mental_health_followup;
create table mw_mental_health_followup (
  mental_health_followup_visit_id 	int not null auto_increment,
  patient_id 				int not null,
  visit_date 				date default null,
  location 				varchar(255) default null,
  height 				int default null,
  weight 				int default null,
  phq_nine_score 		        int default null,
  mse_depressed_mood 			varchar(255) default null,
  mse_elevated_mood 			varchar(255) default null,
  mse_disruptive_behaviour 		varchar(255) default null,
  mse_disorganized_speech 		varchar(255) default null,
  mse_delusions 			varchar(255) default null,
  mse_hallucinations 			varchar(255) default null,
  mse_Lack_of_insight 			varchar(255) default null,
  mse_other 				varchar(255) default null,
  patient_stable 			varchar(255) default null,
  able_to_do_daily_activities  	varchar(255) default null,
  current_use_marijuana 		varchar(255) default null,
  current_use_alcohol 			varchar(255) default null,
  current_use_other 			varchar(255) default null,
  pregnant 				varchar(255) default null,
  on_family_planning 			varchar(255) default null,
  suicide_risk 			varchar(255) default null,
  medications_side_effects 		varchar(255) default null,
  hospitalized_since_last_visit 	varchar(255) default null,
  counselling_provided			varchar(255) default null,
  med_chloropromazine 			varchar(255) default null,
  med_chloropromazine_dose		int,
  med_chloropromazine_dosing_unit varchar(50),
  med_chloropromazine_route		varchar(50),
  med_chloropromazine_frequency		varchar(50),
  med_chloropromazine_duration   int,
  med_chloropromazine_duration_units  varchar(50),
  med_haloperidol 			varchar(255) default null,
  med_haloperidolp_dose		int,
  med_haloperidol_dosing_unit varchar(50),
  med_haloperidol_route		varchar(50),
  med_haloperidol_frequency		varchar(50),
  med_haloperidol_duration   int,
  med_haloperidol_duration_units  varchar(50),
  med_risperidone			varchar(255) default null,
  med_risperidone_dose		int,
  med_risperidone_dosing_unit varchar(50),
  med_risperidone_route		varchar(50),
  med_risperidone_frequency		varchar(50),
  med_risperidone_duration   int,
  med_risperidone_duration_units  varchar(50),
  med_fluphenazine 			varchar(255) default null,
  med_fluphenazine_dose		int,
  med_fluphenazine_dosing_unit varchar(50),
  med_fluphenazine_route		varchar(50),
   med_fluphenazine_frequency		varchar(50),
   med_fluphenazine_duration   int,
   med_fluphenazine_duration_units  varchar(50),
  med_carbamazepine 			varchar(255) default null,
  med_carbamazepine_dose		int,
  med_carbamazepine_dosing_unit varchar(50),
  med_carbamazepine_route		varchar(50),
  med_carbamazepine_frequency		varchar(50),
  med_carbamazepine_duration   int,
  med_carbamazepine_duration_units  varchar(50),
  med_sodium_valproate 		varchar(255) default null,
  med_sodium_valproate_dose		int,
  med_sodium_valproate_dosing_unit varchar(50),
  med_sodium_valproate_route		varchar(50),
  med_sodium_valproate_frequency		varchar(50),
  med_sodium_valproate_duration   int,
  med_sodium_valproate_duration_units  varchar(50),
  med_fluoxetine 			varchar(255) default null,
  med_fluoxetine_dose		int,
  med_fluoxetine_dosing_unit varchar(50),
  med_fluoxetine_route		varchar(50),
  med_fluoxetine_frequency		varchar(50),
  med_fluoxetine_duration   int,
  med_fluoxetine_duration_units  varchar(50),
  med_olanzapine 			varchar(255) default null,
  med_olanzapine_dose		int,
  med_olanzapine_dosing_unit varchar(50),
  med_olanzapine_route		varchar(50),
  med_olanzapine_frequency		varchar(50),
  med_olanzapine_duration   int,
  med_olanzapine_duration_units  varchar(50),
  med_clozapine 			varchar(255) default null,
  med_clozapine_dose		int,
  med_clozapine_dosing_unit varchar(50),
  med_clozapine_route		varchar(50),
  med_clozapine_frequency		varchar(50),
  med_clozapine_duration   int,
  med_clozapine_duration_units  varchar(50),
  med_trifluoperazine 			varchar(255) default null,
  med_trifluoperazine_dose		int,
  med_trifluoperazine_dosing_unit varchar(50),
  med_trifluoperazine_route		varchar(50),
  med_trifluoperazine_frequency		varchar(50),
  med_trifluoperazine_duration   int,
  med_trifluoperazine_duration_units  varchar(50),
  med_clopixol 			varchar(255) default null,
  med_clopixol_dose		int,
  med_clopixol_dosing_unit varchar(50),
  med_clopixol_route		varchar(50),
  med_clopixol_frequency		varchar(50),
  med_clopixol_duration   int,
  med_clopixol_duration_units  varchar(50),
  med_amitriptyline                    varchar(255) default null,
  med_amitriptyline_dose		int,
  med_amitriptyline_dosing_unit varchar(50),
  med_amitriptyline_route		varchar(50),
  med_amitriptyline_frequency		varchar(50),
  med_amitriptyline_duration   int,
  med_amitriptyline_duration_units  varchar(50),
  med_other 				varchar(255) default null,
  comments 				varchar(2000) default null,
  next_appointment_date 		date default null,
  primary key (mental_health_followup_visit_id)
) ;

drop temporary table if exists temp_drug_frequency_coded;
create temporary table temp_drug_frequency_coded as select encounter_id, value_coded from omrs_obs where concept = 'Drug frequency coded';
alter table temp_drug_frequency_coded add index temp_drug_frequency_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_routes_of_administration_coded;
create temporary table temp_routes_of_administration_coded as select encounter_id, value_coded from omrs_obs where concept = 'Routes of administration (coded)';
alter table temp_routes_of_administration_coded add index temp_routes_of_administration_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_able_to_perform_daily_activities;
create temporary table temp_able_to_perform_daily_activities as select encounter_id, value_coded from omrs_obs where concept = 'Able to perform daily activities';
alter table temp_able_to_perform_daily_activities add index temp_able_perform_daily_acts_encounter_idx (encounter_id);

drop temporary table if exists temp_quantity_of_medication_prescribed_per_dose;
create temporary table temp_quantity_of_medication_prescribed_per_dose as select encounter_id, value_numeric from omrs_obs where concept = 'Quantity of medication prescribed per dose';
alter table temp_quantity_of_medication_prescribed_per_dose add index temp_quantity_medication_prescribed_per_dose (encounter_id);

drop temporary table if exists temp_dosing_unit;
create temporary table temp_dosing_unit as select encounter_id, value_coded from omrs_obs where concept = 'Dosing unit';
alter table temp_dosing_unit add index temp_dosing_unit_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_duration;
create temporary table temp_medication_duration as select encounter_id, value_numeric from omrs_obs where concept = 'Medication duration';
alter table temp_medication_duration add index temp_medication_duration_encounter_idx (encounter_id);

drop temporary table if exists temp_time_units;
create temporary table temp_time_units as select encounter_id, value_coded from omrs_obs where concept = 'Time units';
alter table temp_time_units add index temp_time_units_encounter_idx (encounter_id);

drop temporary table if exists temp_history_of_alcohol_use;
create temporary table temp_history_of_alcohol_use as select encounter_id, value_coded from omrs_obs where concept = 'History of alcohol use';
alter table temp_history_of_alcohol_use add index temp_history_of_alcohol_use_encounter_idx (encounter_id);

drop temporary table if exists temp_mental_health_chief_complaint_absent;
create temporary table temp_mental_health_chief_complaint_absent as select encounter_id, value_coded from omrs_obs where concept = 'Mental health chief complaint absent';
alter table temp_mental_health_chief_complaint_absent add index temp_mental_health_chief_complaint_absent_2 (encounter_id);

drop temporary table if exists temp_family_planning;
create temporary table temp_family_planning as select encounter_id, value_coded from omrs_obs where concept = 'Family planning';
alter table temp_family_planning add index temp_family_planning_encounter_idx (encounter_id);

drop temporary table if exists temp_phq_9_score;
create temporary table temp_phq_9_score as select encounter_id, value_numeric from omrs_obs where concept = 'PHQ 9 Score';
alter table temp_phq_9_score add index temp_phq_9_score_encounter_idx (encounter_id);

drop temporary table if exists temp_stable;
create temporary table temp_stable as select encounter_id, value_coded from omrs_obs where concept = 'Stable';
alter table temp_stable add index temp_stable_encounter_idx (encounter_id);

drop temporary table if exists temp_suicide_risk;
create temporary table temp_suicide_risk as select encounter_id, value_coded from omrs_obs where concept = 'Suicide risk';
alter table temp_suicide_risk add index temp_suicide_risk_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_is_patient_pregnant;
create temporary table temp_is_patient_pregnant as select encounter_id, value_coded from omrs_obs where concept = 'Is patient pregnant?';
alter table temp_is_patient_pregnant add index temp_is_patient_pregnant_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_group_counselling;
create temporary table temp_group_counselling as select encounter_id, value_coded from omrs_obs where concept = 'Group Counselling';
alter table temp_group_counselling add index temp_group_counselling_encounter_idx (encounter_id);

drop temporary table if exists temp_hospitalized_mental_health_since_last_visit;
create temporary table temp_hospitalized_mental_health_since_last_visit as select encounter_id, value_coded from omrs_obs where concept = 'Hospitalized for mental health since last visit';
alter table temp_hospitalized_mental_health_since_last_visit add index temp_hospitalized_mental_health_since_last_visit_2 (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from omrs_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_does_patient_have_adverse_effects;
create temporary table temp_does_patient_have_adverse_effects as select encounter_id, value_coded from omrs_obs where concept = 'Does patient have adverse effects';
alter table temp_does_patient_have_adverse_effects add index temp_does_patient_adverse_effects_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

insert into mw_mental_health_followup (patient_id, visit_date, location, med_carbamazepine_frequency, med_clopixol_frequency, med_clozapine_frequency, med_fluphenazine_frequency, med_haloperidol_frequency, med_sodium_valproate_frequency, med_sodium_valproate_route, med_trifluoperazine_frequency, able_to_do_daily_activities, med_amitriptyline_dose, med_amitriptyline_dosing_unit, med_amitriptyline_duration, med_amitriptyline_duration_units, med_amitriptyline_frequency, med_amitriptyline_route, med_carbamazepine_dose, med_carbamazepine_dosing_unit, med_carbamazepine_duration, med_carbamazepine_duration_units, med_carbamazepine_route, med_chloropromazine_dose, med_chloropromazine_dosing_unit, med_chloropromazine_duration, med_chloropromazine_duration_units, med_chloropromazine_frequency, med_chloropromazine_route, med_clopixol_dose, med_clopixol_dosing_unit, med_clopixol_duration, med_clopixol_duration_units, med_clopixol_route, med_clozapine_dose, med_clozapine_dosing_unit, med_clozapine_duration, med_clozapine_duration_units, med_clozapine_route, current_use_alcohol, med_fluoxetine_dose, med_fluoxetine_dosing_unit, med_fluoxetine_duration, med_fluoxetine_duration_units, med_fluoxetine_frequency, med_fluoxetine_route, med_fluphenazine_dose, med_fluphenazine_dosing_unit, med_fluphenazine_duration, med_fluphenazine_duration_units, med_fluphenazine_route, med_haloperidolp_dose, med_haloperidol_dosing_unit, med_haloperidol_duration, med_haloperidol_duration_units, med_haloperidol_route, mse_depressed_mood, mse_disorganized_speech, mse_disruptive_behaviour, mse_elevated_mood, mse_lack_of_insight, mse_delusions, mse_hallucinations, mse_other, med_olanzapine_dose, med_olanzapine_dosing_unit, med_olanzapine_duration, med_olanzapine_duration_units, med_olanzapine_frequency, med_olanzapine_route, on_family_planning, phq_nine_score, patient_stable, med_risperidone_dose, med_risperidone_dosing_unit, med_risperidone_duration, med_risperidone_duration_units, med_risperidone_frequency, med_risperidone_route, med_sodium_valproate_dose, med_sodium_valproate_dosing_unit, med_sodium_valproate_duration, med_sodium_valproate_duration_units, suicide_risk, med_trifluoperazine_dose, med_trifluoperazine_dosing_unit, med_trifluoperazine_duration, med_trifluoperazine_duration_units, med_trifluoperazine_route, comments, height, pregnant, weight, counselling_provided, hospitalized_since_last_visit, med_carbamazepine, med_chloropromazine, med_clopixol, med_clozapine, med_fluoxetine, med_fluphenazine, med_haloperidol, med_olanzapine, med_risperidone, med_sodium_valproate, med_trifluoperazine, med_amitriptyline, med_other, medications_side_effects, next_appointment_date, current_use_marijuana, current_use_other)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(drug_frequency_coded.value_coded) as med_carbamazepine_frequency,
    max(drug_frequency_coded.value_coded) as med_clopixol_frequency,
    max(drug_frequency_coded.value_coded) as med_clozapine_frequency,
    max(drug_frequency_coded.value_coded) as med_fluphenazine_frequency,
    max(drug_frequency_coded.value_coded) as med_haloperidol_frequency,
    max(drug_frequency_coded.value_coded) as med_sodium_valproate_frequency,
    max(routes_of_administration_coded.value_coded) as med_sodium_valproate_route,
    max(drug_frequency_coded.value_coded) as med_trifluoperazine_frequency,
    max(able_to_perform_daily_activities.value_coded) as able_to_do_daily_activities,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_amitriptyline_dose,
    max(dosing_unit.value_coded) as med_amitriptyline_dosing_unit,
    max(medication_duration.value_numeric) as med_amitriptyline_duration,
    max(time_units.value_coded) as med_amitriptyline_duration_units,
    max(drug_frequency_coded.value_coded) as med_amitriptyline_frequency,
    max(routes_of_administration_coded.value_coded) as med_amitriptyline_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_carbamazepine_dose,
    max(dosing_unit.value_coded) as med_carbamazepine_dosing_unit,
    max(medication_duration.value_numeric) as med_carbamazepine_duration,
    max(time_units.value_coded) as med_carbamazepine_duration_units,
    max(routes_of_administration_coded.value_coded) as med_carbamazepine_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_chloropromazine_dose,
    max(dosing_unit.value_coded) as med_chloropromazine_dosing_unit,
    max(medication_duration.value_numeric) as med_chloropromazine_duration,
    max(time_units.value_coded) as med_chloropromazine_duration_units,
    max(drug_frequency_coded.value_coded) as med_chloropromazine_frequency,
    max(routes_of_administration_coded.value_coded) as med_chloropromazine_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_clopixol_dose,
    max(dosing_unit.value_coded) as med_clopixol_dosing_unit,
    max(medication_duration.value_numeric) as med_clopixol_duration,
    max(time_units.value_coded) as med_clopixol_duration_units,
    max(routes_of_administration_coded.value_coded) as med_clopixol_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_clozapine_dose,
    max(dosing_unit.value_coded) as med_clozapine_dosing_unit,
    max(medication_duration.value_numeric) as med_clozapine_duration,
    max(time_units.value_coded) as med_clozapine_duration_units,
    max(routes_of_administration_coded.value_coded) as med_clozapine_route,
    max(history_of_alcohol_use.value_coded) as current_use_alcohol,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_fluoxetine_dose,
    max(dosing_unit.value_coded) as med_fluoxetine_dosing_unit,
    max(medication_duration.value_numeric) as med_fluoxetine_duration,
    max(time_units.value_coded) as med_fluoxetine_duration_units,
    max(drug_frequency_coded.value_coded) as med_fluoxetine_frequency,
    max(routes_of_administration_coded.value_coded) as med_fluoxetine_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_fluphenazine_dose,
    max(dosing_unit.value_coded) as med_fluphenazine_dosing_unit,
    max(medication_duration.value_numeric) as med_fluphenazine_duration,
    max(time_units.value_coded) as med_fluphenazine_duration_units,
    max(routes_of_administration_coded.value_coded) as med_fluphenazine_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_haloperidolp_dose,
    max(dosing_unit.value_coded) as med_haloperidol_dosing_unit,
    max(medication_duration.value_numeric) as med_haloperidol_duration,
    max(time_units.value_coded) as med_haloperidol_duration_units,
    max(routes_of_administration_coded.value_coded) as med_haloperidol_route,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Depressive Disorder' then mental_health_chief_complaint_absent.value_coded end) as mse_depressed_mood,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Abnormal speech' then mental_health_chief_complaint_absent.value_coded end) as mse_disorganized_speech,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Disruptive Behavior Disorder' then mental_health_chief_complaint_absent.value_coded end) as mse_disruptive_behaviour,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Hypomania' then mental_health_chief_complaint_absent.value_coded end) as mse_elevated_mood,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Lack of insight' then mental_health_chief_complaint_absent.value_coded end) as mse_lack_of_insight,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Delusions' then mental_health_chief_complaint_absent.value_coded end) as mse_delusions,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Hallucinations' then mental_health_chief_complaint_absent.value_coded end) as mse_hallucinations,
    max(case when mental_health_chief_complaint_absent.value_coded = 'Other non-coded' then mental_health_chief_complaint_absent.value_coded end) as mse_other,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_olanzapine_dose,
    max(dosing_unit.value_coded) as med_olanzapine_dosing_unit,
    max(medication_duration.value_numeric) as med_olanzapine_duration,
    max(time_units.value_coded) as med_olanzapine_duration_units,
    max(drug_frequency_coded.value_coded) as med_olanzapine_frequency,
    max(routes_of_administration_coded.value_coded) as med_olanzapine_route,
    max(family_planning.value_coded) as on_family_planning,
    max(phq_9_score.value_numeric) as phq_nine_score,
    max(stable.value_coded) as patient_stable,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_risperidone_dose,
    max(dosing_unit.value_coded) as med_risperidone_dosing_unit,
    max(medication_duration.value_numeric) as med_risperidone_duration,
    max(time_units.value_coded) as med_risperidone_duration_units,
    max(drug_frequency_coded.value_coded) as med_risperidone_frequency,
    max(routes_of_administration_coded.value_coded) as med_risperidone_route,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_sodium_valproate_dose,
    max(dosing_unit.value_coded) as med_sodium_valproate_dosing_unit,
    max(medication_duration.value_numeric) as med_sodium_valproate_duration,
    max(time_units.value_coded) as med_sodium_valproate_duration_units,
    max(suicide_risk.value_coded) as suicide_risk,
    max(quantity_of_medication_prescribed_per_dose.value_numeric) as med_trifluoperazine_dose,
    max(dosing_unit.value_coded) as med_trifluoperazine_dosing_unit,
    max(medication_duration.value_numeric) as med_trifluoperazine_duration,
    max(time_units.value_coded) as med_trifluoperazine_duration_units,
    max(routes_of_administration_coded.value_coded) as med_trifluoperazine_route,
    max(clinical_impression_comments.value_text) as comments,
    max(height_cm.value_numeric) as height,
    max(is_patient_pregnant.value_coded) as pregnant,
    max(weight_kg.value_numeric) as weight,
    max(group_counselling.value_coded) as counselling_provided,
    max(hospitalized_for_mental_health_since_last_visit.value_coded) as hospitalized_since_last_visit,
    max(case when current_drugs_used.value_coded = 'Carbamazepine' then current_drugs_used.value_coded end) as med_carbamazepine,
    max(case when current_drugs_used.value_coded = 'Chlorpromazine' then current_drugs_used.value_coded end) as med_chloropromazine,
    max(case when current_drugs_used.value_coded = 'Clopixol' then current_drugs_used.value_coded end) as med_clopixol,
    max(case when current_drugs_used.value_coded = 'Clozapine' then current_drugs_used.value_coded end) as med_clozapine,
    max(case when current_drugs_used.value_coded = 'Fluoxetine' then current_drugs_used.value_coded end) as med_fluoxetine,
    max(case when current_drugs_used.value_coded = 'Fluphenazine' then current_drugs_used.value_coded end) as med_fluphenazine,
    max(case when current_drugs_used.value_coded = 'Haloperidol' then current_drugs_used.value_coded end) as med_haloperidol,
    max(case when current_drugs_used.value_coded = 'Olanzapine' then current_drugs_used.value_coded end) as med_olanzapine,
    max(case when current_drugs_used.value_coded = 'Risperidone' then current_drugs_used.value_coded end) as med_risperidone,
    max(case when current_drugs_used.value_coded = 'Sodium valproate' then current_drugs_used.value_coded end) as med_sodium_valproate,
    max(case when current_drugs_used.value_coded = 'Trifluoperazine' then current_drugs_used.value_coded end) as med_trifluoperazine,
    max(case when current_drugs_used.value_coded = 'Amitriptyline' then current_drugs_used.value_coded end) as med_amitriptyline,
    max(null) as med_other,
    max(does_patient_have_adverse_effects.value_coded) as medications_side_effects,
    max(appointment_date.value_date) as next_appointment_date,
    max(case when og.concept = 'Marijuana use construct' then o.value_coded end) as current_use_marijuana,
    max(case when og.concept = 'Drug use construct' then o.value_coded end) as current_use_other
from omrs_encounter e
left join temp_drug_frequency_coded drug_frequency_coded on e.encounter_id = drug_frequency_coded.encounter_id
left join temp_routes_of_administration_coded routes_of_administration_coded on e.encounter_id = routes_of_administration_coded.encounter_id
left join temp_able_to_perform_daily_activities able_to_perform_daily_activities on e.encounter_id = able_to_perform_daily_activities.encounter_id
left join temp_quantity_of_medication_prescribed_per_dose quantity_of_medication_prescribed_per_dose on e.encounter_id = quantity_of_medication_prescribed_per_dose.encounter_id
left join temp_dosing_unit dosing_unit on e.encounter_id = dosing_unit.encounter_id
left join temp_medication_duration medication_duration on e.encounter_id = medication_duration.encounter_id
left join temp_time_units time_units on e.encounter_id = time_units.encounter_id
left join temp_history_of_alcohol_use history_of_alcohol_use on e.encounter_id = history_of_alcohol_use.encounter_id
left join temp_mental_health_chief_complaint_absent mental_health_chief_complaint_absent on e.encounter_id = mental_health_chief_complaint_absent.encounter_id
left join temp_family_planning family_planning on e.encounter_id = family_planning.encounter_id
left join temp_phq_9_score phq_9_score on e.encounter_id = phq_9_score.encounter_id
left join temp_stable stable on e.encounter_id = stable.encounter_id
left join temp_suicide_risk suicide_risk on e.encounter_id = suicide_risk.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_is_patient_pregnant is_patient_pregnant on e.encounter_id = is_patient_pregnant.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_group_counselling group_counselling on e.encounter_id = group_counselling.encounter_id
left join temp_hospitalized_mental_health_since_last_visit hospitalized_for_mental_health_since_last_visit on e.encounter_id = hospitalized_for_mental_health_since_last_visit.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_does_patient_have_adverse_effects does_patient_have_adverse_effects on e.encounter_id = does_patient_have_adverse_effects.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join omrs_obs o on o.encounter_id = e.encounter_id
left join omrs_obs_group og on og.obs_group_id = o.obs_group_id
where e.encounter_type in ('MENTAL_HEALTH_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;
