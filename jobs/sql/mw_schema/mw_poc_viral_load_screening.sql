create table mw_poc_viral_load_screening (
    poc_viral_load_screening_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    creator varchar(255),
    sample_taken_for_viral_load varchar(255),
    lower_than_detection_limit varchar(255),
    reason_for_testing varchar(255),
    lab_location varchar(255),
    less_than_limit varchar(255),
    reason_for_no_result varchar(255),
    viral_load_sample_id varchar(255),
    reason_for_no_sample varchar(255),
    lab_id varchar(255),
    symptom_present varchar(255),
    symptom_absent varchar(255),
    primary key (poc_viral_load_screening_visit_id)
);
