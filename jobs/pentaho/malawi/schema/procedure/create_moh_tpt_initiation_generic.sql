CREATE PROCEDURE `create_moh_tpt_initiation_generic`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT,
IN _ageGroup varchar(15))
BEGIN

call create_age_groups();
call create_hiv_cohort(_startDate,_endDate,_location,_birthDateDivider);

insert into moh_tpt_initiation(district,age_group,gender,new_start_three_hp,previous_start_three_hp,new_start_six_h,previous_start_six_h)

SELECT "Neno" as district, "All" as age_group, _ageGroup as gender,
COUNT(IF(((initial_visit_date >= @startDate and transfer_in_date is null) or start_date >= @startDate)
and ((first_inh_300 is not null and first_rfp_150 is not null) or first_rfp_inh is not null),1,NULL)) as new_start_three_hp,
COUNT(IF(((initial_visit_date >= @startDate and transfer_in_date is null) or start_date >= @startDate)
and (first_inh_300 is not null and first_rfp_150 is null),1,NULL)) as new_start_six_h,
COUNT(IF(initial_visit_date < @startDate and previous_ipt_date < date_sub(@startDate, interval 1 month)
and ((first_inh_300 is not null and first_rfp_150 is not null) or first_rfp_inh is not null),1,NULL)) as old_start_three_hp,
COUNT(IF(initial_visit_date < @startDate and previous_ipt_date < date_sub(@startDate, interval 2 month)
and (first_inh_300 is not null and first_rfp_150 is null),1,NULL)) as old_start_six_h
from hiv_cohort where  
	(case 
		WHEN _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F"
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		WHEN _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		WHEN _ageGroup = "Male"  then gender = "M"
	 end);

END
