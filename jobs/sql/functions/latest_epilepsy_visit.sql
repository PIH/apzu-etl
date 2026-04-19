drop function if exists latest_epilepsy_visit#
/*
  Extract the ncd_visit_id that identifies the most recent epilepsy visit
*/
create function latest_epilepsy_visit(patientId int, endDate date)
  returns int
deterministic
  begin
    declare ret int;

    select    v.ncd_visit_id into ret
    from      mw_ncd_visits v
    where     v.patient_id = patientId
    and       (v.epilepsy_initial = TRUE || v.epilepsy_followup = TRUE)
    and       v.visit_date <= endDate
    order by  v.visit_date desc
    limit     1;

    return ret;
  end
#
