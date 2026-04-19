drop function if exists latest_test_result_by_date_entered#
/*
  Extract the lab_test_id that identifies the most recent test result of the given type for the given patient
*/
create function latest_test_result_by_date_entered(patientId int, testType varchar(100), fromDate date, toDate date, offsetNum int)
  returns int
deterministic
  begin
    declare ret int;

    select    t.lab_test_id into ret
    from      mw_lab_tests t
    where     t.patient_id = patientId
    and       t.test_type = testType
    and       (t.result_numeric is not null or t.result_coded is not null or t.result_exception is not null)
    and       (fromDate is null or t.date_result_entered >= fromDate)
    and       (toDate is null or t.date_result_entered <= toDate)
    order by  t.date_result_entered desc
    limit     1
    offset    offsetNum;

    return ret;
  end
#
