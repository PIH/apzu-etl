drop procedure if exists create_pepfar_tx_hiv_htn#
create procedure `create_pepfar_tx_hiv_htn`(in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int)
begin

call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);

insert into pepfar_tx_hiv_htn(sort_value,age_group,gender,tx_curr,diagnosed_htn,screened_for_htn,
newly_diagnosed,controlled_htn)

select sort_value,x.age_group, case when x.gender="F" then 'Female' else 'Male' end as gender,
case when tx_curr is null then 0 else tx_curr end as tx_curr,
case when diagnosed_htn is null then 0 else diagnosed_htn end as diagnosed_htn,
case when screened_for_htn is null then 0 else screened_for_htn end as screened_for_htn,
case when newly_diagnosed is null then 0 else newly_diagnosed end as newly_diagnosed,
case when controlled_htn is null then 0 else controlled_htn end as controlled_htn
 from
age_groups as x
left outer join
(
select case
	when age <= 11 and gender = "M" then "< 1 year"
	when age <= 11 and gender = "F" then "< 1 year"
	when age >=12 and age <= 59 and gender = "M" then "1-4 years"
	when age >=12 and age <= 59 and gender = "F" then "1-4 years"
	when age >=60 and age <= 119 and gender = "M" then "5-9 years"
	when age >=60 and age <= 119 and gender = "F" then "5-9 years"
	when age >=120 and age <= 179 and gender = "M" then "10-14 years"
	when age >=120 and age <= 179 and gender = "F" then "10-14 years"
	when age >=180 and age <= 239 and gender = "M" then "15-19 years"
	when age >=180 and age <= 239 and gender = "F" then "15-19 years"
	when age >=240 and age <= 299 and gender = "M" then "20-24 years"
	when age >=240 and age <= 299 and gender = "F" then "20-24 years"
	when age >=300 and age <= 359 and gender = "M" then "25-29 years"
	when age >=300 and age <= 359 and gender = "F" then "25-29 years"
	when age >=360 and age <= 419 and gender = "M" then "30-34 years"
	when age >=360 and age <= 419 and gender = "F" then "30-34 years"
	when age >=420 and age <= 479 and gender = "M" then "35-39 years"
	when age >=420 and age <= 479 and gender = "F" then "35-39 years"
	when age >=480 and age <= 539 and gender = "M" then "40-44 years"
	when age >=480 and age <= 539 and gender = "F" then "40-44 years"
	when age >=540 and age <= 599 and gender = "M" then "45-49 years"
	when age >=540 and age <= 599 and gender = "F" then "45-49 years"
	when age >=600 and age <= 659 and gender = "M" then "50-54 years"
	when age >=600 and age <= 659 and gender = "F" then "50-54 years"
	when age >=660 and age <= 719 and gender = "M" then "55-59 years"
	when age >=660 and age <= 719 and gender = "F" then "55-59 years"
	when age >=720 and age <= 779 and gender = "M" then "60-64 years"
	when age >=720 and age <= 779 and gender = "F" then "60-64 years"
	when age >=780 and age <= 839 and gender = "M" then "65-69 years"
	when age >=780 and age <= 839 and gender = "F" then "65-69 years"
	when age >=840 and age <= 899 and gender = "M" then "70-74 years"
	when age >=840 and age <= 899 and gender = "F" then "70-74 years"
	when age >=900 and age <= 959 and gender = "M" then "75-79 years"
	when age >=900 and age <= 959 and gender = "F" then "75-79 years"
	when age >=960 and age <= 1019 and gender = "M" then "80-84 years"
	when age >=960 and age <= 1019 and gender = "F" then "80-84 years"
	when age >=1020 and age <= 1079 and gender = "M" then "85-89 years"
	when age >=1020 and age <= 1079 and gender = "F" then "85-89 years"
	when age >=1080 and gender = "M" then "90 plus years"
	when age >=1080 and gender = "F" then "90 plus years"
end as age_group,gender,
    count(if((state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) <=  @defaultOneMonth), 1, null)) as tx_curr,

    count(if((systolic_bp >= 140 or diastolic_bp >= 90) and patient_id not in (
    select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, null)) as diagnosed_htn,

    count(if(followup_visit_date between @startDate and @endDate and patient_id not in (
    select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and (systolic_bp is not null or diastolic_bp is not null)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, null)) as screened_for_htn,

    count(if(initial_visit_date between @startDate and @endDate and transfer_in_date is null
    and (systolic_bp >= 140 or diastolic_bp >= 90)
    and patient_id not in (select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, null)) as newly_diagnosed,

    count(if(followup_visit_date between @startDate and @endDate and patient_id not in (
    select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and (systolic_bp < 140 and diastolic_bp < 90)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, null)) as controlled_htn

from
(
select distinct(mwp.patient_id), opi.identifier, mwp.first_name, mwp.last_name, ops.program, ops.state,ops.start_date,program_state_id,  mwp.gender,
 if(ops.state = "On antiretrovirals",floor(datediff(@endDate,mwp.birthdate)/@birthDateDivider),floor(datediff(ops.start_date,mwp.birthdate)/@birthDateDivider)) as age,
 ops.location, patient_visit.last_appt_date, patient_visit.art_regimen as current_regimen,
 patient_visit.pregnant_or_lactating, patient_initial_visit.initial_pregnant_or_lactating, patient_visit.followup_visit_date, patient_initial_visit.initial_visit_date,
 patient_initial_visit.transfer_in_date, systolic_bp, diastolic_bp
from  mw_patient mwp
left join (
    select map.patient_id, map.visit_date as followup_visit_date, map.next_appointment_date as last_appt_date, map.art_regimen,
    map.pregnant_or_lactating, systolic_bp, diastolic_bp
    from mw_art_followup map
join
(
    select patient_id,max(visit_date) as visit_date ,max(next_appointment_date) as last_appt_date from mw_art_followup where visit_date <= @endDate
    group by patient_id
    ) map1
on map.patient_id = map1.patient_id and map.visit_date = map1.visit_date) patient_visit
            on patient_visit.patient_id = mwp.patient_id
left join (
    select mar.patient_id, mar.visit_date as initial_visit_date,
    mar.pregnant_or_lactating as initial_pregnant_or_lactating, mar.transfer_in_date
    from mw_art_initial mar
join
(
    select patient_id,max(visit_date) as visit_date  from mw_art_initial where visit_date <= @endDate
    group by patient_id
    ) mar1
on mar.patient_id = mar1.patient_id and mar.visit_date = mar1.visit_date) patient_initial_visit
            on patient_initial_visit.patient_id = mwp.patient_id
join omrs_patient_identifier opi
on mwp.patient_id = opi.patient_id

join
         last_facility_outcome as ops
            on opi.patient_id = ops.pat and opi.location = ops.location
            where opi.type = "ARV Number"
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;

end
#
