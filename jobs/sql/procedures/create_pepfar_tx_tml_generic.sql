DROP PROCEDURE IF EXISTS create_pepfar_tx_tml_generic#
CREATE PROCEDURE `create_pepfar_tx_tml_generic`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT,
IN _ageGroup varchar(15))
BEGIN

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_ml(age_group, gender,Died,IIT_3mo_or_less_mo,IIT_3to5_mo,IIT_6plus_mo,Transferred_out,Refused_Stopped)

SELECT "All" as age_group, _ageGroup as gender,
    COUNT(IF((state = 'Patient Died' and start_date BETWEEN @startDate AND @endDate), 1, NULL)) as Died,
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
     COUNT(IF((state = 'Patient transferred out' and start_date BETWEEN @startDate AND @endDate), 1, NULL)) as Transferred_out,
      COUNT(IF((state = 'Treatment Stopped' and start_date BETWEEN @startDate AND @endDate), 1, NULL)) as Refused_Stopped
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
#
