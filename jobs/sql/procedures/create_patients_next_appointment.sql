drop procedure if exists create_patients_next_appointment#
/************************************************************************
  Get all patients (PID) with appointment dates for a given enrollment location
  for EID, ART, and NCD programs.
*************************************************************************/
create procedure create_patients_next_appointment(in _location varchar(255))
  begin

    drop TEMPORARY table if exists patients_next_appointment;
    create TEMPORARY table patients_next_appointment (
      patient_id        int not null,
      last_visit_date date,
      last_appt_date    date
    );
    create index patients_next_appointment_id_idx on patients_next_appointment(patient_id);

    insert into patients_next_appointment (patient_id, last_visit_date, last_appt_date)
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
                              ) r
                           on r.patient_id = v.patient_id
                       where next_appointment_date is not null
                       order by visit_date desc
                     ) itable
               group by patient_id
             ) appt_temp;

  end
#
