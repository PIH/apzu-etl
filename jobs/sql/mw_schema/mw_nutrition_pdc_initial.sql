create table mw_nutrition_pdc_initial (
    nutrition_initial_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    enrollment_reason_martenal_death varchar(255),
    enrollment_reason_malnutrition varchar(255),
    enrollment_reason_poser_support varchar(255),
    enrollment_reason_other varchar(255),
    primary key (nutrition_initial_visit_id)
);
