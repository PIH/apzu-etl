create table mw_art_followup_testing (
  art_followup_testing_visit_id int not null auto_increment,
  patient_id int(11) not null,
  visit_date date null default null,
  location varchar(255) null default null,
  cd4_count int null default null,
  cd4_pct int null default null,
  serum_glucose int null default null,
  phq_nine_score int null,
  test_type varchar(255) null default null,
  primary key (art_followup_testing_visit_id));

