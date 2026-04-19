drop procedure if exists create_rpt_mh_data#
create  procedure `create_rpt_mh_data`(in _endDate date, in _location varchar(255))
begin

  
  drop table if exists rpt_ic3_patient_ids;
  create TEMPORARY table rpt_ic3_patient_ids as
    select distinct(patient_id)
    from mw_mental_health_initial

    union

    select distinct(patient_id)
    from mw_mental_health_followup

    union

    select distinct(patient_id)
    from mw_epilepsy_initial

    union

    select distinct(patient_id)
    from mw_epilepsy_followup;

  create index patient_id_index on rpt_ic3_patient_ids(patient_id);

  
  drop table if exists rpt_mh_data_table;
  create table rpt_mh_data_table as
    
    select
      ic3.patient_id,
      birthdate,
      gender,
      epilepsyDx,
      epilepsyIntakeVisitDate,
      epilepsyIntakeLocation,
      YEAR(epilepsyIntakeVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(epilepsyIntakeVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtEpilepsyIntake,
      lastEpilepsyVisitDate,
      lastEpilepsyVisitLocation,
      YEAR(lastEpilepsyVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(lastEpilepsyVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtLastEpilepsyVisit,
      nextEpilepsyAppt,
      mhIntakeVisitDate,
      YEAR(mhIntakeVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(mhIntakeVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtMHIntake,
      mhIntakeLocation,
      dx_organic_mental_disorder_chronic,
      dx_date_organic_mental_disorder_chronic,
      dx_organic_mental_disorder_acute,
      dx_date_organic_mental_disorder_acute,
      dx_alcohol_use_mental_disorder,
      dx_date_alcohol_use_mental_disorder,
      dx_drug_use_mental_disorder,
      dx_date_drug_use_mental_disorder,
      dx_schizophrenia,
      dx_acute_and_transient_psychotic,
      dx_schizoaffective_disorder,
      dx_mood_affective_disorder_manic,
      dx_mood_affective_disorder_depression,
      dx_anxiety_disorder,
      dx_bipolar_mood_disorder,
      dx_dissociative_mood_disorder,
      dx_hyperkinetic_disorder,
      dx_puerperal_mental_disorder,
      dx_stress_reactive_adjustment_disorder,
      dx_psych_development_disorder,
      dx_mental_retardation_disorder,
      dx_personality_disorder,
      dx_somatoform_disorder,
      dx_mh_other_1,
      dx_mh_other_2,
      dx_mh_other_3,
      lastMHVisitDate,
      YEAR(lastMHVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(lastMHVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtLastMHVisit,
      visitLocation,
      nextMHAppt
    from 			rpt_ic3_patient_ids ic3
      inner join 		(select patient_id,
                      birthdate,
                      gender
                    from mw_patient
                   ) pdetails
        on pdetails.patient_id = ic3.patient_id
      left join 		(select patient_id,
                      case when diagnosis is not null then 'X' end as epilepsyDx
                    from mw_ncd_diagnoses
                    where diagnosis = "Epilepsy"
                          and diagnosis_date < _endDate
                    group by patient_id
                   ) epilepsyDx
        on epilepsyDx.patient_id = ic3.patient_id
      left join		(select *
                    from 	(select patient_id,
                             visit_date as epilepsyIntakeVisitDate,
                             location as epilepsyIntakeLocation
                           from mw_epilepsy_initial
                           order by visit_date desc
                          ) epilepsyInner group by patient_id
                   ) epilepsyIntake on epilepsyIntake.patient_id = ic3.patient_id
      left join		(select *
                    from 	(select patient_id,
                             visit_date as lastEpilepsyVisitDate,
                             location as lastEpilepsyVisitLocation,
                             next_appointment_date as nextEpilepsyAppt
                           from mw_epilepsy_followup
                           where location= _location
                                 and visit_date < _endDate
                           order by visit_date desc
                          ) epilepsyFollowupInner group by patient_id
                   ) epilepsyVisit on epilepsyVisit.patient_id = ic3.patient_id
      left join		(select *
                    from 	(select patient_id,
                             visit_date as mhIntakeVisitDate,
                             location as mhIntakeLocation,
                             diagnosis_organic_mental_disorder_chronic as dx_organic_mental_disorder_chronic,
                             case when diagnosis_organic_mental_disorder_chronic is not null and diagnosis_date_organic_mental_disorder_chronic is not null then diagnosis_date_organic_mental_disorder_chronic
                                  when diagnosis_organic_mental_disorder_chronic is not null and diagnosis_date_organic_mental_disorder_chronic is null then visit_date
                              else null
                             end as dx_date_organic_mental_disorder_chronic,
                             diagnosis_organic_mental_disorder_acute as dx_organic_mental_disorder_acute,
                             case when diagnosis_organic_mental_disorder_acute is not null and diagnosis_date_organic_mental_disorder_acute is not null then diagnosis_date_organic_mental_disorder_acute
                                  when diagnosis_organic_mental_disorder_acute is not null and diagnosis_date_organic_mental_disorder_acute is null then visit_date
                             else null
                             end as dx_date_organic_mental_disorder_acute,
                             diagnosis_alcohol_use_mental_disorder as dx_alcohol_use_mental_disorder,
                             case when diagnosis_alcohol_use_mental_disorder is not null and diagnosis_date_alcohol_use_mental_disorder is not null then diagnosis_date_alcohol_use_mental_disorder
                                  when diagnosis_alcohol_use_mental_disorder is not null and diagnosis_date_alcohol_use_mental_disorder is null then visit_date
                             else null
                             end as dx_date_alcohol_use_mental_disorder,
                             diagnosis_drug_use_mental_disorder as dx_drug_use_mental_disorder,
                             case when diagnosis_drug_use_mental_disorder is not null and diagnosis_date_drug_use_mental_disorder is not null then diagnosis_date_drug_use_mental_disorder
                                  when diagnosis_drug_use_mental_disorder is not null and diagnosis_date_drug_use_mental_disorder is null then visit_date
                             else null
                             end as dx_date_drug_use_mental_disorder,
                             diagnosis_schizophrenia as dx_schizophrenia,
                             diagnosis_acute_and_transient_psychotic as dx_acute_and_transient_psychotic,
                             diagnosis_schizoaffective_disorder as dx_schizoaffective_disorder,
                             diagnosis_mood_affective_disorder_manic as dx_mood_affective_disorder_manic,
                             diagnosis_mood_affective_disorder_depression as dx_mood_affective_disorder_depression,
                             diagnosis_anxiety_disorder as dx_anxiety_disorder,
                             diagnosis_bipolar_mood_disorder as dx_bipolar_mood_disorder,
			     diagnosis_stress_reactive_adjustment_disorder as dx_stress_reactive_adjustment_disorder,
			     diagnosis_dissociative_mood_disorder as dx_dissociative_mood_disorder,
			     diagnosis_hyperkinetic_disorder as dx_hyperkinetic_disorder,
			     diagnosis_puerperal_mental_disorder as dx_puerperal_mental_disorder,
			     diagnosis_somatoform_disorder as dx_somatoform_disorder,
			     diagnosis_personality_disorder as dx_personality_disorder,
			     diagnosis_mental_retardation_disorder as dx_mental_retardation_disorder,
			     diagnosis_psych_development_disorder as dx_psych_development_disorder,
                             diagnosis_other_1 as dx_mh_other_1,
                             diagnosis_other_2 as dx_mh_other_2,
                             diagnosis_other_3 as dx_mh_other_3
                           from mw_mental_health_initial
                           order by visit_date desc
                          ) mhInner group by patient_id
                   ) mhIntake on mhIntake.patient_id = ic3.patient_id
      left join		(select *
                    from 	(select patient_id,
                             visit_date as lastMHVisitDate,
                             location as visitLocation,
                             next_appointment_date as nextMHAppt
                           from mw_mental_health_followup
                           where location= _location
                                 and visit_date < _endDate
                           order by visit_date desc
                          ) mhFollowupInner group by patient_id
                   ) mentalHealthVisit on mentalHealthVisit.patient_id = ic3.patient_id
  ;

  drop table if exists rpt_ic3_patient_ids;

end
#
