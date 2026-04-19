select      ep.encounter_provider_id,
            ep.uuid,
            e.encounter_id,
            e.uuid as encounter_uuid,
            coalesce(CONCAT_WS(' ', n.given_name, n.middle_name, n.family_name_prefix, n.family_name, n.family_name2, n.family_name_suffix), pr.name, pr.identifier, 'Unknown') as provider,
            er.name as provider_role
from        encounter_provider ep
inner join  encounter e on e.encounter_id = ep.encounter_id
left join   provider pr on pr.provider_id = ep.provider_id
left join   encounter_role er on er.encounter_role_id = ep.encounter_role_id
left join   person_name n on pr.person_id = n.person_id
            and n.person_name_id = (
                select  n2.person_name_id
                from    person_name n2
                where   n2.voided = 0
                and     n2.person_id = pr.person_id
                order by n2.preferred desc, n2.date_created desc limit 1
            )
where       ep.voided = 0
and         e.voided = 0
