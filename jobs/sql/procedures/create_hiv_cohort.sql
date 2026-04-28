drop procedure if exists create_hiv_cohort#
create procedure `create_hiv_cohort`(in _startDate date,in _endDate date, in _location varchar(255),in _birthDateDivider int)
begin

drop TEMPORARY table if exists hiv_cohort;
     create TEMPORARY table hiv_cohort(
         id int primary key auto_increment,
         patient_id int,
         identifier varchar(20),
         state varchar(50),
         start_date date,
         gender varchar(10),
         age int,
         location varchar(50),
         last_appt_date date,
         current_regimen varchar(100),
         pregnant_or_lactating varchar(100),
         initial_visit_date date,
         initial_pregnant_or_lactating varchar(100),
         transfer_in_date date,
         first_ipt_date date,
         first_inh_300 varchar(50),
         first_inh_300_pills int,
         first_rfp_150 varchar(50),
         first_rfp_150_pills int,
         first_rfp_inh varchar(50),
         first_rfp_inh_pills int,
		 last_inh_300 varchar(50),
         last_inh_300_pills int,
         last_rfp_150 varchar(50),
         last_rfp_150_pills int,
         last_rfp_inh varchar(50),
         last_rfp_inh_pills int,
		 last_ipt_date date,
         previous_inh_300 varchar(50),
         previous_inh_300_pills int,
         previous_rfp_150 varchar(50),
         previous_rfp_150_pills int,
         previous_rfp_inh varchar(50),
         previous_rfp_inh_pills int,
		 previous_ipt_date date,
		 systolic_bp int,
         diastolic_bp int,
         followup_visit_date date
     );

call create_last_art_outcome_at_facility(_endDate,_location);

insert into hiv_cohort(patient_id,identifier,state,start_date,gender,age,location,last_appt_date,current_regimen,
pregnant_or_lactating,initial_pregnant_or_lactating,initial_visit_date,transfer_in_date,first_ipt_date,first_inh_300,first_inh_300_pills,
first_rfp_150,first_rfp_150_pills,first_rfp_inh,first_rfp_inh_pills,last_inh_300,last_inh_300_pills,last_rfp_150,last_rfp_150_pills,last_rfp_inh,last_rfp_inh_pills,last_ipt_date,previous_inh_300,previous_inh_300_pills,previous_rfp_150,
 previous_rfp_150_pills,previous_rfp_inh,previous_rfp_inh_pills,previous_ipt_date, systolic_bp, diastolic_bp, followup_visit_date)

select distinct(mwp.patient_id) as patient_id, opi.identifier,ops.state,ops.start_date, mwp.gender,
 if(ops.state = "On antiretrovirals",floor(datediff(_endDate,mwp.birthdate)/_birthDateDivider),floor(datediff(ops.start_date,mwp.birthdate)/_birthDateDivider)) as age, 
 ops.location, patient_visit.last_appt_date, patient_visit.art_regimen as current_regimen, 
 patient_visit.pregnant_or_lactating, patient_initial_visit.initial_pregnant_or_lactating, patient_initial_visit.initial_visit_date,
 patient_initial_visit.transfer_in_date,first_ipt_date,first_inh_300,first_inh_300_pills,first_rfp_150,first_rfp_150_pills,first_rfp_inh,first_rfp_inh_pills,last_inh_300,last_inh_300_pills,last_rfp_150,
 last_rfp_150_pills,last_rfp_inh,last_rfp_inh_pills,last_ipt_date,previous_inh_300,previous_inh_300_pills,previous_rfp_150,
 previous_rfp_150_pills,previous_rfp_inh,previous_rfp_inh_pills,previous_ipt_date, systolic_bp, diastolic_bp, followup_visit_date
from  mw_patient mwp  
left join (
	select map.patient_id, map.visit_date as followup_visit_date, map.next_appointment_date as last_appt_date, map.art_regimen, 
    map.pregnant_or_lactating,systolic_bp, diastolic_bp
    from mw_art_followup map
join
(
	select patient_id,max(visit_date) as visit_date ,max(next_appointment_date) as last_appt_date from mw_art_followup where visit_date <= _endDate
	group by patient_id
	) map1
on map.patient_id = map1.patient_id and map.visit_date = map1.visit_date) patient_visit
            on patient_visit.patient_id = mwp.patient_id
left join (
	select map.patient_id, map.visit_date as last_ipt_date, map.inh_300 as last_inh_300,
    map.inh_300_pills as last_inh_300_pills,map.rfp_150 as last_rfp_150,map.rfp_150_pills as last_rfp_150_pills,
    map.rfp_inh as last_rfp_inh,map.rfp_inh_pills as last_rfp_inh_pills
    from mw_art_followup map
join
(
	select patient_id,max(visit_date) as visit_date 
    from mw_art_followup where visit_date between _startDate and _endDate and
    ((inh_300 is not null or inh_300_pills is not null) or (rfp_150 is not null or rfp_150_pills is not null) or (rfp_inh is not null or rfp_inh_pills is not null)) 
	group by patient_id
	) map1
on map.patient_id = map1.patient_id and map.visit_date = map1.visit_date) last_ipt_visit
            on last_ipt_visit.patient_id = mwp.patient_id
            
            
left join (
	select map.patient_id, map.visit_date as previous_ipt_date, map.inh_300 as previous_inh_300,
    map.inh_300_pills as previous_inh_300_pills,map.rfp_150 as previous_rfp_150,map.rfp_150_pills as previous_rfp_150_pills,
    map.rfp_inh as previous_rfp_inh,map.rfp_inh_pills as previous_rfp_inh_pills
    from mw_art_followup map
join
(
	select patient_id,max(visit_date) as visit_date 
    from mw_art_followup where visit_date <= DATE_SUB(_startDate, INTERVAL 1 DAY) and
    ((inh_300 is not null or inh_300_pills is not null) or (rfp_150 is not null or rfp_150_pills is not null) or (rfp_inh is not null or rfp_inh_pills is not null)) 
	group by patient_id
	) map1
on map.patient_id = map1.patient_id and map.visit_date = map1.visit_date) before_start_date_ipt_visit
            on before_start_date_ipt_visit.patient_id = mwp.patient_id            
            
            
            
left join (
	select map.patient_id, map.visit_date as first_ipt_date, map.next_appointment_date as last_appt_date, map.art_regimen, 
    map.pregnant_or_lactating, map.inh_300 as first_inh_300,map.inh_300_pills as first_inh_300_pills,
    map.rfp_150 as first_rfp_150,map.rfp_150_pills as first_rfp_150_pills, map.rfp_inh as first_rfp_inh,map.rfp_inh_pills as first_rfp_inh_pills
    from mw_art_followup map
join
(
	select patient_id,min(visit_date) as visit_date 
    from mw_art_followup where visit_date between _startDate and _endDate and
    ((inh_300 is not null or inh_300_pills is not null) or (rfp_150 is not null or rfp_150_pills is not null) or (rfp_inh is not null or rfp_inh_pills is not null)) 
	group by patient_id
	) map1
on map.patient_id = map1.patient_id and map.visit_date = map1.visit_date) min_patient_visit
            on min_patient_visit.patient_id = mwp.patient_id            
left join (
	select mar.patient_id, mar.visit_date as initial_visit_date, 
    mar.pregnant_or_lactating as initial_pregnant_or_lactating, mar.transfer_in_date
    from mw_art_initial mar
join
(
	select patient_id,max(visit_date) as visit_date  from mw_art_initial where visit_date <= _endDate
	group by patient_id
	) mar1
on mar.patient_id = mar1.patient_id and mar.visit_date = mar1.visit_date) patient_initial_visit
            on patient_initial_visit.patient_id = mwp.patient_id
join omrs_patient_identifier opi
on mwp.patient_id = opi.patient_id
	
join
         last_facility_outcome as ops
            on opi.patient_id = ops.pat and opi.location = ops.location
            where opi.type = "ARV Number";
            
end
#
