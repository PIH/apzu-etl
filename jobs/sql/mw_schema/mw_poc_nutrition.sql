create table mw_poc_nutrition (
    poc_nutrition_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    height decimal(10,2),
    weight decimal(10,2),
    is_patient_preg varchar(255),
    muac varchar(255),
    primary key (poc_nutrition_visit_id)
);
