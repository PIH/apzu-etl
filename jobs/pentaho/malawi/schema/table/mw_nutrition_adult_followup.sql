CREATE TABLE mw_nutrition_adult_followup (
    nutrition_adult_followup_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    weight DECIMAL(10 , 2 ),
    height DECIMAL(10 , 2 ),
    bmi DECIMAL(10 , 2 ),
    food_likuni_phala DECIMAL(10 , 2 ),
    next_appointment DATE,
    warehouse_signature VARCHAR(255),
    comments VARCHAR(255),
    PRIMARY KEY (nutrition_adult_followup_visit_id)
);
