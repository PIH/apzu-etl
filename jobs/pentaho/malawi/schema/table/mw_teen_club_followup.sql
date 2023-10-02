CREATE TABLE mw_teen_club_followup (
    teen_club_followup_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    height DECIMAL(10 , 2 ),
    weight DECIMAL(10 , 2 ),
    muac_bmi DECIMAL(10 , 2 ),
    tb_status VARCHAR(255),
    sputum_collected VARCHAR(255),
    nutrition_screening_for_normal_muac VARCHAR(255),
    nutrition_referred VARCHAR(255),
    sti_screening_outcome VARCHAR(255),
    referred_to_sti_clinic VARCHAR(255),
    hospitalized VARCHAR(255),
    next_appointment DATE,
    PRIMARY KEY (teen_club_followup_visit_id)
);
