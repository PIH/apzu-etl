drop procedure if exists create_changed_regimen_list#
create procedure `create_changed_regimen_list`(in _startDate date,in _location varchar(100))
begin
    insert into regimen_switch (identifier, gender, dob,art_start_date,weight,previous_regimen,
    current_regimen, dispense_date,arvs,arvs_given,location)
    select identifier, gender, dob,art_start_date,weight,previous_regimen,
    current_regimen, dispense_date,arvs,arvs_given,location
    from (
select x.identifier,x.gender,x.dob,
 DATE_FORMAT(mai.visit_date, "%d-%b-%y") as art_start_date,x.weight,x.previous_regimen, 
x.current_regimen,x.dispense_date,x.arvs,x.arvs_given, x.location 
from
mw_art_initial mai
join
(
select mav2.patient_id,opi.identifier,
case when mwp.gender='F' then 'Female'
else 'Male' end as gender,DATE_FORMAT(mwp.birthdate, "%d-%b-%y") as dob,
 mav.weight,substring_index(mav2.art_regimen,':',1) as previous_regimen, DATE_FORMAT(mav.last_visit_date, "%d-%b-%y") as dispense_date,
substring_index(mav.current_regimen,':',1) as current_regimen,concat(substring_index(mav.current_regimen,':',-1)," (",mav.arvs_given,")") as arvs,mav.arvs_given, mav.location
             from mw_art_followup mav2
             join 
             (
				select patient_id, max(visit_date) as last_visit_date from mw_art_visits mav
				where mav.visit_date < _startDate
				group by patient_id) as x 
				on mav2.patient_id = x.patient_id
				and mav2.visit_date = x.last_visit_date
			join (
				select mav2.patient_id, mav2.art_regimen as current_regimen,mav2.arvs_given, mav2.visit_date as last_visit_date,
                mav2.location,mav2.weight
             from mw_art_followup mav2
             join 
             (
				select patient_id, min(visit_date) as last_visit_date from mw_art_visits mav
				where mav.visit_date >= _startDate and mav.visit_date < DATE_ADD(_startDate, INTERVAL 1 month)
				group by patient_id) as x 
				on mav2.patient_id = x.patient_id
				and mav2.visit_date = x.last_visit_date
            ) as mav
            on mav.patient_id = mav2.patient_id
			join omrs_patient_identifier opi on opi.patient_id = mav.patient_id 
            and opi.type = "ARV Number"
			and opi.location = get_parent_health_facility(mav.location)
            join mw_patient mwp
            on mwp.patient_id = opi.patient_id
            where mav2.art_regimen != mav.current_regimen
            and mav.last_visit_date >= _startDate
            and opi.location = _location
) x
on mai.patient_id = x.patient_id ) switch;

end
#
