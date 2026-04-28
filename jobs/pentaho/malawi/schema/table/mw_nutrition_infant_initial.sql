CREATE TABLE mw_nutrition_infant_initial (
nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
patient_id INT NOT NULL,
visit_date DATE,
location VARCHAR(255),
enrollment_reason_severe_maternal_illness VARCHAR(255),
enrollment_reason_multiple_births VARCHAR(255),
enrollment_reason_maternal_death VARCHAR(255),
enrollment_reason_other VARCHAR(255),
PRIMARY KEY (nutrition_initial_visit_id)
);
