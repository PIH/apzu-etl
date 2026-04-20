-- Derivation script for mw_eid_followup
-- Generated from Pentaho transform: import-into-mw-eid-followup.ktr

drop table if exists mw_eid_followup;
create table mw_eid_followup (
  eid_followup_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  height int default null,
  weight int default null,
  muac decimal(16,4) default null,
  wasting_or_malnutrition varchar(255) default null,
  breast_feeding varchar(255) default null,
  mother_status varchar(255) default null,
  clinical_monitoring varchar(255) default null,
  hiv_infection varchar(255) default null,
  cpt int default null,
  next_appointment_date date default null,
  primary key (eid_followup_visit_id)
);

drop temporary table if exists temp_breast_feeding;
create temporary table temp_breast_feeding as select encounter_id, value_coded from omrs_obs where concept = 'Breast feeding';
alter table temp_breast_feeding add index temp_breast_feeding_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_monitoring_exposed_child;
create temporary table temp_clinical_monitoring_exposed_child as select encounter_id, value_coded from omrs_obs where concept = 'Clinical Monitoring Exposed Child';
alter table temp_clinical_monitoring_exposed_child add index temp_clinical_monitoring_exposed_child_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_hiv_status;
create temporary table temp_mother_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'Mother HIV Status';
alter table temp_mother_hiv_status add index temp_mother_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_wasting_malnutrition;
create temporary table temp_wasting_malnutrition as select encounter_id, value_coded from omrs_obs where concept = 'Wasting/malnutrition';
alter table temp_wasting_malnutrition add index temp_wasting_malnutrition_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_cpt_tablets_dispensed;
create temporary table temp_number_of_cpt_tablets_dispensed as select encounter_id, value_numeric from omrs_obs where concept = 'Number of CPT tablets dispensed';
alter table temp_number_of_cpt_tablets_dispensed add index temp_number_of_cpt_tablets_dispensed_encounter_idx (encounter_id);

drop temporary table if exists temp_childs_current_hiv_status;
create temporary table temp_childs_current_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'Childs current HIV status';
alter table temp_childs_current_hiv_status add index temp_childs_current_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter_idx (encounter_id);

insert into mw_eid_followup
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(breast_feeding.value_coded) as breast_feeding,
    max(clinical_monitoring_exposed_child.value_coded) as clinical_monitoring,
    max(height_cm.value_numeric) as height,
    max(mother_hiv_status.value_coded) as mother_status,
    max(appointment_date.value_date) as next_appointment_date,
    max(wasting_malnutrition.value_coded) as wasting_or_malnutrition,
    max(weight_kg.value_numeric) as weight,
    max(number_of_cpt_tablets_dispensed.value_numeric) as cpt,
    max(childs_current_hiv_status.value_coded) as hiv_infection,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac
from omrs_encounter e
left join temp_breast_feeding breast_feeding on e.encounter_id = breast_feeding.encounter_id
left join temp_clinical_monitoring_exposed_child clinical_monitoring_exposed_child on e.encounter_id = clinical_monitoring_exposed_child.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_mother_hiv_status mother_hiv_status on e.encounter_id = mother_hiv_status.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_wasting_malnutrition wasting_malnutrition on e.encounter_id = wasting_malnutrition.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
left join temp_number_of_cpt_tablets_dispensed number_of_cpt_tablets_dispensed on e.encounter_id = number_of_cpt_tablets_dispensed.encounter_id
left join temp_childs_current_hiv_status childs_current_hiv_status on e.encounter_id = childs_current_hiv_status.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
where e.encounter_type in ('EXPOSED_CHILD_FOLLOWUP')
group by e.patient_id, e.encounter_date, e.location;