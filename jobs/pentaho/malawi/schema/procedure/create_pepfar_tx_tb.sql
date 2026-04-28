CREATE PROCEDURE `create_pepfar_tx_tb`(IN _startDate DATE,IN _endDate DATE, IN _location VARCHAR(255),IN _defaultCutOff INT,IN _birthDateDivider INT)
BEGIN

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_tb(sort_value,age_group,gender,tx_curr,symptom_screen_alone,cxr_screen,mwrd_screen,
screened_for_tb_tx_new_pos,screened_for_tb_tx_new_neg,screened_for_tb_tx_prev_pos,screened_for_tb_tx_prev_neg,tb_rx_new,tb_rx_prev)

select sort_value,x.age_group, CASE WHEN x.gender = "F" THEN "Female" ELSE "Male" END as gender,
CASE WHEN tx_curr is null then 0 else tx_curr end as tx_curr,
CASE WHEN symptom_screen_alone is null then 0 else symptom_screen_alone end as symptom_screen_alone,
"0" as cxr_screen,
"0" as mwrd_screen,
CASE WHEN screened_for_tb_tx_new_pos is null then 0 else screened_for_tb_tx_new_pos end as screened_for_tb_tx_new_pos,
CASE WHEN screened_for_tb_tx_new_neg is null then 0 else screened_for_tb_tx_new_neg end as  screened_for_tb_tx_new_neg,
CASE WHEN screened_for_tb_tx_prev_pos is null then 0 else screened_for_tb_tx_prev_pos end as screened_for_tb_tx_prev_pos,
CASE WHEN screened_for_tb_tx_prev_neg is null then 0 else screened_for_tb_tx_prev_neg end as screened_for_tb_tx_prev_neg,
CASE WHEN tb_rx_new is null then 0 else tb_rx_new end as tb_rx_new,
CASE WHEN tb_rx_prev is null then 0 else tb_rx_prev end as tb_rx_prev
 from
age_groups as x
LEFT OUTER JOIN
(
SELECT CASE
WHEN age <= 11 and gender = "M" THEN "<1 year"
WHEN age <= 11 and gender = "F" THEN "<1 year"
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
WHEN age >=540 and age <= 599 and gender = "F" THEN "45-49 years"
WHEN age >=600 and age <=659 and gender = "M" THEN "50-54 years"
WHEN age >=600 and age <=659 and gender = "F" THEN "50-54 years"
WHEN age >=660 and age <=719 and gender = "M" THEN "55-59 years"
WHEN age >=660 and age <=719 and gender = "F" THEN "55-59 years"
WHEN age >=720 and age <=779 and gender = "M" THEN "60-64 years"
WHEN age >=720 and age <=779 and gender = "F" THEN "60-64 years"
WHEN age >=780 and age <=839 and gender = "M" THEN "65-69 years"
WHEN age >=780 and age <=839 and gender = "F" THEN "65-69 years"
WHEN age >=840 and age <=899 and gender = "M" THEN "70-74 years"
WHEN age >=840 and age <=899 and gender = "F" THEN "70-74 years"
WHEN age >=900 and age <=959 and gender = "M" THEN "75-79 years"
WHEN age >=900 and age <=959 and gender = "F" THEN "75-79 years"
WHEN age >=960 and age <=1019 and gender = "M" THEN "80-84 years"
WHEN age >=960 and age <=1019 and gender = "F" THEN "80-84 years"
WHEN age >=1020 and age<=1079 and gender = "M" THEN "85-89 years"
WHEN age >=1020 and age<=1079 and gender = "F" THEN "85-89 years"
WHEN age >=1080 and gender = "M" THEN "90 plus years"
WHEN age >=1080 and gender = "F" THEN "90 plus years"
END as age_group,gender,
    COUNT(IF((state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) <=  @defaultOneMonth), 1, NULL)) as tx_curr,
    COUNT(if(tb_status in ("TB suspected","TB NOT suspected","Confirmed TB on treatment","Confirmed TB NOT on treatment"),1,NULL)) as symptom_screen_alone,
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
select distinct(mwp.patient_id), opi.identifier, mwp.first_name, mwp.last_name, ops.program, ops.state,ops.start_date,program_state_id,  mwp.gender,
 If(ops.state = "On antiretrovirals",floor(datediff(@endDate,mwp.birthdate)/@birthDateDivider),floor(datediff(ops.start_date,mwp.birthdate)/@birthDateDivider)) as age,
 ops.location, last_appt_date, followup_visit_date, initial_visit_date,
 hc.transfer_in_date, tb_status
 from hiv_cohort hc
 join mw_patient mwp on hc.patient_id= mwp.patient_id
 join omrs_patient_identifier opi
 on mwp.patient_id = opi.patient_id

JOIN
         last_facility_outcome as ops
            on opi.patient_id = ops.pat and opi.location = ops.location
            where opi.type = "ARV Number"
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;

END
