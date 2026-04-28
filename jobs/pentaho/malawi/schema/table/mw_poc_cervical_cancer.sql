CREATE TABLE mw_poc_cervical_cancer (
    poc_cervical_cancer_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id int NOT NULL,
    visit_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    creator varchar(255) DEFAULT NULL,
    colposcopy_of_cervix_with_acetic_acid VARCHAR(255),
    PRIMARY KEY (poc_cervical_cancer_visit_id)
);
