drop table if exists mw_art_trace;
create table mw_art_trace (
  patient_id                        int not null,
  location                          varchar(255),
  art_number                        varchar(50),
  last_visit_date                   date,
  next_appointment_date             date,
  last_viral_load_result_date       date,
  last_viral_load_result_numeric    decimal(10,2),
  last_viral_load_result_exception  varchar(100),
  last_viral_load_test_date         date
);

-- Active ART patients with last visit and viral load info
insert into mw_art_trace (patient_id, location, art_number, last_visit_date, next_appointment_date, last_viral_load_result_date, last_viral_load_result_numeric, last_viral_load_result_exception, last_viral_load_test_date)
select
    r.patient_id,
    r.location,
    r.art_number,
    v.visit_date as last_visit_date,
    v.next_appointment_date,
    vr.date_collected as last_viral_load_result_date,
    vr.result_numeric as last_viral_load_result_numeric,
    vr.result_exception as last_viral_load_result_exception,
    vt.date_collected as last_viral_load_test_date
from mw_art_register r
inner join mw_patient p on r.patient_id = p.patient_id
left join mw_art_visits v on v.art_visit_id = r.last_art_visit_id
left join mw_lab_tests vt on vt.lab_test_id = r.last_viral_load_test_id
left join mw_lab_tests vr on vr.lab_test_id = r.last_viral_load_result_id
where r.end_date is null;
