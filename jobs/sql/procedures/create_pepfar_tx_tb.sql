drop procedure if exists create_pepfar_tx_tb#
create procedure `create_pepfar_tx_tb`(in _startDate date,in _endDate date, in _location varchar(255),in _defaultCutOff int,in _birthDateDivider int)
begin

call create_age_groups();
call create_last_art_outcome_at_facility(@endDate,@location);
call create_hiv_cohort(@startDate,@endDate,@location,@birthDateDivider);

insert into pepfar_tx_tb(sort_value,age_group,gender,tx_curr,symptom_screen_alone,cxr_screen,mwrd_screen,
screened_for_tb_tx_new_pos,screened_for_tb_tx_new_neg,screened_for_tb_tx_prev_pos,screened_for_tb_tx_prev_neg,tb_rx_new,tb_rx_prev)

select sort_value,x.age_group, case when x.gender = "F" then "Female" else "Male" end as gender,
case when tx_curr is null then 0 else tx_curr end as tx_curr,
case when symptom_screen_alone is null then 0 else symptom_screen_alone end as symptom_screen_alone,
"0" as cxr_screen,
"0" as mwrd_screen,
case when screened_for_tb_tx_new_pos is null then 0 else screened_for_tb_tx_new_pos end as screened_for_tb_tx_new_pos,
case when screened_for_tb_tx_new_neg is null then 0 else screened_for_tb_tx_new_neg end as  screened_for_tb_tx_new_neg,
case when screened_for_tb_tx_prev_pos is null then 0 else screened_for_tb_tx_prev_pos end as screened_for_tb_tx_prev_pos,
case when screened_for_tb_tx_prev_neg is null then 0 else screened_for_tb_tx_prev_neg end as screened_for_tb_tx_prev_neg,
case when tb_rx_new is null then 0 else tb_rx_new end as tb_rx_new,
case when tb_rx_prev is null then 0 else tb_rx_prev end as tb_rx_prev
 from
age_groups as x
left outer join
(
select case
when age <= 11 and gender = "M" then "<1 year"
when age <= 11 and gender = "F" then "<1 year"
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
when age >=540 and age <= 599 and gender = "F" then "45-49 years"
when age >=600 and age <=659 and gender = "M" then "50-54 years"
when age >=600 and age <=659 and gender = "F" then "50-54 years"
when age >=660 and age <=719 and gender = "M" then "55-59 years"
when age >=660 and age <=719 and gender = "F" then "55-59 years"
when age >=720 and age <=779 and gender = "M" then "60-64 years"
when age >=720 and age <=779 and gender = "F" then "60-64 years"
when age >=780 and age <=839 and gender = "M" then "65-69 years"
when age >=780 and age <=839 and gender = "F" then "65-69 years"
when age >=840 and age <=899 and gender = "M" then "70-74 years"
when age >=840 and age <=899 and gender = "F" then "70-74 years"
when age >=900 and age <=959 and gender = "M" then "75-79 years"
when age >=900 and age <=959 and gender = "F" then "75-79 years"
when age >=960 and age <=1019 and gender = "M" then "80-84 years"
when age >=960 and age <=1019 and gender = "F" then "80-84 years"
when age >=1020 and age<=1079 and gender = "M" then "85-89 years"
when age >=1020 and age<=1079 and gender = "F" then "85-89 years"
when age >=1080 and gender = "M" then "90 plus years"
when age >=1080 and gender = "F" then "90 plus years"
end as age_group,gender,
    count(if((state = 'On antiretrovirals' and floor(datediff(@endDate,last_appt_date)) <=  @defaultOneMonth), 1, null)) as tx_curr,
    count(if(tb_status in ("TB suspected","TB NOT suspected","Confirmed TB on treatment","Confirmed TB NOT on treatment"),1,null)) as symptom_screen_alone,
    count(if(tb_status = "TB suspected" and (
    initial_visit_date between @startDate and @endDate and transfer_in_date is null and patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as screened_for_tb_tx_new_pos,
    count(if(tb_status = "TB NOT suspected" and (
    initial_visit_date between @startDate and @endDate and transfer_in_date is null and patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as screened_for_tb_tx_new_neg,
    count(if(tb_status = "TB suspected"
    and
    initial_visit_date < @startDate
    , 1, null)) as screened_for_tb_tx_prev_pos,
    count(if(tb_status = "TB NOT suspected"
    and
    initial_visit_date < @startDate
    , 1, null)) as screened_for_tb_tx_prev_neg,
    count(if(tb_status = "Confirmed TB on treatment"
    and (
    initial_visit_date between @startDate and @endDate and transfer_in_date is null and patient_id not in (
	select patient_id from omrs_patient_identifier where type = "ARV Number" and location != @location)
    and patient_id in(select patient_id from omrs_patient_identifier where type = "ARV Number" and location = @location
    ))
    , 1, null)) as tb_rx_new,
    count(if(tb_status = "Confirmed TB NOT on treatment"
    and (
    initial_visit_date < @startDate
    )
    , 1, null)) as tb_rx_prev
from
(
select distinct(mwp.patient_id), opi.identifier, mwp.first_name, mwp.last_name, ops.program, ops.state,ops.start_date,program_state_id,  mwp.gender,
 if(ops.state = "On antiretrovirals",floor(datediff(@endDate,mwp.birthdate)/@birthDateDivider),floor(datediff(ops.start_date,mwp.birthdate)/@birthDateDivider)) as age,
 ops.location, last_appt_date, followup_visit_date, initial_visit_date,
 hc.transfer_in_date, tb_status
 from hiv_cohort hc
 join mw_patient mwp on hc.patient_id= mwp.patient_id
 join omrs_patient_identifier opi
 on mwp.patient_id = opi.patient_id

join
         last_facility_outcome as ops
            on opi.patient_id = ops.pat and opi.location = ops.location
            where opi.type = "ARV Number"
)sub1
 group by age_group,gender, location
 order by gender,age_group,location, state
 ) cohort on x.age_group = cohort.age_group
 and x.gender = cohort.gender
 order by sort_value;

end
#
