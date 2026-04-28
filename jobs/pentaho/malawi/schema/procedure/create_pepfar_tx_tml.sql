CREATE  PROCEDURE `create_pepfar_tx_tml`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT)
BEGIN

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_ml(sort_value,age_group,gender,Died,IIT_3mo_or_less_mo,IIT_3to5_mo, IIT_6plus_mo,Transferred_out, Refused_Stopped)

select sort_value,x.age_group, CASE WHEN x.gender = "F" THEN "Female" ELSE "Male" END as gender,
CASE WHEN Died is null then 0 else Died end as "Died",
CASE WHEN  IIT_3mo_or_less_mo is null then 0 else IIT_3mo_or_less_mo end as "IIT_3mo_or_less_mo",
CASE WHEN  IIT_3to5_mo is null then 0 else IIT_3to5_mo end as "IIT_3to5_mo",
CASE WHEN  IIT_6plus_mo is null then 0 else IIT_6plus_mo end as "IIT_6plus_mo",
CASE WHEN Transferred_out is null then 0 else Transferred_out end as "Transferred_out",
CASE WHEN Refused_Stopped is null then 0 else Refused_Stopped end as "Refused_Stopped"
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
		COUNT(IF(((state = 'patient defaulted' and start_date BETWEEN @startDate AND @endDate )
    or (state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) >=  @defaultCutOff ))
    and patient_id in (select patient_id from mw_art_initial where (datediff( date_add(last_appt_date, interval @defaultCutOff DAY) , visit_date)) <=  90) , 1, NULL))
    as IIT_3mo_or_less_mo,

	COUNT(IF(((state = 'patient defaulted' and start_date BETWEEN @startDate AND @endDate )
    or (state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) >=  @defaultCutOff ))
    and patient_id in (select patient_id from mw_art_initial where ((datediff( date_add(last_appt_date, interval @defaultCutOff DAY) , visit_date)) >=  90 and
    (datediff( date_add(last_appt_date, interval @defaultCutOff  DAY), visit_date)) <=179)) , 1, NULL))
    as IIT_3to5_mo,

    COUNT(IF(((state = 'patient defaulted' and start_date BETWEEN @startDate AND @endDate )
    or (state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) >= @defaultCutOff ))
    and patient_id in (select patient_id from mw_art_initial where (datediff( date_add(last_appt_date, interval @defaultCutOff  DAY) , visit_date)) >=  180) , 1, NULL))
    as IIT_6plus_mo,

    COUNT(IF((state = 'Patient Died' and start_date BETWEEN @startDate AND @endDate), 1, NULL)) as Died,
    COUNT(IF((state = 'Treatment Stopped' and start_date BETWEEN @startDate AND @endDate), 1, NULL)) as Refused_Stopped,
     COUNT(IF((state = 'Patient transferred out' and start_date BETWEEN @startDate AND @endDate), 1, NULL)) as Transferred_out
from
(
select distinct(hv.patient_id), opi.identifier, mwp.first_name, mwp.last_name,  hv.state,hv.start_date,  mwp.gender,
 If(state = "On antiretrovirals",floor(datediff(@endDate,mwp.birthdate)/@birthDateDivider),floor(datediff(hv.start_date,mwp.birthdate)/@birthDateDivider)) as age,
 hv.location, last_appt_date
from hiv_cohort hv
join 
  mw_patient mwp on hv.patient_id=mwp.patient_id
  
join omrs_patient_identifier opi 
on hv.patient_id = opi.patient_id and opi.type = "ARV Number" and opi.location = hv.location
          
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;
END
