drop procedure if exists create_moh_tpt_initiation#
create procedure `create_moh_tpt_initiation`(in _startDate date, in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int)
begin

call create_age_groups();
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into moh_tpt_initiation(sort_value,district,age_group,gender,new_start_three_hp,previous_start_three_hp,new_start_six_h,previous_start_six_h)

select sort_value,@district as district,x.age_group, case when x.gender="F" then 'Female' else 'Male' end as gender,
case when new_start_three_hp is null then 0 else new_start_three_hp end as new_start_three_hp,
case when old_start_three_hp is null then 0 else old_start_three_hp end as previous_start_three_hp,
case when new_start_six_h is null then 0 else new_start_six_h end as new_start_six_h,
case when old_start_six_h is null then 0 else old_start_six_h end as previous_start_six_h
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
count(if(((initial_visit_date >= @startDate and transfer_in_date is null) or start_date >= @startDate)
and ((first_inh_300 is not null and first_rfp_150 is not null) or first_rfp_inh is not null),1,null)) as new_start_three_hp,
count(if(((initial_visit_date >= @startDate and transfer_in_date is null) or start_date >= @startDate)
and (first_inh_300 is not null and first_rfp_150 is null),1,null)) as new_start_six_h,
count(if(initial_visit_date < @startDate and previous_ipt_date < date_sub(@startDate, interval 1 month)
and ((first_inh_300 is not null and first_rfp_150 is not null) or first_rfp_inh is not null),1,null)) as old_start_three_hp,
count(if(initial_visit_date < @startDate and previous_ipt_date < date_sub(@startDate, interval 2 month)
and (first_inh_300 is not null and first_rfp_150 is null),1,null)) as old_start_six_h
from
(
	select * from hiv_cohort where
	(first_inh_300 is not null or first_rfp_150 is not null or first_rfp_inh is not null)
and first_ipt_date >= @startDate
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;

end
#
