create table mw_poc_clinical_plan (
    poc_clinical_plan_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    appointment_date date,
    qualitative_time varchar(255),
    outcome varchar(255),
    clinical_impression_comments varchar(500),
    refer_to_screening_station varchar(255),
    transfer_out_to varchar(255),
    reason_to_stop_care varchar(255),
    primary key (poc_clinical_plan_visit_id)
);
