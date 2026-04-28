drop function if exists get_regimen#
/*
  This is a helper function specifically for the Consecutive High Viral Load Report. 
  See: api/src/main/resources/org/openmrs/module/pihmalawi/reporting/datasets/sql/consecutive-high-viral-load.sql

  The function expects the presence of a regimenStartTable and relies on an intenger patientID
  and the offsetNum determines the regimen to retrieve (0 for latest, 1 for second latest, etc).
  Returns the associated regimen (varchar). 

*/

create function get_regimen(patientId int, offsetNum int)
  returns varchar(100)
deterministic
  begin
    declare ret varchar(100);
    
    select regimen into ret 
    from regimenStartTable 
    where patient_id = patientId 
    order by start_date desc 
    limit 1 
    offset offsetNum;

    return ret;
  end
#
