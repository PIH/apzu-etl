CREATE TABLE mw_poc_htc (
    poc_htc_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    result_of_hiv_test_htc VARCHAR(255),
    hiv_test_type_htc VARCHAR(255),    
    PRIMARY KEY (poc_htc_visit_id)
);
