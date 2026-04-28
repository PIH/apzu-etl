CREATE TABLE mw_poc_bp (
    poc_bp_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    diastolic_blood_pressure DECIMAL(10,2),
    pulse DECIMAL(10,2),
    systolic_blood_pressure DECIMAL(10,2),
    PRIMARY KEY (poc_bp_visit_id)
);
