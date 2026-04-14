SELECT      p.person_id as patient_id,
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
            IF(p.birthdate IS NULL OR p.death_date IS NULL, NULL, TIMESTAMPDIFF(YEAR, p.birthdate, p.death_date)) as age_years_at_death,
            IF(p.birthdate IS NULL OR p.death_date IS NULL, NULL, TIMESTAMPDIFF(MONTH, p.birthdate, p.death_date)) as age_months_at_death,
            (SELECT cn.name FROM concept_name cn
             WHERE cn.concept_id = p.cause_of_death AND cn.voided = 0
             ORDER BY IF(cn.concept_name_type='FULLY_SPECIFIED',0,1), IF(cn.locale='en',0,1), cn.locale_preferred DESC LIMIT 1) as cause_of_death,
            mothers_attr.value as mothers_name,
            fathers_attr.value as fathers_name,
            hc_loc.name as health_center,
            DATE(pat.date_created) as date_created
FROM        patient pat
INNER JOIN  person p ON pat.patient_id = p.person_id
-- Preferred person name
LEFT JOIN   person_name n ON n.person_id = p.person_id
            AND n.person_name_id = (
                SELECT  n2.person_name_id
                FROM    person_name n2
                WHERE   n2.voided = 0
                AND     n2.person_id = p.person_id
                ORDER BY n2.preferred DESC, n2.date_created DESC LIMIT 1
            )
-- Preferred address
LEFT JOIN   person_address addr ON addr.person_id = p.person_id
            AND addr.person_address_id = (
                SELECT  a2.person_address_id
                FROM    person_address a2
                WHERE   a2.voided = 0
                AND     a2.person_id = p.person_id
                ORDER BY a2.preferred DESC, a2.date_created DESC LIMIT 1
            )
-- Phone number attribute
LEFT JOIN   person_attribute phone_attr ON phone_attr.person_id = p.person_id
            AND phone_attr.voided = 0
            AND phone_attr.person_attribute_type_id = (
                SELECT  pat2.person_attribute_type_id
                FROM    person_attribute_type pat2
                WHERE   pat2.name = 'Cell Phone Number' LIMIT 1
            )
-- Mother's name attribute
LEFT JOIN   person_attribute mothers_attr ON mothers_attr.person_id = p.person_id
            AND mothers_attr.voided = 0
            AND mothers_attr.person_attribute_type_id = (
                SELECT  pat2.person_attribute_type_id
                FROM    person_attribute_type pat2
                WHERE   pat2.name = 'Mother''s Name' LIMIT 1
            )
-- Father's name attribute
LEFT JOIN   person_attribute fathers_attr ON fathers_attr.person_id = p.person_id
            AND fathers_attr.voided = 0
            AND fathers_attr.person_attribute_type_id = (
                SELECT  pat2.person_attribute_type_id
                FROM    person_attribute_type pat2
                WHERE   pat2.name = '' LIMIT 1
            )
-- Health center attribute (stored as location_id string)
LEFT JOIN   person_attribute hc_attr ON hc_attr.person_id = p.person_id
            AND hc_attr.voided = 0
            AND hc_attr.person_attribute_type_id = (
                SELECT  pat2.person_attribute_type_id
                FROM    person_attribute_type pat2
                WHERE   pat2.name = 'Health Center' LIMIT 1
            )
LEFT JOIN   location hc_loc ON hc_loc.location_id = CAST(hc_attr.value AS UNSIGNED)
WHERE       pat.voided = 0
AND         p.voided = 0
