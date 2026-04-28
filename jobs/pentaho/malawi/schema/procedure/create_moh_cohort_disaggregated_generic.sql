CREATE PROCEDURE `create_moh_cohort_disaggregated_generic`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT,
IN _ageGroup varchar(15))
BEGIN
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);

insert into moh_cohort_disaggregated(age_group,gender,tx_curr,
0A,2A,4A,5A,6A,7A,8A,9A,10A,11A,12A,13A,14A,15A,16A,17A,0P,2P,4PP,4PA,9PP,9PA,11PP,11PA,12PP,12PA,14PP,
14PA,15P,15PP,15PA,16P,17PP,17PA,non_standard)

SELECT "All" as age_group, _ageGroup as gender,
    COUNT(IF((state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff), 1, NULL)) as tx_curr,
     COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '0A: ABC/3TC + NVP', 1, NULL)) as 0A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '2A: AZT / 3TC / NVP (previous AZT)', 1, NULL)) as 2A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '4A: AZT / 3TC + EFV (previous AZTEFV)', 1, NULL)) as 4A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '5A: TDF / 3TC / EFV', 1, NULL)) as 5A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '6A: TDF / 3TC + NVP' , 1, NULL)) as 6A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '7A: TDF / 3TC + ATV/r', 1, NULL)) as 7A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '8A: AZT / 3TC + ATV/r', 1, NULL)) as 8A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '9A: ABC / 3TC + LPV/r', 1, NULL)) as 9A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '10A: TDF / 3TC + LPV/r', 1, NULL)) as 10A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '11A: AZT / 3TC + LPV'  , 1, NULL)) as 11A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '12A: DRV + r + DTG' , 1, NULL)) as 12A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '13A: TDF / 3TC / DTG', 1, NULL)) as 13A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '14A: AZT / 3TC + DTG' , 1, NULL)) as 14A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '15A: ABC / 3TC + DTG', 1, NULL)) as 15A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '16A: ABC / 3TC + RAL' , 1, NULL)) as 16A,
    COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '17A: ABC / 3TC + EFV', 1, NULL)) as 17A,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '0P: ABC/3TC + NVP' , 1, NULL)) as 0P,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '2P: AZT / 3TC / NVP' , 1, NULL)) as 2P,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "4PP: AZT 60 / 3TC 30 + EFV 200" , 1, NULL)) as 4PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "4PA: AZT 300 / 3TC 150 + EFV 200", 1, NULL)) as 4PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '9PP: ABC 120 / 3TC 60 + LPV/r 100/25', 1, NULL)) as 9PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '9PA: ABC 600 / 3TC 300 + LPV/r 100/25', 1, NULL)) as 9PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "11PP: AZT 60 / 3TC 30 + LPV/r 100/25" , 1, NULL)) as 11PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "11PA: AZT 300 / 3TC 150 + LPV/r 100/25", 1, NULL)) as 11PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "12PP: DRV 150 + r 50 + DTG 10 (± NRTIs)", 1, NULL)) as 12PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "12PA: DRV 150 + r 50 + DTG 50", 1, NULL)) as 12PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "14PP: AZT 60 / 3TC 30 + DTG 10", 1, NULL)) as 14PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "14PA: AZT 60 / 3TC 30 + DTG 50", 1, NULL)) as 14PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '15P: ABC / 3TC + DTG', 1, NULL)) as 15P,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '15PP: ABC / 3TC + DTG', 1, NULL)) as 15PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "15PA: ABC 120 / 3TC 60 + DTG 50", 1, NULL)) as 15PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "16P: ABC / 3TC + RAL", 1, NULL)) as 16P,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "17PP: ABC 120 / 3TC 60 + EFV 200", 1, NULL)) as 17PP,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "17PA: ABC 600 / 3TC 300 + EFV 200", 1, NULL)) as 17PA,
COUNT(IF(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = 'Non standard', 1, NULL)) as non_standard
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
