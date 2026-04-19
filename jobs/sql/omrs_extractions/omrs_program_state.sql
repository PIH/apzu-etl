select      ps.patient_state_id as program_state_id,
            ps.uuid,
            pp.patient_program_id as program_enrollment_id,
            p.person_id as patient_id,
            (select cn.name from concept_name cn
             where cn.concept_id = pg.concept_id and cn.voided = 0
             order by if(cn.concept_name_type='FULLY_SPECIFIED',0,1), if(cn.locale='en',0,1), cn.locale_preferred desc limit 1) as program,
            (select cn.name from concept_name cn
             where cn.concept_id = pw.concept_id and cn.voided = 0
             order by if(cn.concept_name_type='FULLY_SPECIFIED',0,1), if(cn.locale='en',0,1), cn.locale_preferred desc limit 1) as workflow,
            (select cn.name from concept_name cn
             where cn.concept_id = pws.concept_id and cn.voided = 0
             order by if(cn.concept_name_type='FULLY_SPECIFIED',0,1), if(cn.locale='en',0,1), cn.locale_preferred desc limit 1) as state,
            ps.start_date,
            if(p.birthdate is null or ps.start_date is null, null, TIMESTAMPDIFF(YEAR, p.birthdate, ps.start_date)) as age_years_at_start,
            if(p.birthdate is null or ps.start_date is null, null, TIMESTAMPDIFF(MONTH, p.birthdate, ps.start_date)) as age_months_at_start,
            ps.end_date,
            if(p.birthdate is null or ps.start_date is null, null, TIMESTAMPDIFF(YEAR, p.birthdate, ps.end_date)) as age_years_at_end,
            if(p.birthdate is null or ps.start_date is null, null, TIMESTAMPDIFF(MONTH, p.birthdate, ps.end_date)) as age_months_at_end,
            l.name as location
from        person p
inner join  patient_program pp on p.person_id = pp.patient_id
inner join  patient_state ps on ps.patient_program_id = pp.patient_program_id
inner join  program_workflow_state pws on ps.state = pws.program_workflow_state_id
inner join  program_workflow pw on pws.program_workflow_id = pw.program_workflow_id
inner join  program pg on pp.program_id = pg.program_id
left join   location l on l.location_id = pp.location_id
where       pp.voided = 0
and         p.voided = 0
and         ps.voided = 0
and         pp.date_enrolled is not null
and         ps.start_date is not null
