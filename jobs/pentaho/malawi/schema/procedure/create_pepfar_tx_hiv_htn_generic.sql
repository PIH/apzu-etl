CREATE PROCEDURE `create_pepfar_tx_hiv_htn_generic`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT, IN _ageGroup varchar(15))
BEGIN

call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);

insert into pepfar_tx_hiv_htn(age_group,gender,tx_curr,diagnosed_htn,screened_for_htn,
newly_diagnosed,controlled_htn)

SELECT "All" as age_group, _ageGroup as gender,
COUNT(IF((state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) <=  @defaultOneMonth), 1, NULL)) as tx_curr,

    COUNT(IF((systolic_bp >= 140 OR diastolic_bp >= 90) AND patient_id NOT IN (
    select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, NULL)) as diagnosed_htn,

    COUNT(IF(followup_visit_date BETWEEN @startDate AND @endDate and patient_id NOT IN (
    select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and (systolic_bp is not null OR diastolic_bp is not null)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, NULL)) as screened_for_htn,

    COUNT(IF(initial_visit_date BETWEEN @startDate AND @endDate and transfer_in_date is null
    and (systolic_bp >= 140 OR diastolic_bp >= 90)
    and patient_id NOT IN (select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, NULL)) as newly_diagnosed,

    COUNT(IF(followup_visit_date BETWEEN @startDate AND @endDate and patient_id NOT IN (
    select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and (systolic_bp < 140 AND diastolic_bp < 90)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location), 1, NULL)) as controlled_htn
from
hiv_cohort where  
	(case 
		WHEN _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F"
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		WHEN _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		WHEN _ageGroup = "Male"  then gender = "M"
	 end);
END
