create table mw_poc_adherence_counseling (
    poc_adherence_counseling_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    adherence_session_number varchar(255),
    name_of_support_provider varchar(255),
    number_of_missed_medication_doses_in_past_week varchar(255),
    viral_load_counseling varchar(255),
    medication_adherence_percent varchar(255),
    adherence_counselling varchar(255),
    primary key (poc_adherence_counseling_visit_id)
);