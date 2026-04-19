drop function if exists nextStateForEnrollment#
create function nextStateForEnrollment(enrollmentId int, startingDate date)
  returns varchar(100)
deterministic
  begin
    declare ret varchar(100);

    if startingDate is not null then
      select    s.state into ret
      from      omrs_program_state s
      where     s.program_enrollment_id = enrollmentId
      and       s.start_date >= startingDate
      order by  s.start_date asc
      limit 1;
    end if;

    return ret;
  end
#