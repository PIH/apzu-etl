drop procedure if exists create_pepfar_tx_hiv_htn_generic#
create procedure `create_pepfar_tx_hiv_htn_generic`(in _startDate date,in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int, in _ageGroup varchar(15))
begin

call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);

insert into pepfar_tx_hiv_htn(age_group,gender,tx_curr,diagnosed_htn,screened_for_htn,
newly_diagnosed,controlled_htn)

select "All" as age_group, _ageGroup as gender,
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
hiv_cohort where  
	(case 
		when _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F"
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		when _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		when _ageGroup = "Male"  then gender = "M"
	 end);
end
#
