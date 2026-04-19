create table mw_poc_htc (
    poc_htc_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    result_of_hiv_test_htc varchar(255),
    hiv_test_type_htc varchar(255),    
    primary key (poc_htc_visit_id)
);
