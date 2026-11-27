CREATE PROCEDURE `create_last_mental_health_outcome_by_workflow`(IN _endDate DATE)
BEGIN
	-- Latest Mental Health Care Program state per patient PER WORKFLOW (one row per patient per condition workflow),
	-- e.g. 'Mental health treatment', 'Epilepsy treatment'.
	-- Use this for condition-specific reports. For "latest state in the program overall" use create_last_mental_health_outcome.
	DROP TEMPORARY TABLE IF EXISTS last_mental_health_workflow_outcome;

    CREATE TEMPORARY TABLE last_mental_health_workflow_outcome(
		id INT PRIMARY KEY auto_increment,
		index_desc int,
		pat int,
        identifier varchar(50),
		state varchar(50),
		program varchar(50),
		workflow varchar(100),
        program_state_id int,
        start_date date,
		end_date date,
		location varchar(150),
		KEY idx_pat_workflow (pat, workflow)
	) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
	 INSERT INTO  last_mental_health_workflow_outcome(index_desc, pat,identifier, state,program,workflow,program_state_id, start_date,end_date,location)
    select index_desc, pat,identifier, state,program,workflow,program_state_id, start_date,end_date,location
from (
	SELECT
index_desc,
            opi.patient_id as pat,
            opi.identifier,
            index_descending.state,
            index_descending.location,
            index_descending.program,
            index_descending.workflow,
start_date,
            program_state_id,
            end_date
FROM (SELECT
            @r:= IF(@u = patient_id AND @w = IFNULL(workflow, ''), @r + 1,1) index_desc,
            location,
            state,
            program,
            workflow,
            start_date,
            end_date,
            patient_id,
            program_state_id,
            @u:= patient_id,
            @w:= IFNULL(workflow, '')
      FROM omrs_program_state,
                    (SELECT @r:= 1) AS r,
                    (SELECT @u:= 0) AS u,
                    (SELECT @w:= '') AS w
                    where program IN ("Mental Health Care Program")
                    and start_date <= _endDate

            ORDER BY patient_id DESC, workflow, start_date DESC, program_state_id DESC
            ) index_descending
            join omrs_patient_identifier opi on index_descending.patient_id = opi.patient_id
            and opi.location = index_descending.location
            and opi.type = "Chronic Care Number"
            where index_desc = 1
) each_outcome_at_facility;
END
