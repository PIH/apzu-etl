create table mw_nutrition_infant_followup (
nutrition_infant_followup_id int not null auto_increment,
patient_id int not null,
visit_date date,
location varchar(255),
weight decimal(10,2),
height decimal(10,2),
muac decimal(10,2),
lactogen_tins varchar(255),
next_appointment_date date,
ration varchar(255),
comments varchar(255),
primary key (nutrition_infant_followup_id)
);
