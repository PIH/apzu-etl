CREATE TABLE mw_poc_viral_load_screening (
    poc_viral_load_screening_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    creator VARCHAR(255),
    sample_taken_for_viral_load VARCHAR(255),
    lower_than_detection_limit VARCHAR(255),
    reason_for_testing VARCHAR(255),
    lab_location VARCHAR(255),
    less_than_limit VARCHAR(255),
    reason_for_no_result VARCHAR(255),
    viral_load_sample_id VARCHAR(255),
    reason_for_no_sample VARCHAR(255),
    lab_id VARCHAR(255),
    symptom_present VARCHAR(255),
    symptom_absent VARCHAR(255),
    PRIMARY KEY (poc_viral_load_screening_visit_id)
);
