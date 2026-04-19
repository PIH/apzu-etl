drop procedure if exists create_rpt_priority_patients#
/************************************************************************
  Get priority conditions for each patient
*************************************************************************/
create procedure create_rpt_priority_patients(in _endDate date) begin

  drop TEMPORARY table if exists rpt_priority_patients;
  create TEMPORARY table rpt_priority_patients (
    patient_id  int not null,
    priority   varchar(50)
  );
  create index rpt_priority_patients_patient_id_idx on rpt_priority_patients(patient_id);

  -- HIV:  HIV patients (all)

  insert into rpt_priority_patients(patient_id, priority)
    select distinct p.patient_id, 'HIV'
    from
      (
        select patient_id from mw_pre_art_register where start_date <= _endDate
        union
        select patient_id from mw_art_register where start_date <= _endDate
      ) p
  ;

  -- BP > 180/110:  Hypertension patients with BP ever greater than 180/110 (both systolic and diastolic should exceed threshold)

  insert into rpt_priority_patients(patient_id, priority)
    select  distinct p.patient_id, 'BP > 180/110'
    from
      (
        select  v.patient_id
        from    mw_ncd_visits v
        where   v.systolic_bp > 180 and v.diastolic_bp > 110
      ) p
  ;

  -- ON INSULIN:  Diabetes patients on insulin

  insert into rpt_priority_patients(patient_id, priority)
    select  distinct p.patient_id, 'ON INSULIN'
    from
      (
        select  v.patient_id
        from    mw_ncd_visits v
        where   v.on_insulin = TRUE
      ) p
  ;

  -- SEVERE PERSISTENT ASTHMA:  Asthma patients with severity of “severe persistent” at last visit

  insert into rpt_priority_patients(patient_id, priority)
    select  distinct p.patient_id, 'SEVERE PERSISTENT ASTHMA'
    from
      (
        select  v.patient_id
        from    mw_ncd_visits v
        where   v.asthma_classification = 'Severe persistent'
        and     v.ncd_visit_id = latest_asthma_visit(v.patient_id, _endDate)
      ) p
  ;

  -- "> 5 SEIZURES / MONTH":  Epilepsy patients reporting over 5 seizures per month at last visit

  insert into rpt_priority_patients(patient_id, priority)
    select  distinct p.patient_id, '> 5 SEIZURES / MONTH'
    from
      (
        select  v.patient_id
        from    mw_ncd_visits v
        where   v.num_seizures > 5
        and     v.ncd_visit_id = latest_epilepsy_visit(v.patient_id, _endDate)
      ) p
  ;

  -- Sickle cell disease patients (all)
  -- Chronic kidney disease patients (all)
  -- Rheumatic Heart Disease patients (all)
  -- Congestive Heart Failure patients (all)

  insert into rpt_priority_patients(patient_id, priority)
    select  distinct p.patient_id, p.diagnosis
    from
      (
        select    d.patient_id, d.diagnosis
        from      mw_ncd_diagnoses d
        where     d.diagnosis in ('Sickle cell disease' , 'Chronic kidney disease', 'Rheumatic heart disease', 'Congestive heart failure')
        and       d.diagnosis_date <= _endDate
        group by  d.patient_id, d.diagnosis
      ) p
  ;

end
#
