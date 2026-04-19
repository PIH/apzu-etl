-- Relationships where the patient is person_a
select      r.relationship_id,
            r.uuid,
            p.person_id as patient_id,
            t.a_is_to_b as patient_role,
            t.b_is_to_a as related_person_role,
            CONCAT_WS(' ', rn.given_name, rn.middle_name, rn.family_name_prefix, rn.family_name, rn.family_name2, rn.family_name_suffix) as related_person,
            r.start_date,
            r.end_date,
            date(r.date_created) as date_created
from        relationship r
inner join  person p on p.person_id = r.person_a
inner join  patient pa on pa.patient_id = p.person_id
inner join  person rp on rp.person_id = r.person_b
inner join  relationship_type t on t.relationship_type_id = r.relationship
left join   person_name rn on rn.person_id = rp.person_id
            and rn.person_name_id = (
                select  rn2.person_name_id
                from    person_name rn2
                where   rn2.voided = 0
                and     rn2.person_id = rp.person_id
                order by rn2.preferred desc, rn2.date_created desc limit 1
            )
where       t.a_is_to_b is not null
and         r.person_a is not null
and         r.person_b is not null
and         r.voided = 0
and         p.voided = 0
and         pa.voided = 0
and         rp.voided = 0

union all

-- Relationships where the patient is person_b
select      r.relationship_id,
            r.uuid,
            p.person_id as patient_id,
            t.b_is_to_a as patient_role,
            t.a_is_to_b as related_person_role,
            CONCAT_WS(' ', rn.given_name, rn.middle_name, rn.family_name_prefix, rn.family_name, rn.family_name2, rn.family_name_suffix) as related_person,
            r.start_date,
            r.end_date,
            date(r.date_created) as date_created
from        relationship r
inner join  person p on p.person_id = r.person_b
inner join  patient pa on pa.patient_id = p.person_id
inner join  person rp on rp.person_id = r.person_a
inner join  relationship_type t on t.relationship_type_id = r.relationship
left join   person_name rn on rn.person_id = rp.person_id
            and rn.person_name_id = (
                select  rn2.person_name_id
                from    person_name rn2
                where   rn2.voided = 0
                and     rn2.person_id = rp.person_id
                order by rn2.preferred desc, rn2.date_created desc limit 1
            )
where       t.b_is_to_a is not null
and         r.person_a is not null
and         r.person_b is not null
and         r.voided = 0
and         p.voided = 0
and         pa.voided = 0
and         rp.voided = 0
