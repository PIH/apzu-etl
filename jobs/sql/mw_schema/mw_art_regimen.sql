
create table mw_art_regimen (
  patient_id           int not null,
  regimen			   varchar(255),
  regimen_init_date    date,
  num_of_prev_regimens int,
  regimen_end_date	   date,
  line			       varchar(100)
);
