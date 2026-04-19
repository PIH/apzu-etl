create table mw_nutrition_teen_followup (
    nutrition_followup_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    weight decimal(10 , 2 ),
    height decimal(10 , 2 ),
    muac decimal(10 , 2 ),
    oil decimal(10 , 2 ),
    maize decimal(10 , 2 ),
    beans decimal(10 , 2 ),
    next_appointment date,
    warehouse_signature varchar(255),
    comments varchar(255),
    primary key (nutrition_followup_visit_id)
);
