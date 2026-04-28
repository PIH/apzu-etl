CREATE TABLE mw_nutrition_teen_followup (
    nutrition_followup_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    weight DECIMAL(10 , 2 ),
    height DECIMAL(10 , 2 ),
    muac DECIMAL(10 , 2 ),
    oil DECIMAL(10 , 2 ),
    maize DECIMAL(10 , 2 ),
    beans DECIMAL(10 , 2 ),
    next_appointment DATE,
    warehouse_signature VARCHAR(255),
    comments VARCHAR(255),
    PRIMARY KEY (nutrition_followup_visit_id)
);
