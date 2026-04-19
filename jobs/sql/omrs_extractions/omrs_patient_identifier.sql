select      i.patient_identifier_id,
            i.uuid,
            p.patient_id,
            pit.name as type,
            i.identifier,
            l.name as location,
            date(i.date_created) as date_created
from        patient p
inner join  patient_identifier i on i.patient_id = p.patient_id
left join   patient_identifier_type pit on pit.patient_identifier_type_id = i.identifier_type
left join   location l on l.location_id = i.location_id
where       i.voided = 0
and         p.voided = 0
and         i.identifier is not null
and         i.identifier != ''
