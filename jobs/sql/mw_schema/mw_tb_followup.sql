create table mw_tb_followup (
  tb_followup_visit_id 			int not null auto_increment,
  patient_id    				int not null,
  visit_date            		date,
  location              		varchar(255),
  rhze_regimen 					int,
  rh_regimen 					int,
  meningitis_regimen			int,
  next_appointment_date 		date,
     primary key (tb_followup_visit_id)
);
