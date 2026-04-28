CREATE TABLE mw_poc_tb_screening (
    poc_tb_screening_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    creator VARCHAR(255),
    symptom_present VARCHAR(255),
    symptom_absent VARCHAR(255),
    PRIMARY KEY (poc_tb_screening_visit_id)
);
