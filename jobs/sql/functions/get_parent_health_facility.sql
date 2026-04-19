drop function if exists get_parent_health_facility#
create function `get_parent_health_facility`( location varchar(100) ) returns varchar(100) CHARSET utf8
deterministic
begin

    if location in ("Binje Outreach Clinic","Ntaja Outreach Clinic","Golden Outreach Clinic") 
    then
         return "Neno District Hospital";
	ELSEIF location in ("Felemu Outreach Clinic") 
    then
		return "Chifunga HC";
	ELSEIF location in ("Kasamba Outreach Clinic ") 
    then
		return "Midzemba HC";
	else
		return location;
	end if;

end
#
