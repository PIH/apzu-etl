/************************************************************************
  Get the trace criteria for each patient
*************************************************************************/
CREATE PROCEDURE create_rpt_trace_criteria(IN _endDate DATE, IN _location VARCHAR(255), IN _minWks INT, IN _labWks INT, IN _maxWks INT, IN _phase1Only BOOLEAN) BEGIN

  DROP TEMPORARY TABLE IF EXISTS rpt_trace_criteria;
  CREATE TEMPORARY TABLE rpt_trace_criteria (
    patient_id        INT NOT NULL,
    criteria          VARCHAR(50)
  );
  CREATE INDEX rpt_trace_criteria_patient_id_idx ON rpt_trace_criteria(patient_id);

  -- Late ART
  INSERT INTO rpt_trace_criteria(patient_id, criteria)
    SELECT  patient_id, 'LATE_ART'
    FROM    rpt_active_art
    WHERE   days_late_appt IS NOT NULL
    AND     days_late_appt >= (_minWks*7)
    AND     (_maxWks IS NULL OR days_late_appt < (_maxWks*7))
  ;

  -- Late EID
  INSERT INTO rpt_trace_criteria(patient_id, criteria)
    SELECT  patient_id, 'LATE_EID'
    FROM    rpt_active_eid
    WHERE   days_late_appt IS NOT NULL
    AND     days_late_appt >= (_minWks*7)
    AND     (_maxWks IS NULL OR days_late_appt < (_maxWks*7))
  ;

  -- High Viral Load
  -- 2 wk: Active patients who have a viral load > 1000 with entry date <= 56 days
  -- 6 wk: Active patients who have a viral load > 1000 and no subsequent visit
  INSERT INTO   rpt_trace_criteria(patient_id, criteria)
    SELECT      r.patient_id, 'HIGH_VIRAL_LOAD'
    FROM        rpt_active_art r
    INNER JOIN  mw_lab_tests t on r.patient_id = t.patient_id
    WHERE       t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'Viral Load', null, _endDate, 0)
    AND         (
                  ( _minWks = 2 AND
                    datediff(_endDate, t.date_result_entered) <= 42+7*_labWks AND
                    t.result_numeric > 1000
                  )
                  OR
                  ( _minWks = 6 AND
                    t.result_numeric > 1000 AND
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

  INSERT INTO   rpt_trace_criteria(patient_id, criteria)
    SELECT      r.patient_id, 'EID_POSITIVE_6_WK'
    FROM        rpt_active_eid r
    INNER JOIN  mw_lab_tests t on r.patient_id = t.patient_id
    WHERE       t.lab_test_id = first_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', _endDate)
    AND         t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', null, _endDate, 0)
    AND         (
                  ( _minWks = 2 AND
                    datediff(_endDate, t.date_result_entered) <= 42+7*_labWks AND
                    t.result_coded = 'Positive'
                  )
                  OR
                  ( _minWks = 6 AND
                    t.result_coded = 'Positive' AND
                    t.date_result_entered > r.last_visit_date
                  )
                )
  ;

  IF _minWks = 2 THEN

    -- REPEAT_VIRAL_LOAD
    --  Active HIV
    --  Has viral load > 1000, it was entered [84, 168) days ago, patient _has_ visited since, and patient has appointment 2-4 weeks in the future
    INSERT INTO   rpt_trace_criteria(patient_id, criteria)
      SELECT      r.patient_id, 'REPEAT_VIRAL_LOAD'
      FROM        rpt_active_art r
      INNER JOIN  mw_lab_tests t on r.patient_id = t.patient_id
      WHERE       t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'Viral Load', null, _endDate, 0)
      AND         t.result_numeric > 1000
      AND         datediff(_endDate, t.date_result_entered) >= 84
      AND         datediff(_endDate, t.date_result_entered) < 154+7*_labWks -- May remove this requirement (MLW-575, 6/25/2017)
      AND         r.last_visit_date > t.date_result_entered
      AND         r.days_to_next_appt >= 28-7*_labWks
      AND         r.days_to_next_appt < 28
    ;

  -- EID No DNA-PCR Test
  -- Logic: 
  --        * No DNA-PCR 
  --        * Over 6 weeks old (42 days)
  --        * Less than 365 days
  --        * and appointmentDate-today [14, 28)
  
    INSERT INTO   rpt_trace_criteria(patient_id, criteria)
      SELECT      r.patient_id, 'EID_6_WEEK_TEST'
      FROM        rpt_active_eid r 
      INNER JOIN  mw_patient p on p.patient_id = r.patient_id      
      LEFT JOIN       (SELECT * from 
                            (SELECT * FROM mw_lab_tests 
                            WHERE test_type IN ('HIV DNA polymerase chain reaction') 
                            ORDER BY date_collected desc) mli 
                      GROUP BY patient_id) 
                      t ON t.patient_id = r.patient_id
      WHERE       DATEDIFF(@endDate,p.birthdate) >= 42
      AND         DATEDIFF(@endDate,p.birthdate) < 365
      AND         t.lab_test_id IS NULL
      AND         r.days_to_next_appt >= 28-7*_labWks 
      AND         r.days_to_next_appt < 28 -- ~2-4 weeks to appointment
    ;  

    -- EID_12_MONTH_TEST
    -- age >= 12m
    -- no test results since birthdate+12m
    -- and appointmentDate-today [14, 28)

    INSERT INTO   rpt_trace_criteria(patient_id, criteria)
      SELECT      r.patient_id, 'EID_12_MONTH_TEST'
      FROM        rpt_active_eid r
      INNER JOIN  mw_patient p on r.patient_id = p.patient_id
      LEFT JOIN  -- This join gets the most recent HIV rapid or DNA-PCR test
             (
              SELECT * 
              FROM (
                SELECT * 
                FROM mw_lab_tests
                WHERE test_type IN ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                ORDER BY date_collected DESC            
              ) MLTI GROUP BY PATIENT_ID
              ) t ON t.patient_id = r.patient_id 
              
      WHERE       date_add(p.birthdate, INTERVAL 12 MONTH) <= _endDate -- Ensure patient is 12+ months
      AND         (
                (t.date_collected < date_add(p.birthdate, INTERVAL 12 MONTH))
              OR
                (t.date_collected IS NULL) 
            ) -- Ensure result was before 12 months or no result recorded
      AND         r.days_to_next_appt >= 28-7*_labWks 
      AND         r.days_to_next_appt < 28 -- ~2-4 weeks to appointment
    ;


    -- EID_24_MONTH_TEST
    -- age >= 12m
    -- mom has stopped breastfeeding for at least 6 weeks
    -- no test results since breastfeeding stopped
    -- and appointmentDate-today [14, 28)

    INSERT INTO   rpt_trace_criteria(patient_id, criteria)
      SELECT      r.patient_id, 'EID_24_MONTH_TEST'
      FROM        rpt_active_eid r
      INNER JOIN  mw_patient p on r.patient_id = p.patient_id
      LEFT JOIN  -- This join gets the most recent HIV rapid or DNA-PCR test
             (
              SELECT * 
              FROM (
                SELECT * 
                FROM mw_lab_tests
                WHERE test_type IN ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                ORDER BY date_collected DESC            
              ) MLTI GROUP BY PATIENT_ID
              ) t ON t.patient_id = r.patient_id 
              
      WHERE       date_add(p.birthdate, INTERVAL 12 MONTH) <= _endDate -- Ensure patient is 12+ months
      AND         (
                (t.date_collected < date_add(p.birthdate, INTERVAL 12 MONTH))
              OR
                (t.date_collected IS NULL) 
            ) -- Ensure result was before 12 months or no result recorded
      AND         t.date_collected < first_date_no_breastfeeding(r.patient_id, _endDate) -- no results since breastfeeding stopped
      AND         r.days_to_next_appt >= 28-7*_labWks 
      AND         r.days_to_next_appt < 28 -- ~2-4 weeks to appointment      
    ;

    -- EID_NEGATIVE
    -- second to last eid test result is positive
    -- last eid test result is negative
    -- today-lastEidTestResultDate <= 14d

    INSERT INTO   rpt_trace_criteria(patient_id, criteria)
      SELECT      r.patient_id, 'EID_NEGATIVE'
      FROM        rpt_active_eid r
      INNER JOIN  mw_lab_tests lastTest on r.patient_id = lastTest.patient_id
      INNER JOIN  mw_lab_tests previousTest on r.patient_id = previousTest.patient_id
      WHERE       lastTest.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', null, _endDate, 0)
      AND         previousTest.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV DNA polymerase chain reaction', null, _endDate, 1)
      AND         lastTest.result_coded = 'Negative'
      AND         previousTest.result_coded = 'Positive'
      AND         datediff(_endDate, lastTest.date_result_entered) <= 7*_labWks -- May remove this requirement (MLW-575, 6/25/2017)
    ;


  END IF;

  IF NOT _phase1Only THEN

    -- Late NCD
    INSERT INTO rpt_trace_criteria(patient_id, criteria)
      SELECT  patient_id, 'LATE_NCD'
      FROM    rpt_active_ncd
      WHERE   days_late_appt IS NOT NULL
      AND     days_late_appt >= (_minWks*7)
      AND     (_maxWks IS NULL OR days_late_appt < (_maxWks*7))
      AND     (
                _minWks = 2
                OR
                ( _minWks = 6 AND patient_id in ( select DISTINCT patient_id from rpt_priority_patients ) )
              )
    ;

  END IF;

END
