-- create temporary table to hold all data
drop temporary table if exists temp_art_regimens;
create temporary table temp_art_regimens
(art_followup_visit_id int(11),
patient_id int(11),
visit_date date,
location varchar(255),
next_appointment_date date,
art_drugs_received varchar(255),
art_regimen varchar(255),
previous_visit_date date,
previous_art_regimen varchar(255)
);

-- populate temp table
insert temp_art_regimens(art_followup_visit_id, patient_id, visit_date, location, next_appointment_date, art_drugs_received, art_regimen )
select art_followup_visit_id, patient_id, visit_date, location, next_appointment_date, art_drugs_received, art_regimen 
from mw_art_followup af;

-- need to create a duplicate table since MySQL does not allow referencing a temporary table more than once in query
drop temporary table if exists temp_art_regimens_duplicate;
create temporary table temp_art_regimens_duplicate
select art_followup_visit_id, patient_id, visit_date, art_regimen from temp_art_regimens;

-- not sure ALL these indexes are needed?
create index temp_art_regimens_vd on temp_art_regimens(visit_date);
create index temp_art_regimens_duplicate_vd on temp_art_regimens_duplicate(visit_date);
create index temp_art_regimens_c1 on temp_art_regimens(patient_id, visit_date);
create index temp_art_regimens_duplicate_c1 on temp_art_regimens_duplicate(patient_id, visit_date);

-- populate previous visit_id
update temp_art_regimens t
set previous_visit_date = 
	(select max(visit_date) from temp_art_regimens_duplicate t2 
	where t2.patient_id = t.patient_id
	and t2.visit_date < t.visit_date
	and t2.art_regimen is not null); -- not sure this logic is correct?

-- populate previous regimen
update temp_art_regimens t
inner join temp_art_regimens_duplicate t2 on t.patient_id = t2.patient_id and t2.visit_date = t.previous_visit_date
set t.previous_art_regimen = t2.art_regimen;

-- create list of DISTINCT visits (by patient_id, visit_date)
drop temporary table if exists temp_art_regimens_distinct;
create temporary table temp_art_regimens_distinct
select max(art_followup_visit_id) as art_followup_visit_id, patient_id, visit_date
from temp_art_regimens
group by patient_id, visit_date;
create index temp_art_regimens_distinct_c1 on temp_art_regimens_distinct(patient_id, visit_date, art_followup_visit_id);

-- final select of output

drop table if exists mw_art_regimen_changes;
create table mw_art_regimen_changes as
select  
    t.art_followup_visit_id,
    t.patient_id,
    t.visit_date,
    t.location,
    t.next_appointment_date,
    t.art_drugs_received,
    t.art_regimen,
    t.previous_art_regimen,
CASE
  WHEN
    t.previous_art_regimen IS NOT NULL
                AND t.art_regimen <> t.previous_art_regimen
        THEN
            'Yes'
        ELSE 'No'
   END AS Switched_Regimen
 from temp_art_regimens t
 inner join temp_art_regimens_distinct d  -- ensure no duplicates are returned
 	on d.patient_id = t.patient_id
 	and d.visit_date = t.visit_date
 	and d.art_followup_visit_id = t.art_followup_visit_id
where t.previous_art_regimen IS NOT NULL  -- ensure only switched regimens are returned
  AND t.art_regimen <> t.previous_art_regimen
;
