CREATE FUNCTION `get_parent_health_facility`( location VARCHAR(100) ) RETURNS varchar(100) CHARSET utf8
BEGIN

    IF location IN ("Binje Outreach Clinic","Ntaja Outreach Clinic","Golden Outreach Clinic") 
    THEN
         RETURN "Neno District Hospital";
	ELSEIF location IN ("Felemu Outreach Clinic") 
    THEN
		RETURN "Chifunga HC";
	ELSEIF location IN ("Kasamba Outreach Clinic ") 
    THEN
		RETURN "Midzemba HC";
	ELSE
		RETURN location;
	END IF;

END
