CREATE TABLE mw_nutrition_infant_followup (
nutrition_infant_followup_id INT NOT NULL AUTO_INCREMENT,
patient_id INT NOT NULL,
visit_date DATE,
location VARCHAR(255),
weight DECIMAL(10,2),
height DECIMAL(10,2),
muac DECIMAL(10,2),
lactogen_tins VARCHAR(255),
next_appointment_date DATE,
ration VARCHAR(255),
comments VARCHAR(255),
PRIMARY KEY (nutrition_infant_followup_id)
);
