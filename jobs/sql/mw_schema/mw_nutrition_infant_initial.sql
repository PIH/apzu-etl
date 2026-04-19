create table mw_nutrition_infant_initial (
nutrition_initial_visit_id int not null auto_increment,
patient_id int not null,
visit_date date,
location varchar(255),
enrollment_reason_severe_maternal_illness varchar(255),
enrollment_reason_multiple_births varchar(255),
enrollment_reason_maternal_death varchar(255),
enrollment_reason_other varchar(255),
primary key (nutrition_initial_visit_id)
);
