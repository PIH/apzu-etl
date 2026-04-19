
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
