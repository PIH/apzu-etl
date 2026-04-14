CREATE TABLE mw_poc_nutrition (
    poc_nutrition_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    height DECIMAL(10,2),
    weight DECIMAL(10,2),
    is_patient_preg VARCHAR(255),
    muac VARCHAR(255),
    PRIMARY KEY (poc_nutrition_visit_id)
);
