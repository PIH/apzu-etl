select      pp.patient_program_id as program_enrollment_id,
            pp.uuid,
            p.person_id as patient_id,
            (select cn.name from concept_name cn
             where cn.concept_id = pg.concept_id and cn.voided = 0
             order by if(cn.concept_name_type='FULLY_SPECIFIED',0,1), if(cn.locale='en',0,1), cn.locale_preferred desc limit 1) as program,
            pp.date_enrolled as enrollment_date,
            if(p.birthdate is null or pp.date_enrolled is null, null, TIMESTAMPDIFF(YEAR, p.birthdate, pp.date_enrolled)) as age_years_at_enrollment,
            if(p.birthdate is null or pp.date_enrolled is null, null, TIMESTAMPDIFF(MONTH, p.birthdate, pp.date_enrolled)) as age_months_at_enrollment,
            l.name as location,
            pp.date_completed as completion_date,
            if(p.birthdate is null or pp.date_completed is null, null, TIMESTAMPDIFF(YEAR, p.birthdate, pp.date_completed)) as age_years_at_completion,
            if(p.birthdate is null or pp.date_completed is null, null, TIMESTAMPDIFF(MONTH, p.birthdate, pp.date_completed)) as age_months_at_completion,
            (select cn.name from concept_name cn
             where cn.concept_id = pp.outcome_concept_id and cn.voided = 0
             order by if(cn.concept_name_type='FULLY_SPECIFIED',0,1), if(cn.locale='en',0,1), cn.locale_preferred desc limit 1) as outcome
from        person p
inner join  patient_program pp on p.person_id = pp.patient_id
inner join  program pg on pp.program_id = pg.program_id
left join   location l on l.location_id = pp.location_id
where       pp.voided = 0
and         p.voided = 0
and         pp.date_enrolled is not null
