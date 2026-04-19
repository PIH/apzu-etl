drop procedure if exists create_moh_tx_new_generic#
create  procedure `create_moh_tx_new_generic`(in _startDate date,in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int, in _ageGroup varchar(15))
begin
call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);


insert into moh_tx_new(age_group,gender, tx_new_cd4_less_than_two_hundred,
         tx_new_cd4_equal_to_or_greater_than_two_hundred, tx_new_cd4_equal_unknown_or_not_done, transfer_ins)

select "All" as age_group,  _ageGroup as gender,
    count(if(cd4_count < 200 and (
    initial_visit_date between @startDate and @endDate and mai.transfer_in_date is null and mai.patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as tx_new_cd4_less_than_two_hundred,

    count(if(cd4_count >= 200 and (
    initial_visit_date between @startDate and @endDate and mai.transfer_in_date is null and mai.patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as tx_new_cd4_equal_to_or_greater_than_two_hundred,

	count(if(cd4_count is null and (
    initial_visit_date between @startDate and @endDate and mai.transfer_in_date is null and mai.patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as tx_new_cd4_equal_unknown_or_not_done,

    count(if(mai.transfer_in_date is not null
    and (
    initial_visit_date between @startDate and @endDate and mai.patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as transfer_ins
from mw_art_initial mai
join
(
  select * from hiv_cohort where  
	(case 
		when _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F" 
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		when _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		when _ageGroup = "Male"  then gender = "M"
	 end)
)sub1 on sub1.patient_id=mai.patient_id;
end
#
