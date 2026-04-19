drop function if exists first_date_no_breastfeeding#
/*
	Extract date on which patient first stopped breastfeeding over 6 weeks ago
	For all patients in the register, first recorded breastfeeding status obs date, if the value is stopped over 6 weeks ago,
	and after any other different status is recorded.
	We intentionally do not restrict this by location, as we want Observations to span all locations
*/
create function first_date_no_breastfeeding(patientId int, endDate date)
  returns date
deterministic
  begin
    declare ret date;

    declare lastInvalidDate date;

    select  max(visit_date) into lastInvalidDate
    from 		mw_eid_visits
    where   breastfeeding_status != 'Breastfeeding stopped over 6 weeks ago'
    and     patient_id = patientId
    and     visit_date <= endDate;

    select  min(visit_date) into ret
    from 		mw_eid_visits
    where   breastfeeding_status = 'Breastfeeding stopped over 6 weeks ago'
    and     patient_id = patientId
    and     (lastInvalidDate is null or (visit_date <= endDate and visit_date <= lastInvalidDate));

    return ret;
  end
#
