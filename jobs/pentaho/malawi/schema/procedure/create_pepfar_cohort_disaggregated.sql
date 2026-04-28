CREATE PROCEDURE `create_pepfar_cohort_disaggregated`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT)
BEGIN

call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);

insert into pepfar_cohort_disaggregated(sort_value,age_group,gender,tx_curr,
0A,2A,4A,5A,6A,7A,8A,9A,10A,11A,12A,13A,14A,15A,16A,17A,0P,2P,4PP,4PA,9PP,9PA,11PP,11PA,12PP,12PA,14PP,
14PA,15P,15PP,15PA,16P,17PP,17PA,non_standard
)
select sort_value,x.age_group, x.gender_full, 
CASE WHEN active is null then 0 else active end as tx_curr,
CASE WHEN 0A is null then 0 else 0A end as 0A,
CASE WHEN 2A is null then 0 else 2A end as 2A,
CASE WHEN 4A is null then 0 else 4A end as 4A,
CASE WHEN 5A is null then 0 else 5A end as 5A,
CASE WHEN 6A is null then 0 else 6A end as 6A,
CASE WHEN 7A is null then 0 else 7A end as 7A,
CASE WHEN 8A is null then 0 else 8A end as 8A,
CASE WHEN 9A is null then 0 else 9A end as 9A,
CASE WHEN 10A is null then 0 else 10A end as 10A,
CASE WHEN 11A is null then 0 else 11A end as 11A,
CASE WHEN 12A is null then 0 else 12A end as 12A,
CASE WHEN 13A is null then 0 else 13A end as 13A,
CASE WHEN 14A is null then 0 else 14A end as 14A,
CASE WHEN 15A is null then 0 else 15A end as 15A,
CASE WHEN 16A is null then 0 else 16A end as 16A,
CASE WHEN 17A is null then 0 else 17A end as 17A,
CASE WHEN 0P is null then 0 else 0P end as 0P,
CASE WHEN 2P is null then 0 else 2P end as 2P,
CASE WHEN 4PP is null then 0 else 4PP end as 4PP,
CASE WHEN 4PA is null then 0 else 4PA end as 4PA,
CASE WHEN 9PP is null then 0 else 9PP end as 9PP,
CASE WHEN 9PA is null then 0 else 9PA end as 9PA,
CASE WHEN 11PP is null then 0 else 11PP end as 11PP,
CASE WHEN 11PA is null then 0 else 11PA end as 11PA,
CASE WHEN 12PP is null then 0 else 12PP end as 12PP,
CASE WHEN 12PA is null then 0 else 12PA end as 12PA,
CASE WHEN 14PP is null then 0 else 14PP end as 14PP,
CASE WHEN 14PA is null then 0 else 14PA end as 14PA,
CASE WHEN 15P is null then 0 else 15P end as 15P,
CASE WHEN 15PP is null then 0 else 15PP end as 15PP,
CASE WHEN 15PA is null then 0 else 15PA end as 15PA,
CASE WHEN 16P is null then 0 else 16P end as 16P,
CASE WHEN 17PP is null then 0 else 17PP end as 17PP,
CASE WHEN 17PA is null then 0 else 17PA end as 17PA,
CASE WHEN non_standard is null then 0 else non_standard end as non_standard
from
age_groups as x
LEFT OUTER JOIN
(
SELECT CASE
	WHEN age <= 11 and gender = "M" THEN "< 1 year"
	WHEN age <= 11 and gender = "F" THEN "< 1 year"
	WHEN age >=12 and age <= 59 and gender = "M" THEN "1-4 years"
	WHEN age >=12 and age <= 59 and gender = "F" THEN "1-4 years"
	WHEN age >=60 and age <= 119 and gender = "M" THEN "5-9 years"
	WHEN age >=60 and age <= 119 and gender = "F" THEN "5-9 years"
	WHEN age >=120 and age <= 179 and gender = "M" THEN "10-14 years"
	WHEN age >=120 and age <= 179 and gender = "F" THEN "10-14 years"
	WHEN age >=180 and age <= 239 and gender = "M" THEN "15-19 years"
	WHEN age >=180 and age <= 239 and gender = "F" THEN "15-19 years"
	WHEN age >=240 and age <= 299 and gender = "M" THEN "20-24 years"
	WHEN age >=240 and age <= 299 and gender = "F" THEN "20-24 years"
	WHEN age >=300 and age <= 359 and gender = "M" THEN "25-29 years"
	WHEN age >=300 and age <= 359 and gender = "F" THEN "25-29 years"
	WHEN age >=360 and age <= 419 and gender = "M" THEN "30-34 years"
	WHEN age >=360 and age <= 419 and gender = "F" THEN "30-34 years"
	WHEN age >=420 and age <= 479 and gender = "M" THEN "35-39 years"
	WHEN age >=420 and age <= 479 and gender = "F" THEN "35-39 years"
	WHEN age >=480 and age <= 539 and gender = "M" THEN "40-44 years"
	WHEN age >=480 and age <= 539 and gender = "F" THEN "40-44 years"
	WHEN age >=540 and age <= 599 and gender = "M" THEN "45-49 years"
	WHEN age >=540 and age <= 599 and gender = "F" THEN "45-49 years"
	WHEN age >=600 and age <= 659 and gender = "M" THEN "50-54 years"
	WHEN age >=600 and age <= 659 and gender = "F" THEN "50-54 years"
	WHEN age >=660 and age <= 719 and gender = "M" THEN "55-59 years"
	WHEN age >=660 and age <= 719 and gender = "F" THEN "55-59 years"
	WHEN age >=720 and age <= 779 and gender = "M" THEN "60-64 years"
	WHEN age >=720 and age <= 779 and gender = "F" THEN "60-64 years"
	WHEN age >=780 and age <= 839 and gender = "M" THEN "65-69 years"
	WHEN age >=780 and age <= 839 and gender = "F" THEN "65-69 years"
	WHEN age >=840 and age <= 899 and gender = "M" THEN "70-74 years"
	WHEN age >=840 and age <= 899 and gender = "F" THEN "70-74 years"
	WHEN age >=900 and age <= 959 and gender = "M" THEN "75-79 years"
	WHEN age >=900 and age <= 959 and gender = "F" THEN "75-79 years"
	WHEN age >=960 and age <= 1019 and gender = "M" THEN "80-84 years"
	WHEN age >=960 and age <= 1019 and gender = "F" THEN "80-84 years"
	WHEN age >=1020 and age <= 1079 and gender = "M" THEN "85-89 years"
	WHEN age >=1020 and age <= 1079 and gender = "F" THEN "85-89 years"
	WHEN age >=1080 and gender = "M" THEN "90 plus years"
	WHEN age >=1080 and gender = "F" THEN "90 plus years"
END as age_group,gender as "gender",
    COUNT(IF((state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff), 1, NULL)) as active,
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
	select * from hiv_cohort
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;
 
 END
