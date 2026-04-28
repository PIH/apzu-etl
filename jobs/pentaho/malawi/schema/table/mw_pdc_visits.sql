
create table mw_pdc_visits (
  pdc_visit_id                      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  patient_id                        INT NOT NULL,
  visit_date                        DATE,
  location                          VARCHAR(255),
  visit_types                       VARCHAR(255),
  pdc_initial          	     BOOLEAN,
  pdc_cleft_clip_palate_initial     BOOLEAN,
  pdc_cleft_clip_palate_followup    BOOLEAN,
  pdc_developmental_delay_initial   BOOLEAN,
  pdc_developmental_delay_followup  BOOLEAN,
  pdc_other_diagnosis_initial       BOOLEAN,
  pdc_other_diagnosis_followup      BOOLEAN,
  pdc_trisomy21_initial      	     BOOLEAN,
  pdc_trisomy21_followup  	     BOOLEAN,
  next_appointment_date             DATE
);
alter table mw_pdc_visits add index mw_pdc_visit_patient_idx (patient_id);
alter table mw_pdc_visits add index mw_pdc_visit_patient_location_idx (patient_id, location);
