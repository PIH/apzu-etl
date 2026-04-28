CREATE PROCEDURE `create_pepfar_tx_tb_generic`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT,
IN _ageGroup varchar(15))
BEGIN

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_tb(age_group, gender,tx_curr,symptom_screen_alone,cxr_screen,mwrd_screen,
screened_for_tb_tx_new_pos,screened_for_tb_tx_new_neg,screened_for_tb_tx_prev_pos,screened_for_tb_tx_prev_neg,tb_rx_new,tb_rx_prev)

SELECT "All" as age_group, _ageGroup as gender,
    COUNT(IF((state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) <=  @defaultOneMonth), 1, NULL)) as tx_curr,
    COUNT(if(tb_status in ("TB suspected","TB NOT suspected","Confirmed TB on treatment","Confirmed TB NOT on treatment"),1,NULL)) as symptom_screen_alone,
    "0" as cxr_screen,
	"0" as mwrd_screen,
    COUNT(IF(tb_status = "TB suspected" and (
    initial_visit_date BETWEEN @startDate AND @endDate and transfer_in_date is null and patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as screened_for_tb_tx_new_pos,
    COUNT(IF(tb_status = "TB NOT suspected" and (
    initial_visit_date BETWEEN @startDate AND @endDate and transfer_in_date is null and patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as screened_for_tb_tx_new_neg,
    COUNT(IF(tb_status = "TB suspected"
    and
    initial_visit_date < @startDate
    , 1, NULL)) as screened_for_tb_tx_prev_pos,
    COUNT(IF(tb_status = "TB NOT suspected"
    and
    initial_visit_date < @startDate
    , 1, NULL)) as screened_for_tb_tx_prev_neg,
    COUNT(IF(tb_status = "Confirmed TB on treatment"
    and (
    initial_visit_date BETWEEN @startDate AND @endDate and transfer_in_date is null and patient_id NOT IN (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id IN(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, NULL)) as tb_rx_new,
    COUNT(IF(tb_status = "Confirmed TB NOT on treatment"
    and (
    initial_visit_date < @startDate
    )
    , 1, NULL)) as tb_rx_prev

from
(
	select * from hiv_cohort where  
	(case 
		WHEN _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F"
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		WHEN _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		WHEN _ageGroup = "Male"  then gender = "M"
	 end)
    
) sub1;

END
