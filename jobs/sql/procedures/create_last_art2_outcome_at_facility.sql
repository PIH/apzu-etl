DROP PROCEDURE IF EXISTS create_last_art2_outcome_at_facility#
CREATE PROCEDURE `create_last_art2_outcome_at_facility`(IN _endDate DATE)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS last_facility_outcome;

    CREATE TEMPORARY TABLE last_facility_outcome(
		id INT PRIMARY KEY auto_increment,
		index_desc int,
		pat int,
		identifier varchar(50),
		state varchar(50),
		program varchar(50),
        program_state_id int,
        start_date date,
		end_date date,
		location varchar(150), 
		location_key int
	) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
	 INSERT INTO last_facility_outcome (index_desc, pat,identifier, state,program,program_state_id, start_date,end_date,location,location_key)
    select index_desc, pat,identifier, state,program,program_state_id, start_date,end_date,location, location_key 
from (
	SELECT
index_desc,
            opi.patient_id as pat,
            opi.identifier,
            index_descending.state,
            index_descending.location,
            index_descending.program,
start_date,
            program_state_id,
            end_date,
            l.source_key as location_key
FROM (SELECT
            @r:= IF(@u = patient_id, @r + 1,1) index_desc,
            location,
            state,
            program,
            start_date,
            end_date,
            patient_id,
            program_state_id,
            @u:= patient_id
      FROM omrs_program_state,
                    (SELECT @r:= 1) AS r,
                    (SELECT @u:= 0) AS u
                    where program = "HIV program"
                    and start_date <= _endDate
            ORDER BY patient_id DESC, start_date DESC, program_state_id DESC
            ) index_descending
            join omrs_patient_identifier opi on index_descending.patient_id = opi.patient_id
            and opi.location = index_descending.location
            and opi.type = "ARV Number"
            join lookup_location as l on opi.location = l.target_value
            where index_desc = 1
) each_outcome_at_facility;
END
#
