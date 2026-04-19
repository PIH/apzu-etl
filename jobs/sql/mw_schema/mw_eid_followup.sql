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
