create table mw_poc_bp (
    poc_bp_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    diastolic_blood_pressure decimal(10,2),
    pulse decimal(10,2),
    systolic_blood_pressure decimal(10,2),
    primary key (poc_bp_visit_id)
);
