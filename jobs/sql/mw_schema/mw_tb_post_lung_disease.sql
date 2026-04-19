create table mw_tb_post_lung_disease (
  tb_post_lung_disease_visit_id 		int not null auto_increment,
  patient_id    				int not null,
  visit_date            		date,
  location              		varchar(255),
  number_of_weeks 					int,
  second_visit_date 		date,
     primary key (tb_post_lung_disease_visit_id)
);
