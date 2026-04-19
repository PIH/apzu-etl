drop function if exists latest_test_result_by_sample_date#
/*
  Extract the lab_test_id that identifies the most recent test result of the given type for the given patient
*/
create function latest_test_result_by_sample_date(patientId int, testType varchar(100), fromDate date, toDate date, offsetNum int)
  returns int
deterministic
  begin
    declare ret int;

    select    t.lab_test_id into ret
    from      mw_lab_tests t
    where     t.patient_id = patientId
    and       t.test_type = testType
    and       (fromDate is null or t.date_collected >= fromDate)
    and       (toDate is null or t.date_collected <= toDate)
    order by  t.date_collected desc
    limit     1
    offset    offsetNum;

    return ret;
  end
#
