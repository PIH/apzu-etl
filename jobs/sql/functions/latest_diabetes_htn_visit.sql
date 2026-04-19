drop function if exists latest_diabetes_htn_visit#
/*
  Extract the ncd_visit_id that identifies the most recent diabetes_htn visit
*/
create function latest_diabetes_htn_visit(patientId int, endDate date)
  returns int
deterministic
  begin
    declare ret int;

    select    v.ncd_visit_id into ret
    from      mw_ncd_visits v
    where     v.patient_id = patientId
    and       (v.diabetes_htn_initial = TRUE || v.diabetes_htn_followup = TRUE)
    and       v.visit_date <= endDate
    order by  v.visit_date desc
    limit     1;

    return ret;
  end
#
