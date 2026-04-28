CREATE TABLE mw_poc_checkin (
  poc_checkin_visit_id int NOT NULL AUTO_INCREMENT,
  patient_id int NOT NULL,
  visit_date date DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  creator varchar(255) DEFAULT NULL,
  PRIMARY KEY (poc_checkin_visit_id)
);
