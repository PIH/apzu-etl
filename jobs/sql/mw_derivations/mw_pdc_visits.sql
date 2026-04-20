-- Derivation script for mw_pdc_visits
-- Generated from Pentaho transform: import-into-mw-pdc-visits.ktr

drop table if exists mw_pdc_visits;
create table mw_pdc_visits (
  pdc_visit_id                      int not null auto_increment primary key,
  patient_id                        int not null,
  visit_date                        date,
  location                          varchar(255),
  visit_types                       varchar(255),
  pdc_initial          	     boolean,
  pdc_cleft_clip_palate_initial     boolean,
  pdc_cleft_clip_palate_followup    boolean,
  pdc_developmental_delay_initial   boolean,
  pdc_developmental_delay_followup  boolean,
  pdc_other_diagnosis_initial       boolean,
  pdc_other_diagnosis_followup      boolean,
  pdc_trisomy21_initial      	     boolean,
  pdc_trisomy21_followup  	     boolean,
  next_appointment_date             date
);
alter table mw_pdc_visits add index mw_pdc_visit_patient_idx (patient_id);
alter table mw_pdc_visits add index mw_pdc_visit_patient_location_idx (patient_id, location);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

insert into mw_pdc_visits (patient_id, visit_date, location, visit_types, pdc_initial, pdc_cleft_clip_palate_initial, pdc_cleft_clip_palate_followup, pdc_developmental_delay_initial, pdc_developmental_delay_followup, pdc_other_diagnosis_initial, pdc_other_diagnosis_followup, pdc_trisomy21_initial, pdc_trisomy21_followup, next_appointment_date)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    group_concat(distinct e.encounter_type order by e.encounter_type asc SEPARATOR ', ') as visit_types,
    max(case when e.encounter_type = 'PDC_INITIAL' then TRUE else FALSE end) as pdc_initial,
    max(case when e.encounter_type = 'PDC_CLEFT_CLIP_PALLET_INITIAL' then TRUE else FALSE end) as pdc_cleft_clip_palate_initial,
    max(case when e.encounter_type = 'PDC_CLEFT_CLIP_PALLET_FOLLOWUP' then TRUE else FALSE end) as pdc_cleft_clip_palate_followup,
    max(case when e.encounter_type = 'PDC_DEVELOPMENTAL_DELAY_INITIAL' then TRUE else FALSE end) as pdc_developmental_delay_initial,
    max(case when e.encounter_type = 'PDC_DEVELOPMENTAL_DELAY_FOLLOWUP' then TRUE else FALSE end) as pdc_developmental_delay_followup,
    max(case when e.encounter_type = 'PDC_OTHER_DIAGNOSIS_INITIAL' then TRUE else FALSE end) as pdc_other_diagnosis_initial,
    max(case when e.encounter_type = 'PDC_OTHER_DIAGNOSIS_FOLLOWUP' then TRUE else FALSE end) as pdc_other_diagnosis_followup,
    max(case when e.encounter_type = 'PDC_TRISOMY21_INITIAL' then TRUE else FALSE end) as pdc_trisomy21_initial,
    max(case when e.encounter_type = 'PDC_TRISOMY21_FOLLOWUP' then TRUE else FALSE end) as pdc_trisomy21_followup,
    min(appointment_date.value_date) as next_appointment_date
from omrs_encounter e
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
where e.encounter_type in (
    'PDC_INITIAL',
    'PDC_CLEFT_CLIP_PALLET_INITIAL',
    'PDC_CLEFT_CLIP_PALLET_FOLLOWUP',
    'PDC_DEVELOPMENTAL_DELAY_INITIAL',
    'PDC_DEVELOPMENTAL_DELAY_FOLLOWUP',
    'PDC_OTHER_DIAGNOSIS_INITIAL',
    'PDC_OTHER_DIAGNOSIS_FOLLOWUP',
    'PDC_TRISOMY21_INITIAL',
    'PDC_TRISOMY21_FOLLOWUP'
)
group by e.patient_id, e.encounter_date, e.location;
