select      p.person_id as patient_id,
            p.uuid as patient_uuid,
            n.given_name as first_name,
            n.middle_name as middle_name,
            CONCAT_WS(' ', n.family_name_prefix, n.family_name, n.family_name2, n.family_name_suffix) as last_name,
            p.gender,
            p.birthdate,
            p.birthdate_estimated,
            phone_attr.value as phone_number,
            addr.country,
            addr.state_province,
            addr.county_district,
            addr.city_village,
            addr.postal_code,
            addr.address1,
            addr.address2,
            addr.address3,
            addr.address4,
            addr.address5,
            addr.address6,
            addr.latitude,
            addr.longitude,
            p.dead,
            p.death_date,
            if(p.birthdate is null or p.death_date is null, null, TIMESTAMPDIFF(YEAR, p.birthdate, p.death_date)) as age_years_at_death,
            if(p.birthdate is null or p.death_date is null, null, TIMESTAMPDIFF(MONTH, p.birthdate, p.death_date)) as age_months_at_death,
            (select cn.name from concept_name cn
             where cn.concept_id = p.cause_of_death and cn.voided = 0
             order by if(cn.concept_name_type='FULLY_SPECIFIED',0,1), if(cn.locale='en',0,1), cn.locale_preferred desc limit 1) as cause_of_death,
            mothers_attr.value as mothers_name,
            fathers_attr.value as fathers_name,
            hc_loc.name as health_center,
            date(pat.date_created) as date_created
from        patient pat
inner join  person p on pat.patient_id = p.person_id
-- Preferred person name
left join   person_name n on n.person_id = p.person_id
            and n.person_name_id = (
                select  n2.person_name_id
                from    person_name n2
                where   n2.voided = 0
                and     n2.person_id = p.person_id
                order by n2.preferred desc, n2.date_created desc limit 1
            )
-- Preferred address
left join   person_address addr on addr.person_id = p.person_id
            and addr.person_address_id = (
                select  a2.person_address_id
                from    person_address a2
                where   a2.voided = 0
                and     a2.person_id = p.person_id
                order by a2.preferred desc, a2.date_created desc limit 1
            )
-- Phone number attribute
left join   person_attribute phone_attr on phone_attr.person_id = p.person_id
            and phone_attr.voided = 0
            and phone_attr.person_attribute_type_id = (
                select  pat2.person_attribute_type_id
                from    person_attribute_type pat2
                where   pat2.name = 'Cell Phone Number' limit 1
            )
-- Mother's name attribute
left join   person_attribute mothers_attr on mothers_attr.person_id = p.person_id
            and mothers_attr.voided = 0
            and mothers_attr.person_attribute_type_id = (
                select  pat2.person_attribute_type_id
                from    person_attribute_type pat2
                where   pat2.name = 'Mother''s Name' limit 1
            )
-- Father's name attribute
left join   person_attribute fathers_attr on fathers_attr.person_id = p.person_id
            and fathers_attr.voided = 0
            and fathers_attr.person_attribute_type_id = (
                select  pat2.person_attribute_type_id
                from    person_attribute_type pat2
                where   pat2.name = '' limit 1
            )
-- Health center attribute (stored as location_id string)
left join   person_attribute hc_attr on hc_attr.person_id = p.person_id
            and hc_attr.voided = 0
            and hc_attr.person_attribute_type_id = (
                select  pat2.person_attribute_type_id
                from    person_attribute_type pat2
                where   pat2.name = 'Health Center' limit 1
            )
left join   location hc_loc on hc_loc.location_id = CAST(hc_attr.value as UNSIGNED)
where       pat.voided = 0
and         p.voided = 0
