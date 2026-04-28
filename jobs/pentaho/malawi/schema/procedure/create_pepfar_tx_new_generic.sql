CREATE PROCEDURE `create_pepfar_tx_new_generic`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT, IN _ageGroup varchar(15))
BEGIN
call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);


insert into pepfar_tx_new(age_group,gender, tx_new_cd4_less_than_two_hundred,
         tx_new_cd4_equal_to_or_greater_than_two_hundred, tx_new_cd4_equal_unknown_or_not_done, transfer_ins)

SELECT "All" as age_group, _ageGroup as gender,
    COUNT(IF(cd4_count < 200 and (
    initial_visit_date BETWEEN @startDate AND @endDate and mai.transfer_in_date is null and mai.patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as tx_new_cd4_less_than_two_hundred,

    COUNT(IF(cd4_count >= 200 and (
    initial_visit_date BETWEEN @startDate AND @endDate and mai.transfer_in_date is null and mai.patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as tx_new_cd4_equal_to_or_greater_than_two_hundred,

	COUNT(IF(cd4_count is null and (
    initial_visit_date BETWEEN @startDate AND @endDate and mai.transfer_in_date is null and mai.patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as tx_new_cd4_equal_unknown_or_not_done,

    COUNT(IF(mai.transfer_in_date is not null
    and (
    initial_visit_date BETWEEN @startDate AND @endDate and mai.patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and mai.patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as transfer_ins
from mw_art_initial mai
join
(
  select * from hiv_cohort where  
	(case 
		WHEN _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F"
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		WHEN _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		WHEN _ageGroup = "Male"  then gender = "M"
	 end)
)sub1 on sub1.patient_id=mai.patient_id;
END
