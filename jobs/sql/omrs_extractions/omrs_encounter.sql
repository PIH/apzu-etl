select      e.encounter_id,
            e.uuid,
            e.patient_id,
            et.name as encounter_type,
            f.name as form,
            l.name as location,
            date(e.encounter_datetime) as encounter_date,
            time(e.encounter_datetime) as encounter_time,
            coalesce(CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name_prefix, pn.family_name, pn.family_name2, pn.family_name_suffix), pr.name, pr.identifier, 'Unknown') as provider,
            er.name as provider_role,
            e.visit_id,
            if(p.birthdate is null or e.encounter_datetime is null, null, TIMESTAMPDIFF(YEAR, p.birthdate, e.encounter_datetime)) as age_years_at_encounter,
            if(p.birthdate is null or e.encounter_datetime is null, null, TIMESTAMPDIFF(MONTH, p.birthdate, e.encounter_datetime)) as age_months_at_encounter,
            date(e.date_created) as date_created,
            coalesce(u.username, u.system_id) as created_by
from        encounter e
inner join  person p on e.patient_id = p.person_id
left join   encounter_type et on et.encounter_type_id = e.encounter_type
left join   form f on f.form_id = e.form_id
left join   location l on l.location_id = e.location_id
left join   users u on u.user_id = e.creator
left join   encounter_provider ep on ep.encounter_id = e.encounter_id
            and ep.encounter_provider_id = (
                select  ep2.encounter_provider_id
                from    encounter_provider ep2
                where   ep2.encounter_id = e.encounter_id
                and     ep2.voided = 0
                order by ep2.encounter_provider_id limit 1
            )
left join   provider pr on pr.provider_id = ep.provider_id
left join   encounter_role er on er.encounter_role_id = ep.encounter_role_id
left join   person_name pn on pn.person_id = pr.person_id
            and pn.person_name_id = (
                select  pn2.person_name_id
                from    person_name pn2
                where   pn2.voided = 0
                and     pn2.person_id = pr.person_id
                order by pn2.preferred desc, pn2.date_created desc limit 1
            )
where       e.voided = 0
and         p.voided = 0
