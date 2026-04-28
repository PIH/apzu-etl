drop function if exists get_regimen_start#
/*
  This is a helper function specifically for the Consecutive High Viral Load Report. 
  See: api/src/main/resources/org/openmrs/module/pihmalawi/reporting/datasets/sql/consecutive-high-viral-load.sql

  The function expects the presence of a regimenStartTable and relies on an intenger patientID
  and the offsetNum determines the regimen to retrieve (0 for latest, 1 for second latest, etc).
  Returns the associated regimen start date. 

*/

create function get_regimen_start(patientId int, offsetNum int)
  returns date
deterministic
  begin
    declare ret date;
    
    select start_date into ret 
    from regimenStartTable2 
    where patient_id = patientId 
    order by start_date desc 
    limit 1 
    offset offsetNum;

    return ret;
  end
#
