create table mw_poc_cervical_cancer (
    poc_cervical_cancer_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date default null,
    location varchar(255) default null,
    creator varchar(255) default null,
    colposcopy_of_cervix_with_acetic_acid varchar(255),
    primary key (poc_cervical_cancer_visit_id)
);
