drop procedure if exists create_pepfar_tx_tml#
create  procedure `create_pepfar_tx_tml`(in _startDate date,in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int)
begin

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_ml(sort_value,age_group,gender,Died,IIT_3mo_or_less_mo,IIT_3to5_mo, IIT_6plus_mo,Transferred_out, Refused_Stopped)

select sort_value,x.age_group, case when x.gender = "F" then "Female" else "Male" end as gender,
case when Died is null then 0 else Died end as "Died",
case when  IIT_3mo_or_less_mo is null then 0 else IIT_3mo_or_less_mo end as "IIT_3mo_or_less_mo",
case when  IIT_3to5_mo is null then 0 else IIT_3to5_mo end as "IIT_3to5_mo",
case when  IIT_6plus_mo is null then 0 else IIT_6plus_mo end as "IIT_6plus_mo",
case when Transferred_out is null then 0 else Transferred_out end as "Transferred_out",
case when Refused_Stopped is null then 0 else Refused_Stopped end as "Refused_Stopped"
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
		count(if(((state = 'patient defaulted' and start_date between @startDate and @endDate )
    or (state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) >=  @defaultCutOff ))
    and patient_id in (select patient_id from mw_art_initial where (datediff( date_add(last_appt_date, interval @defaultCutOff DAY) , visit_date)) <=  90) , 1, null))
    as IIT_3mo_or_less_mo,

	count(if(((state = 'patient defaulted' and start_date between @startDate and @endDate )
    or (state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) >=  @defaultCutOff ))
    and patient_id in (select patient_id from mw_art_initial where ((datediff( date_add(last_appt_date, interval @defaultCutOff DAY) , visit_date)) >=  90 and
    (datediff( date_add(last_appt_date, interval @defaultCutOff  DAY), visit_date)) <=179)) , 1, null))
    as IIT_3to5_mo,

    count(if(((state = 'patient defaulted' and start_date between @startDate and @endDate )
    or (state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) >= @defaultCutOff ))
    and patient_id in (select patient_id from mw_art_initial where (datediff( date_add(last_appt_date, interval @defaultCutOff  DAY) , visit_date)) >=  180) , 1, null))
    as IIT_6plus_mo,

    count(if((state = 'Patient Died' and start_date between @startDate and @endDate), 1, null)) as Died,
    count(if((state = 'Treatment Stopped' and start_date between @startDate and @endDate), 1, null)) as Refused_Stopped,
     count(if((state = 'Patient transferred out' and start_date between @startDate and @endDate), 1, null)) as Transferred_out
from
(
select distinct(hv.patient_id), opi.identifier, mwp.first_name, mwp.last_name,  hv.state,hv.start_date,  mwp.gender,
 if(state = "On antiretrovirals",floor(datediff(@endDate,mwp.birthdate)/@birthDateDivider),floor(datediff(hv.start_date,mwp.birthdate)/@birthDateDivider)) as age,
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
end
#
