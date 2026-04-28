drop procedure if exists create_pepfar_tx_tml_generic#
create procedure `create_pepfar_tx_tml_generic`(in _startDate date,in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int,
in _ageGroup varchar(15))
begin

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_ml(age_group, gender,Died,IIT_3mo_or_less_mo,IIT_3to5_mo,IIT_6plus_mo,Transferred_out,Refused_Stopped)

select "All" as age_group, _ageGroup as gender,
    count(if((state = 'Patient Died' and start_date between @startDate and @endDate), 1, null)) as Died,
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
     count(if((state = 'Patient transferred out' and start_date between @startDate and @endDate), 1, null)) as Transferred_out,
      count(if((state = 'Treatment Stopped' and start_date between @startDate and @endDate), 1, null)) as Refused_Stopped
from
(
	select * from hiv_cohort where  
	(case 
		when _ageGroup = "FP" then pregnant_or_lactating = "Patient Pregnant" and gender = "F"
		when _ageGroup = "FNP" then (pregnant_or_lactating = "No" or pregnant_or_lactating is null) and gender = "F"
		when _ageGroup = "FBF" then pregnant_or_lactating = "Currently breastfeeding child" and gender = "F"
		when _ageGroup = "Male"  then gender = "M"
	 end)
    
) sub1;

end
#
