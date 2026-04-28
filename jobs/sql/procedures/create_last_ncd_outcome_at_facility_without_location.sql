drop procedure if exists create_last_ncd_outcome_at_facility_without_location#
create procedure `create_last_ncd_outcome_at_facility_without_location`(in _endDate date)
begin
	drop TEMPORARY table if exists last_ncd_facility_outcome;

    create TEMPORARY table last_ncd_facility_outcome(
		id int primary key auto_increment,
		index_desc int,
		pat int,
		state varchar(50),
		program varchar(50),
        program_state_id int,
        start_date date,
		end_date date,
		location varchar(150)
	) default CHARACTER set utf8 default COLLATE utf8_general_ci;
	 insert into last_ncd_facility_outcome (index_desc, pat, state,program,program_state_id, start_date,end_date,location)
    select index_desc, pat, state,program,program_state_id, start_date,end_date,location
from (
	select
index_desc,
            opi.patient_id as pat,
            opi.identifier,
            index_descending.state,
            index_descending.location,
            index_descending.program,
start_date,
            program_state_id,
            end_date
from (select
            @r:= if(@u = patient_id, @r + 1,1) index_desc,
            location,
            state,
            program,
            start_date,
            end_date,
            patient_id,
            program_state_id,
            @u:= patient_id
      from omrs_program_state,
                    (select @r:= 1) as r,
                    (select @u:= 0) as u
                    where program in ("Mental Health Care Program","Chronic care program")
                    and start_date <= _endDate
            order by patient_id desc, start_date desc, program_state_id desc
            ) index_descending
            join omrs_patient_identifier opi on index_descending.patient_id = opi.patient_id
            and opi.location = index_descending.location
            and opi.type = "Chronic Care Number"
            where index_desc = 1
) each_outcome_at_facility;
end
#
