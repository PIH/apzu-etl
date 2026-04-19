drop procedure if exists create_rpt_active_pdc#
/************************************************************************
  Get Active PDC patients, including PDC visit and appointment data
  We get the next appointment date from the last visit, not just the latest
  appointment date obs, in case it is left blank on the last visit
*************************************************************************/
create procedure create_rpt_active_pdc(in _endDate date, in _location varchar(255)) begin

    drop TEMPORARY table if exists rpt_active_pdc;
    create TEMPORARY table rpt_active_pdc (
                                              patient_id        int not null,
                                              pdc_number        varchar(50),
                                              last_visit_date   date,
                                              last_visit_type varchar(255),
                                              last_visit_days   int,
                                              last_appt_date    date,
                                              days_late_appt    int,
                                              days_to_next_appt int
    );
    create index rpt_active_pdc_patient_id_idx on rpt_active_pdc(patient_id);

    insert into rpt_active_pdc (patient_id, pdc_number)
    select patient_id, pdc_number from mw_pdc_register where location = _location and (end_date is null or end_date > _endDate);

    update      rpt_active_pdc t
        inner join (
            select    patient_id, max(visit_date) as last_visit
            from      mw_pdc_visits
            where     visit_date <= _endDate
            group by  patient_id
        ) v on t.patient_id = v.patient_id
    set
        t.last_visit_date = v.last_visit,
        t.last_visit_days = datediff(_endDate, v.last_visit)
    ;

    update      rpt_active_pdc t
        inner join  mw_pdc_visits v on t.patient_id = v.patient_id and t.last_visit_date = v.visit_date
    set         t.last_appt_date = v.next_appointment_date,t.last_visit_type=v.visit_types;

    update      rpt_active_pdc
    set         days_late_appt = datediff(_endDate, last_appt_date)
    where       last_appt_date is not null
      and         last_appt_date < _endDate;

    update      rpt_active_pdc
    set         days_to_next_appt = datediff(last_appt_date, _endDate)
    where       last_appt_date is not null
      and         last_appt_date >= _endDate;

end
#
