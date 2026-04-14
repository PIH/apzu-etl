CREATE TABLE mw_poc_adherence_counseling (
    poc_adherence_counseling_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    adherence_session_number VARCHAR(255),
    name_of_support_provider VARCHAR(255),
    number_of_missed_medication_doses_in_past_week VARCHAR(255),
    viral_load_counseling VARCHAR(255),
    medication_adherence_percent VARCHAR(255),
    adherence_counselling VARCHAR(255),
    PRIMARY KEY (poc_adherence_counseling_visit_id)
);