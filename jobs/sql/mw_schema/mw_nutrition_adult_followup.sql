create table mw_nutrition_adult_followup (
    nutrition_adult_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    weight decimal(10 , 2 ),
    height decimal(10 , 2 ),
    bmi decimal(10 , 2 ),
    food_likuni_phala decimal(10 , 2 ),
    next_appointment date,
    warehouse_signature varchar(255),
    comments varchar(255),
    primary key (nutrition_adult_followup_visit_id)
);
