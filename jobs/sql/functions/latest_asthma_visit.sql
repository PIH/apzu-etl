drop function if exists latest_asthma_visit#
/*
  Extract the ncd_visit_id that identifies the most recent asthma visit
*/
create function latest_asthma_visit(patientId int, endDate date)
  returns int
deterministic
  begin
    declare ret int;

    select    v.ncd_visit_id into ret
    from      mw_ncd_visits v
    where     v.patient_id = patientId
    and       (v.asthma_initial = TRUE || v.asthma_followup = TRUE)
    and       v.visit_date <= endDate
    order by  v.visit_date desc
    limit     1;

    return ret;
  end
#
