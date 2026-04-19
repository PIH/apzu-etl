drop function if exists first_test_result_by_date_entered#
/*
  Extract the lab_test_id that identifies the first test result of the given type for the given patient
*/
create function first_test_result_by_date_entered(patientId int, testType varchar(100), endDate date)
  returns int
deterministic
  begin
    declare ret int;

    select    t.lab_test_id into ret
    from      mw_lab_tests t
    where     t.patient_id = patientId
    and       t.test_type = testType
    and       (t.result_numeric is not null or t.result_coded is not null or t.result_exception is not null)
    and       (endDate is null or t.date_result_entered <= endDate)
    order by  t.date_result_entered asc
    limit     1;

    return ret;
  end
#
