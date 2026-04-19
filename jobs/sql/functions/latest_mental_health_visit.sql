drop function if exists latest_mental_health_visit#
/*
  Extract the ncd_visit_id that identifies the most recent mental health visit
*/
create function latest_mental_health_visit(patientId int, endDate date)
  returns int
deterministic
  begin
    declare ret int;

    select    v.ncd_visit_id into ret
    from      mw_ncd_visits v
    where     v.patient_id = patientId
    and       (v.mental_health_initial = TRUE || v.mental_health_followup = TRUE)
    and       v.visit_date <= endDate
    order by  v.visit_date desc
    limit     1;

    return ret;
  end
#
