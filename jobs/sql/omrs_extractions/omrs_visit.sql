select      v.visit_id,
            v.uuid,
            v.patient_id,
            vt.name as visit_type,
            l.name as location,
            date(v.date_started) as date_started,
            date(v.date_stopped) as date_stopped,
            date(v.date_created) as date_created
from        visit v
left join   visit_type vt on vt.visit_type_id = v.visit_type_id
left join   location l on l.location_id = v.location_id
where       v.voided = 0
