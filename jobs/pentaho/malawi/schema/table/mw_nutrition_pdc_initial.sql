CREATE TABLE mw_nutrition_pdc_initial (
    nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    enrollment_reason VARCHAR(255),
    PRIMARY KEY (nutrition_initial_visit_id)
);
