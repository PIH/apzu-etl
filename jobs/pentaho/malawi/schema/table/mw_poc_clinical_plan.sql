CREATE TABLE mw_poc_clinical_plan (
    poc_clinical_plan_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    appointment_date DATE,
    qualitative_time VARCHAR(255),
    outcome VARCHAR(255),
    clinical_impression_comments VARCHAR(500),
    refer_to_screening_station VARCHAR(255),
    transfer_out_to VARCHAR(255),
    reason_to_stop_care VARCHAR(255),
    PRIMARY KEY (poc_clinical_plan_visit_id)
);
