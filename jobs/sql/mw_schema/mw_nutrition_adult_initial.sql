drop table if exists mw_nutrition_adult_initial;
create table mw_nutrition_adult_initial (
    nutrition_initial_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    enrollment_reason_tb varchar(255),
    enrollment_reason_hiv varchar(255),
    enrollment_reason_ncd varchar(255),
    primary key (nutrition_initial_visit_id));
