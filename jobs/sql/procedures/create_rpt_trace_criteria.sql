drop procedure if exists create_rpt_trace_criteria#
/************************************************************************
  Get the trace criteria for each patient
*************************************************************************/
create procedure create_rpt_trace_criteria(in _endDate date, in _location varchar(255), in _minWks int, in _labWks int, in _maxWks int, in _phase1Only boolean) begin

  drop TEMPORARY table if exists rpt_trace_criteria;
  create TEMPORARY table rpt_trace_criteria (
    patient_id        int not null,
    criteria          varchar(50)
  );
  create index rpt_trace_criteria_patient_id_idx on rpt_trace_criteria(patient_id);

  -- Late ART
  insert into rpt_trace_criteria(patient_id, criteria)
    select  patient_id, 'LATE_ART'
    from    rpt_active_art
    where   days_late_appt is not null
    and     days_late_appt >= (_minWks*7)
    and     (_maxWks is null or days_late_appt < (_maxWks*7))
  ;

  -- Late EID
  insert into rpt_trace_criteria(patient_id, criteria)
    select  patient_id, 'LATE_EID'
    from    rpt_active_eid
    where   days_late_appt is not null
    and     days_late_appt >= (_minWks*7)
    and     (_maxWks is null or days_late_appt < (_maxWks*7))
  ;

  -- High Viral Load
  -- 2 wk: Active patients who have a viral load > 1000 with entry date <= 56 days
  -- 6 wk: Active patients who have a viral load > 1000 and no subsequent visit
  insert into   rpt_trace_criteria(patient_id, criteria)
    select      r.patient_id, 'HIGH_VIRAL_LOAD'
    from        rpt_active_art r
    inner join  mw_lab_tests t on r.patient_id = t.patient_id
    where       t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'Viral Load', null, _endDate, 0)
    and         (
                  ( _minWks != 6 and
                    datediff(_endDate, t.date_result_entered) <= 42+7*_labWks and
                    t.result_numeric > 1000
                  )
                  or
                  ( _minWks = 6 and
                    t.result_numeric > 1000 and
                    t.date_result_entered > r.last_visit_date
                  )
                )
  ;

  -- EID Positive 6 week
  -- Active in EID and
  -- 2wk:  6wk eid test result is positive AND today-lastEidTestResultDate <= 56d
  -- 6wk:  6wk eid test result is positive AND no visit since lastEidTestResultDate
  -- TODO: My assumption is that the 6 week test result is the first test result.  Confirm this.
  -- (eg:  patient only has 1 test result, it was positive, and it was recorded within
  -- the last 14 days (2 wk) or last 56 days with no subsequent visit (6 wk))

  insert into   rpt_trace_criteria(patient_id, criteria)
    select      r.patient_id, 'EID_POSITIVE_6_WK'
    from        rpt_active_eid r
    inner join  mw_lab_tests t on r.patient_id = t.patient_id
    where       t.lab_test_id = first_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', _endDate)
    and         t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', null, _endDate, 0)
    and         (
                  ( _minWks != 6 and
                    datediff(_endDate, t.date_result_entered) <= 42+7*_labWks and
                    t.result_coded = 'Positive'
                  )
                  or
                  ( _minWks = 6 and
                    t.result_coded = 'Positive' and
                    t.date_result_entered > r.last_visit_date
                  )
                )
  ;

  if _minWks != 6 then

    -- REPEAT_VIRAL_LOAD
    --  Active HIV
    --  Has viral load > 1000, it was entered [84, 168) days ago, patient _has_ visited since, and patient has appointment 2-4 weeks in the future
    insert into   rpt_trace_criteria(patient_id, criteria)
      select      r.patient_id, 'REPEAT_VIRAL_LOAD'
      from        rpt_active_art r
      inner join  mw_lab_tests t on r.patient_id = t.patient_id
      where       t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'Viral Load', null, _endDate, 0)
      and         t.result_numeric > 1000
      and         datediff(_endDate, t.date_result_entered) >= 84
      and         datediff(_endDate, t.date_result_entered) < 154+7*_labWks -- May remove this requirement (MLW-575, 6/25/2017)
      and         r.last_visit_date > t.date_result_entered
      and         r.days_to_next_appt >= 28-7*_labWks
      and         r.days_to_next_appt < 28
    ;

  -- EID No DNA-PCR Test
  -- Logic: 
  --        * No DNA-PCR 
  --        * Over 6 weeks old (42 days)
  --        * Less than 365 days
  --        * and appointmentDate-today [14, 28)
  
    insert into   rpt_trace_criteria(patient_id, criteria)
      select      r.patient_id, 'EID_6_WEEK_TEST'
      from        rpt_active_eid r 
      inner join  mw_patient p on p.patient_id = r.patient_id      
      left join       (select * from 
                            (select * from mw_lab_tests 
                            where test_type in ('HIV DNA polymerase chain reaction') 
                            order by date_collected desc) mli 
                      group by patient_id) 
                      t on t.patient_id = r.patient_id
      where       DATEDIFF(@endDate,p.birthdate) >= 42
      and         DATEDIFF(@endDate,p.birthdate) < 365
      and         t.lab_test_id is null
      and         r.days_to_next_appt >= 28-7*_labWks 
      and         r.days_to_next_appt < 28 -- ~2-4 weeks to appointment
    ;  

    -- EID_12_MONTH_TEST
    -- age >= 12m
    -- no test results since birthdate+12m
    -- and appointmentDate-today [14, 28)

    insert into   rpt_trace_criteria(patient_id, criteria)
      select      r.patient_id, 'EID_12_MONTH_TEST'
      from        rpt_active_eid r
      inner join  mw_patient p on r.patient_id = p.patient_id
      left join  -- This join gets the most recent HIV rapid or DNA-PCR test
             (
              select * 
              from (
                select * 
                from mw_lab_tests
                where test_type in ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                order by date_collected desc            
              ) MLTI group by PATIENT_ID
              ) t on t.patient_id = r.patient_id 
              
      where       date_add(p.birthdate, INTERVAL 12 MONTH) <= _endDate -- Ensure patient is 12+ months
      and         (
                (t.date_collected < date_add(p.birthdate, INTERVAL 12 MONTH))
              or
                (t.date_collected is null) 
            ) -- Ensure result was before 12 months or no result recorded
      and         r.days_to_next_appt >= 28-7*_labWks 
      and         r.days_to_next_appt < 28 -- ~2-4 weeks to appointment
    ;


    -- EID_24_MONTH_TEST
    -- age >= 12m
    -- mom has stopped breastfeeding for at least 6 weeks
    -- no test results since breastfeeding stopped
    -- and appointmentDate-today [14, 28)

    insert into   rpt_trace_criteria(patient_id, criteria)
      select      r.patient_id, 'EID_24_MONTH_TEST'
      from        rpt_active_eid r
      inner join  mw_patient p on r.patient_id = p.patient_id
      left join  -- This join gets the most recent HIV rapid or DNA-PCR test
             (
              select * 
              from (
                select * 
                from mw_lab_tests
                where test_type in ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                order by date_collected desc            
              ) MLTI group by PATIENT_ID
              ) t on t.patient_id = r.patient_id 
              
      where       date_add(p.birthdate, INTERVAL 12 MONTH) <= _endDate -- Ensure patient is 12+ months
      and         (
                (t.date_collected < date_add(p.birthdate, INTERVAL 12 MONTH))
              or
                (t.date_collected is null) 
            ) -- Ensure result was before 12 months or no result recorded
      and         t.date_collected < first_date_no_breastfeeding(r.patient_id, _endDate) -- no results since breastfeeding stopped
      and         r.days_to_next_appt >= 28-7*_labWks 
      and         r.days_to_next_appt < 28 -- ~2-4 weeks to appointment      
    ;

    -- EID_NEGATIVE
    -- second to last eid test result is positive
    -- last eid test result is negative
    -- today-lastEidTestResultDate <= 14d

    insert into   rpt_trace_criteria(patient_id, criteria)
      select      r.patient_id, 'EID_NEGATIVE'
      from        rpt_active_eid r
      inner join  mw_lab_tests lastTest on r.patient_id = lastTest.patient_id
      inner join  mw_lab_tests previousTest on r.patient_id = previousTest.patient_id
      where       lastTest.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', null, _endDate, 0)
      and         previousTest.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', null, _endDate, 1)
      and         lastTest.result_coded = 'Negative'
      and         previousTest.result_coded = 'Positive'
      and         datediff(_endDate, lastTest.date_result_entered) <= 7*_labWks -- May remove this requirement (MLW-575, 6/25/2017)
    ;


  end if;

  if not _phase1Only then

    -- Late NCD
    insert into rpt_trace_criteria(patient_id, criteria)
      select  patient_id, 'LATE_NCD'
      from    rpt_active_ncd
      where   days_late_appt is not null
      and     days_late_appt >= (_minWks*7)
      and     (_maxWks is null or days_late_appt < (_maxWks*7))
      and     (
                _minWks != 6
                or
                ( _minWks = 6 and patient_id in ( select distinct patient_id from rpt_priority_patients ) )
              )
    ;

  end if;

  if not _phase1Only then

      -- Late PDC
      insert into rpt_trace_criteria(patient_id, criteria)
      select  patient_id, 'LATE_PDC'
      from    rpt_active_pdc
      where   days_late_appt is not null
        and     days_late_appt >= (_minWks*7)
        and     (_maxWks is null or days_late_appt < (_maxWks*7))
        and     (
                  _minWks != 6
              or
                  ( _minWks = 6 and patient_id in ( select distinct patient_id from rpt_priority_patients ) )
          )
      ;

  end if;

end
#
