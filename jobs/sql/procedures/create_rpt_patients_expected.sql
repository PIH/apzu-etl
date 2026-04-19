drop procedure if exists create_rpt_patients_expected#
/************************************************************************
  Get all patients (PID) with appointment date for a given enrollment location 
  and within given window for EID, ART, and NCD programs. 
*************************************************************************/
create procedure create_rpt_patients_expected(in _startDate date, in _endDate date, in _location varchar(255), in _advancedCare tinyint) begin

  drop TEMPORARY table if exists rpt_patients_expected;
  create TEMPORARY table rpt_patients_expected (
    patient_id        int not null,
    last_visit_date date,
    last_appt_date    date
  );
  create index rpt_patients_expected_id_idx on rpt_patients_expected(patient_id);

  insert into rpt_patients_expected (patient_id, last_visit_date, last_appt_date)
  select patient_id, visit_date, next_appointment_date
  from   ( 
          -- sub-query to get the latest appointment date (from last visit)
          select * 
          from  (
                -- three joined sub-queries to get all appointment dates (from EID, NCD, & ART)
                select v.patient_id, v.visit_date, v.next_appointment_date, r.location 
                from mw_art_visits v
                join (
                      select patient_id, location
                      from mw_art_register 
                      where location = _location
                      and (end_date is null or end_date > _endDate)
                    ) r
                on r.patient_id = v.patient_id          
                where next_appointment_date is not null 

                union 

                select v.patient_id, v.visit_date, v.next_appointment_date, r.location  
                from mw_eid_visits v
                join (
                      select patient_id, location
                      from mw_eid_register 
                      where location = _location
                      and (end_date is null or end_date > _endDate)
                    ) r
                on r.patient_id = v.patient_id  
                where next_appointment_date is not null

                union

                select v.patient_id, v.visit_date, v.next_appointment_date, r.location  
                from mw_ncd_visits v          
                join (
                      select patient_id, location
                      from mw_ncd_register 
                      where location = _location
                      and (end_date is null or end_date > _endDate)
                    ) r
                on r.patient_id = v.patient_id            
                where next_appointment_date is not null   
                order by visit_date desc
          ) itable
        group by patient_id
        ) appt_temp
  where next_appointment_date >= _startDate
  and next_appointment_date <= _endDate;   

/*  If the advanced care option is chosen, delete the patients who are
  not in a state of advanced care from the temporary table.
*/
  if _advancedCare = 1 then
    delete from rpt_patients_expected where patient_id in 
      (select patient_id from 
        (select * from 
          (select * from omrs_program_state order by start_date desc) 
      as itable group by patient_id) otable where state <> "In advanced care");
  end if;

end
#
