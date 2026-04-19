create table mw_poc_tb_screening (
    poc_tb_screening_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    creator varchar(255),
    symptom_present varchar(255),
    symptom_absent varchar(255),
    primary key (poc_tb_screening_visit_id)
);
