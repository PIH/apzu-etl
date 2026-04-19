drop procedure if exists create_moh_cohort_disaggregated#
create procedure `create_moh_cohort_disaggregated`(in _startDate date,in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int)
begin
call create_age_groups();
call create_last_art_outcome_at_facility(_endDate,_location);
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);
insert into moh_cohort_disaggregated(sort_value,age_group,gender,tx_curr,
0A,2A,4A,5A,6A,7A,8A,9A,10A,11A,12A,13A,14A,15A,16A,17A,0P,2P,4PP,4PA,9PP,9PA,11PP,11PA,12PP,12PA,14PP,
14PA,15P,15PP,15PA,16P,17PP,17PA,non_standard)
select sort_value,x.age_group, x.gender_full, 
case when active is null then 0 else active end as tx_curr,
case when 0A is null then 0 else 0A end as 0A,
case when 2A is null then 0 else 2A end as 2A,
case when 4A is null then 0 else 4A end as 4A,
case when 5A is null then 0 else 5A end as 5A,
case when 6A is null then 0 else 6A end as 6A,
case when 7A is null then 0 else 7A end as 7A,
case when 8A is null then 0 else 8A end as 8A,
case when 9A is null then 0 else 9A end as 9A,
case when 10A is null then 0 else 10A end as 10A,
case when 11A is null then 0 else 11A end as 11A,
case when 12A is null then 0 else 12A end as 12A,
case when 13A is null then 0 else 13A end as 13A,
case when 14A is null then 0 else 14A end as 14A,
case when 15A is null then 0 else 15A end as 15A,
case when 16A is null then 0 else 16A end as 16A,
case when 17A is null then 0 else 17A end as 17A,
case when 0P is null then 0 else 0P end as 0P,
case when 2P is null then 0 else 2P end as 2P,
case when 4PP is null then 0 else 4PP end as 4PP,
case when 4PA is null then 0 else 4PA end as 4PA,
case when 9PP is null then 0 else 9PP end as 9PP,
case when 9PA is null then 0 else 9PA end as 9PA,
case when 11PP is null then 0 else 11PP end as 11PP,
case when 11PA is null then 0 else 11PA end as 11PA,
case when 12PP is null then 0 else 12PP end as 12PP,
case when 12PA is null then 0 else 12PA end as 12PA,
case when 14PP is null then 0 else 14PP end as 14PP,
case when 14PA is null then 0 else 14PA end as 14PA,
case when 15P is null then 0 else 15P end as 15P,
case when 15PP is null then 0 else 15PP end as 15PP,
case when 15PA is null then 0 else 15PA end as 15PA,
case when 16P is null then 0 else 16P end as 16P,
case when 17PP is null then 0 else 17PP end as 17PP,
case when 17PA is null then 0 else 17PA end as 17PA,
case when non_standard is null then 0 else non_standard end as non_standard
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
end as age_group,gender as "gender",
    count(if((state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff), 1, null)) as active,
        count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '0A: ABC/3TC + NVP', 1, null)) as 0A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '2A: AZT / 3TC / NVP (previous AZT)', 1, null)) as 2A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '4A: AZT / 3TC + EFV (previous AZTEFV)', 1, null)) as 4A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '5A: TDF / 3TC / EFV', 1, null)) as 5A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '6A: TDF / 3TC + NVP' , 1, null)) as 6A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '7A: TDF / 3TC + ATV/r', 1, null)) as 7A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '8A: AZT / 3TC + ATV/r', 1, null)) as 8A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '9A: ABC / 3TC + LPV/r', 1, null)) as 9A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '10A: TDF / 3TC + LPV/r', 1, null)) as 10A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '11A: AZT / 3TC + LPV'  , 1, null)) as 11A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '12A: DRV + r + DTG' , 1, null)) as 12A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '13A: TDF / 3TC / DTG', 1, null)) as 13A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '14A: AZT / 3TC + DTG' , 1, null)) as 14A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '15A: ABC / 3TC + DTG', 1, null)) as 15A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '16A: ABC / 3TC + RAL' , 1, null)) as 16A,
    count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '17A: ABC / 3TC + EFV', 1, null)) as 17A,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '0P: ABC/3TC + NVP' , 1, null)) as 0P,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '2P: AZT / 3TC / NVP' , 1, null)) as 2P,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "4PP: AZT 60 / 3TC 30 + EFV 200" , 1, null)) as 4PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "4PA: AZT 300 / 3TC 150 + EFV 200", 1, null)) as 4PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '9PP: ABC 120 / 3TC 60 + LPV/r 100/25', 1, null)) as 9PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '9PA: ABC 600 / 3TC 300 + LPV/r 100/25', 1, null)) as 9PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "11PP: AZT 60 / 3TC 30 + LPV/r 100/25" , 1, null)) as 11PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "11PA: AZT 300 / 3TC 150 + LPV/r 100/25", 1, null)) as 11PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "12PP: DRV 150 + r 50 + DTG 10 (± NRTIs)", 1, null)) as 12PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "12PA: DRV 150 + r 50 + DTG 50", 1, null)) as 12PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "14PP: AZT 60 / 3TC 30 + DTG 10", 1, null)) as 14PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "14PA: AZT 60 / 3TC 30 + DTG 50", 1, null)) as 14PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '15P: ABC / 3TC + DTG', 1, null)) as 15P,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = '15PP: ABC / 3TC + DTG', 1, null)) as 15PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "15PA: ABC 120 / 3TC 60 + DTG 50", 1, null)) as 15PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "16P: ABC / 3TC + RAL", 1, null)) as 16P,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "17PP: ABC 120 / 3TC 60 + EFV 200", 1, null)) as 17PP,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = "17PA: ABC 600 / 3TC 300 + EFV 200", 1, null)) as 17PA,
count(if(state = 'On antiretrovirals' and floor(datediff(_endDate,last_appt_date)) <=  _defaultCutOff and current_regimen = 'Non standard', 1, null)) as non_standard
from
(
	select * from hiv_cohort
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;
 
  end
#
