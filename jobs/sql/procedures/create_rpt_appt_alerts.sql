drop procedure if exists create_rpt_appt_alerts#
/************************************************************************
  Get priority conditions for each patient
*************************************************************************/
create procedure create_rpt_appt_alerts(in _endDate date) begin

  drop TEMPORARY table if exists rpt_appt_alerts;
  create TEMPORARY table rpt_appt_alerts (
    patient_id  int not null,
    alert   varchar(100),
    action   varchar(100)
  );
  create index rpt_appt_alerts_patient_id_idx on rpt_appt_alerts(patient_id);

  -- Routine Viral Load
  -- Logic: 
  --        * No viral load and > 182 days since ART initiation date OR
  --        * Every two years after ART initiation
  --        * Max 20 patients per report, prioritize 15 - 45 (young to old)
  -- Alert: Due for routine VL
  -- Do this today: Needs routine VL
  -- Note:
  --      * This uses start_date from the ART register (in pentaho) to determine ART Initiation
  insert into   rpt_appt_alerts(patient_id, alert, action)
    select r.patient_id, 'Due for routine VL', 'Needs routine VL'
    from    rpt_active_art r
    inner join (select * from 
                    (select * 
                     from mw_art_register 
                     order by start_date asc) ari
                     group by patient_id) ar
                 on ar.patient_id = r.patient_id
    left join  (select * 
                from (select * 
                      from mw_lab_tests
                      where test_type = "Viral Load"
                      order by date_collected desc) ti 
                group by patient_id) t
                on r.patient_id = t.patient_id
    where
      ( 
        ( 
            lab_test_id is null -- no test
          and
            DATEDIFF(_endDate,start_date) > 182 -- 6 months after *enrollment* (should be ART start)
        )
        or
        ( -- within 2y/4y/6y/... years to 2y+90d/4y+90d/6y+90d/... of *enrollment* (should be ART start)
          DATEDIFF(_endDate,start_date) % 730 < 90 -- within 90 days after 2y anniversary
          and DATEDIFF(@endDate,start_date) > 182 -- 6 months after *enrollment* (should be ART start)
          and (
                DATEDIFF(_endDate,date_collected) > DATEDIFF(_endDate,start_date) % 730 + 90 -- no test 90d before 2y anniversary to present
              or 
                lab_test_id is null -- no test
              )
          
        )
      )
  ;




  -- High Viral Load
  -- Logic:
  --        * Last viral load > 1000
  --        * Result entered in last three months
  -- Alert: High VL
  -- Do this today: Do adherence counseling intervention
  insert into   rpt_appt_alerts(patient_id, alert, action)
    select      r.patient_id, 'High VL', 'Do adherence counseling interention'
    from        rpt_active_art r
    inner join  mw_lab_tests t on r.patient_id = t.patient_id
    where       t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'Viral Load', null, _endDate, 0)
    and         t.result_numeric > 1000
    and         datediff(_endDate, t.date_result_entered) <= 91
  ;


  -- Viral Load Re-test
  -- Logic: 
  --        * High viral load (>1000)
  --        * 60 days between visit after high viral load test and appointment date
  --        * No "bled" recorded on mastercard subsequent to visit after high viral load result
  -- Alert: High VL
  -- Do this today: Consider confirmatory VL
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select      r.patient_id, 'High VL', 'Consider confirmatory VL'
      from        rpt_active_art r
      inner join  mw_lab_tests t on r.patient_id = t.patient_id
      inner join  mw_lab_tests t2 on r.patient_id = t.patient_id      
      where       t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'Viral Load', null, _endDate, 0)
      and         t2.lab_test_id = latest_test_result_by_sample_date(r.patient_id, 'Viral Load', null, _endDate, 0)      
      and         (
                    (
                      t2.date_collected is null
                    )
                    or
                    (
                      t2.date_collected < t.date_result_entered
                    )
                  )
      and         t.result_numeric > 1000
      and         r.last_visit_date > t.date_result_entered
      and         datediff(_endDate,r.last_visit_date) > 60
    ;


  -- EID Positive Rapid Test
  -- Logic: 
  --        * Last rapid test is positive
  --        * Outcome is still "Exposed Child (continue)"
  -- Alert: EID Positive RT
  -- Do this today: Confirm ART Enrollment
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select        r.patient_id, 'EID Positive RT', 'Enroll on ART and do DNA-PCR'
      from          rpt_active_eid r 
      inner join    mw_lab_tests t on t.patient_id = r.patient_id
      where         t.lab_test_id = latest_test_result_by_date_entered(r.patient_id, 'HIV rapid test, qualitative', null, _endDate, 0)
      and           result_coded = "Positive"
    ;  

  -- EID No DNA-PCR Test
  -- Logic: 
  --        * No DNA-PCR 
  --        * Over 6 weeks old (42 days)
  --        * Less than 365 days
  -- Alert: Due for EID DNA-PCR Test
  -- Do this today: Refer to HTC for DNA-PCR test
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select      r.patient_id, 'Due for EID DNA-PCR Test', 'Refer to HTC for DNA-PCR test'
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
    ;  

  -- EID Due for 12 month rapid test
  -- Logic: 
  --        * Age >= 12 months
  --        * No rapid test since 12 months
  -- Alert: Due for EID Rapid Test
  -- Do this today: Refer to HTC for rapid test
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select        r.patient_id, 'Due for EID Rapid Test', 'Refer to HTC for rapid test'
      from        rpt_active_eid r 
      inner join  mw_patient p on p.patient_id = r.patient_id      
      left join     (select * from 
                      (select * from mw_lab_tests 
                        where test_type in ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                        order by date_collected desc) mli 
                        group by patient_id) t on t.patient_id = r.patient_id
      where         DATEDIFF(_endDate,p.birthdate) >= 365
      and         DATEDIFF(_endDate,p.birthdate) < 731
      and         (DATEDIFF(t.date_result_entered,p.birthdate) < 365 or t.date_result_entered is null)
    ;  


  -- EID Due for 12 month rapid test
  -- Logic: 
  --        * Age >= 12 months
  --        * No rapid test since 12 months
  -- Alert: Due for EID Rapid Test
  -- Do this today: Refer to HTC for rapid test
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select        r.patient_id, 'Due for EID Rapid Test', 'Refer to HTC for rapid test'
      from        rpt_active_eid r 
      inner join  mw_patient p on p.patient_id = r.patient_id      
      left join     (select * from 
                      (select * from mw_lab_tests 
                        where test_type in ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                        order by date_collected desc) mli 
                        group by patient_id) t on t.patient_id = r.patient_id
      where         DATEDIFF(_endDate,p.birthdate) >= 365
      and         DATEDIFF(_endDate,p.birthdate) < 731
      and         (DATEDIFF(t.date_result_entered,p.birthdate) < 365 or t.date_result_entered is null)
    ;    


  -- EID Due for 24 month rapid test
  -- Logic: 
  --        * Age >= 24 months
  --        * No rapid test since 24 months
  -- Alert: Consider EID RT
  -- Do this today: If baby stopped breastfeeding 6w ago, refer to HTC for RT
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select        r.patient_id, 'Consider EID RT', 'If baby stopped breastfeeding 6w ago, refer to HTC for RT'
      from          rpt_active_eid r 
      inner join    mw_patient p on p.patient_id = r.patient_id      
      left join     (select * from 
                      (select * from mw_lab_tests 
                        where test_type in ('HIV rapid test, qualitative','HIV DNA polymerase chain reaction') 
                        order by date_collected desc) mli 
                    group by patient_id) t on t.patient_id = r.patient_id
      where         DATEDIFF(_endDate,p.birthdate) >= 731
      and           (DATEDIFF(t.date_result_entered,p.birthdate) < 731 or t.date_result_entered is null)
    ;  

  -- Diabetes Test Needed
  -- Logic: 
  --        * Diabetes (or Type 2 diabetes) diagnosis and no test in last 6 months
  --        * Type 1 diabetes diagnosis and no test in last 3 months
  -- Alert: Test for HbA1C
  -- Do this today: Refer for fingerstick
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select       r.patient_id, 'Test for HbA1C', 'Refer for fingerstick'
      from         rpt_active_ncd r
      join    (select * from mw_ncd_diagnoses where diagnosis in ('Diabetes','Type 1 diabetes','Type 2 diabetes') group by patient_id) d on d.patient_id = r.patient_id
      left join    (select * 
                      from (select * 
                              from omrs_obs 
                              where concept = "Glycated hemoglobin" 
                              order by obs_date desc) oi 
                      group by patient_id) o 
                      on o.patient_id = r.patient_id
      where   ( 
                diagnosis = 'Type 1 diabetes' and (datediff(_endDate,obs_date) > 90 or obs_date is null)
              )
                or
              ( 
                diagnosis in ('Diabetes','Type 2 diabetes') and (datediff(_endDate,obs_date) > 182 or obs_date is null)
              )             
    ;  

  -- Creatinine test for HTN and DM
  -- Logic: 
  --        * No creatinine result in the last year
  --        * Diagnosis of HTN or DM
  -- Alert: Test for Creatinine
  -- Do this today: Refer to nurse for creatinine test
    insert into   rpt_appt_alerts(patient_id, alert, action)
      select      r.patient_id, 'Test for Creatinine', 'Refer to nurse for creatinine test'
      from        rpt_active_ncd r
      inner join  (select * from mw_ncd_diagnoses d where diagnosis in ("Diabetes","Hypertension") group by patient_id) d on d.patient_id = r.patient_id
      left join   (select * 
                    from (select * 
                            from omrs_obs 
                            where concept = "Creatinine" 
                            order by obs_date desc) oi 
                            group by patient_id) o 
                            on o.patient_id = r.patient_id
      where         (datediff(_endDate,obs_date) > 365 or obs_date is null)
    ;

end
#
