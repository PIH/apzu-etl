drop procedure if exists create_survival_analysis_option_b#
create procedure `create_survival_analysis_option_b`(in _endDate date,in _startDate date,in _ageLimit int, in _location varchar(255),in _subgroup varchar(50),in _defaultCutOff int)
begin

	call create_last_art_outcome_at_facility(_endDate,_location);
	insert into survival_analysis (reporting_year, reporting_quarter,subgroup,new_reg,active,died, defaulted,treatment_stopped,transferred_out,location)
    values((select year(_endDate)),(select quarter(_endDate)),_subgroup,0,0,0,0,0,0,_location);
	 
     insert into survival_analysis (reporting_year, reporting_quarter,subgroup,new_reg,active,died, defaulted,treatment_stopped,transferred_out,location)
    select  reporting_year, reporting_quarter,subgroup,new_reg,active,died, defaulted,treatment_stopped,transferred_out,location
from (
	select year(_endDate) as reporting_year,quarter(_endDate) as reporting_quarter, _subgroup as subgroup, lfc.location,
		count(if((art_initial_visit between _startDate and _endDate), 1, null)) as new_reg,
        count(if((state = "On antiretrovirals" and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff), 1, null)) as active,
		count(if((state = "Patient died" and start_date between _startDate and _endDate), 1, null)) as died,
		count(if((state = "Patient defaulted" and start_date between _startDate and _endDate or (state = "On antiretrovirals" and floor(datediff(_endDate,last_appt_date) >  _defaultCutOff)
        or (state = "On antiretrovirals" and last_appt_date is null))), 1, null)) as defaulted,
		count(if((state = "Treatment stopped" and start_date between _startDate and _endDate), 1, null)) as treatment_stopped,
		count(if((state = "Patient transferred out" and start_date between _startDate and _endDate), 1, null)) as transferred_out 
        from last_facility_outcome lfc
join mw_patient mwp  
on mwp.patient_id = lfc.pat
join (
select map.patient_id, map.visit_date as followup_visit_date, map.next_appointment_date as last_appt_date
from mw_art_followup map
join
(
select patient_id,max(visit_date) as visit_date ,max(next_appointment_date) as last_appt_date from mw_art_followup where visit_date <= _endDate
group by patient_id
) map1
on map.patient_id = map1.patient_id and map.visit_date = map1.visit_date) patient_visit
on patient_visit.patient_id = mwp.patient_id
join (
select mar.patient_id, mar.visit_date as art_initial_visit, mar.transfer_in_date, pregnant_or_lactating
from mw_art_initial mar
join
(
select patient_id,max(visit_date) as visit_date  from mw_art_initial where visit_date between _startDate and _endDate
group by patient_id
) mar1
on mar.patient_id = mar1.patient_id) patient_initial_visit
	on patient_initial_visit.patient_id = mwp.patient_id
where floor(datediff(_endDate,mwp.birthdate)/365) <= _ageLimit
and transfer_in_date is null and 
pregnant_or_lactating in ('Currently breastfeeding child','Patient Pregnant') and mwp.patient_id in (
select patient_id from
(
select patient_id, count(*) as number_of_ids from omrs_patient_identifier where type = "ARV Number"
group by patient_id
) x where number_of_ids = 1
)

) survival_analysis;
end
#
